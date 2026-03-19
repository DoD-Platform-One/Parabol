# Load Balancer Configuration for Parabol

Parabol is a WebSocket-based application that requires specific load balancer settings to function correctly in a multi-replica deployment. This guide covers the essential configuration needed to properly route traffic, maintain persistent connections, and enforce security headers.

Parabol exposes a single Kubernetes Service (`parabol-service`) of type `ClusterIP` on port `3000`. Depending on the asset-serving configuration, traffic is handled either by the Node.js process directly or fronted by an Nginx sidecar (see [servingAssets.md](servingAssets.md)).

---

## Requirements and Recommended Settings

### Session Affinity (Sticky Sessions)

Parabol maintains in-memory WebSocket state per pod, so all requests from a given client **must be routed to the same pod** throughout a session. Use **cookie-based affinity** with a **120s TTL** to allow graceful failover without breaking active sessions.

### WebSocket Support

WebSocket connections use HTTP/1.1 with an `Upgrade` header. The load balancer must forward this header and keep the underlying TCP connection open. Connections for active meetings can remain open for several hours.

| Timeout | Recommended value | Notes |
|---------|-------------------|-------|
| Idle / read timeout | `86400s` (24h) | Matches the Nginx sidecar `proxy_read_timeout` |
| Write timeout | `86400s` (24h) | |
| Keepalive timeout | `620s` | Matches the Nginx sidecar `keepalive_timeout` |

### TLS Termination

TLS should be terminated at the load balancer. The Parabol pods communicate in plain HTTP internally:

- Configure the load balancer listener for HTTPS (port 443).
- The backend target group / upstream uses HTTP to reach `parabol-service:3000`.
- Forward the `X-Forwarded-Proto: https` header so Parabol generates correct URLs and redirects.

Set the `PROTO` environment variable in the deployment:

```yaml
parabolDeployment:
  env:
    protocol: https
```

---

## Configuration Examples

### NGINX Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: parabol-ingress
  annotations:
    # TLS redirect
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"

    # WebSocket support
    nginx.ingress.kubernetes.io/proxy-read-timeout: "86400"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "86400"
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      add_header Strict-Transport-Security "max-age=63072000" always;
      add_header X-Frame-Options "DENY" always;

    # Session affinity (120s TTL)
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-max-age: "120"

spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - parabol.example.com
      secretName: parabol-tls
  rules:
    - host: parabol.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: parabol-service
                port:
                  number: 3000
```

---

### AWS Application Load Balancer (ALB)

**Session affinity** — enable stickiness on the target group:

```bash
aws elbv2 modify-target-group-attributes \
  --target-group-arn <TARGET_GROUP_ARN> \
  --attributes \
    Key=stickiness.enabled,Value=true \
    Key=stickiness.type,Value=lb_cookie \
    Key=stickiness.lb_cookie.duration_seconds,Value=120
```

**WebSocket support** — ALB supports WebSockets natively. Set the idle timeout:

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <LB_ARN> \
  --attributes Key=idle_timeout.timeout_seconds,Value=86400
```

---

### GCP GCE Ingress

```yaml
# BackendConfig — session affinity, WebSocket timeout, health check
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: parabol-backendconfig
spec:
  sessionAffinity:
    affinityType: GENERATED_COOKIE
    affinityCookieTtlSec: 120
  timeoutSec: 86400
  connectionDraining:
    drainingTimeoutSec: 0 # When Parabol pods stops, after its graceful shutdown process, the connection must be cut
  healthCheck:
    checkIntervalSec: 15
    timeoutSec: 5
    healthyThreshold: 1
    unhealthyThreshold: 2
    type: HTTP
    requestPath: /nginx-health   # or / if Nginx sidecar is not enabled
    port: 3000
---
# Service — annotated to reference the BackendConfig
apiVersion: v1
kind: Service
metadata:
  name: parabol-service
  annotations:
    cloud.google.com/backend-config: '{"default": "parabol-backendconfig"}'
spec:
  type: NodePort   # GCE Ingress requires NodePort or LoadBalancer, not ClusterIP
  ports:
    - name: webserver
      port: 3000
      targetPort: webserver
  selector:
    app.kubernetes.io/component: webserver
    app.kubernetes.io/name: parabol
---
# Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: parabol-ingress
  annotations:
    kubernetes.io/ingress.class: "gce"
    kubernetes.io/ingress.allow-http: "false"   # HTTPS only
spec:
  tls:
    - hosts:
        - parabol.example.com
      secretName: parabol-tls
  rules:
    - host: parabol.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: parabol-service
                port:
                  number: 3000
```
