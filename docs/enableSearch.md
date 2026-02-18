# Enable Search
To enable search in Parabol the Embedder and Text Embeddings Inference must be deployed and configured.

## Enable Embedder

Add the following to the `values.yaml` file to enable the embedder and set the resources requests and limits:

```yaml
embedder:
  enabled: true
  resources:
    requests:
      cpu: 250m
      memory: 2Gi
    limits:
      memory: 2Gi
```

## Enable Text Embeddings Inference

Add the following to the `values.yaml` file to enable the text embeddings inference and set the resources requests and limits:

```yaml
textEmbeddingsInference:
  enabled: true
  resources:
    requests:
      cpu: 1000m
      memory: 3.5Gi
    limits:
      cpu: 3000m
      memory: 3.5Gi
```

Text Embeddings Inference can consume a lot of CPU and it is highly recommended to set a limit to it.

For now, Parabol in P1 runs with only one defined CPU based model.

## Other required settings

Add the following to the `values.yaml` file to set the embedding model, the generation model, the number of embedder workers and enable pgvector in Postgres:

```yaml
parabolDeployment:
  additionalEnv:
    - name: "AI_EMBEDDING_MODELS"
      value: "[{\"model\": \"text-embeddings-inference:Svenni551/Qwen3-Embedding-0.6B-ONNX-INT8\", \"url\": \"http://parabol-text-embeddings-inference:3040/\", \"maxTokens\": 1024}]"
    - name: "AI_GENERATION_MODELS"
      value: "[{\"model\": \"text-generation-inference:TheBloke/zephyr-7b-beta\", \"url\": \"http://parabol-text-embeddings-inference:3040/\", \"maxTokens\": 512}]"
    - name: "AI_EMBEDDER_WORKERS"
      value: "2"
    - name: "POSTGRES_USE_PGVECTOR"
      value: "true"
```