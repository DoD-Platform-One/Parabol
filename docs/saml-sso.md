# Configuring Parabol SSO (SAML)

1. Set `authInternalDisabled: false` to allow login through user/pass.
    - If you've never logged in, make an admin account and save the login info
    somewhere safe.

2. Shell into the webserver pod and run the following command (with the admin
   email)
    ```
    node dist/assignSURole.js --add EMAIL_TO_ADD
    ```
3. Logout then log back in to the UI.

4. Disable email verification by running the following GraphQL query. Navigate
   to `https://YOUR.DOMAIN/admin/graphql` and run the following:
    ```
    mutation VerifyDomains {
      verifyDomain(orgId: "xxxxx", slug: "yyyyy", addDomains: ["YOUR.DOMAIN"], removeDomains: []) {
        __typename
        ...on ErrorPayload {
          error {
            message
          }
        }
        ...on VerifyDomainSuccess {
          saml {
            id
            domains
          }
        }
      }
    }
    ```
    - To get `orgId`, create an organization, navigate to the settings, and find
    the ID in the URL.
    - `slug` can be whatever.
    - Add the email domain you will be using for SSO (for example, `google.com`).
      - Don't worry, all domains will work, it just needs the one you'll be
      using initially.
5. Go back to the UI, navigate to the organization settings -> Authentication.

6. Paste the metadata URL from your identity provider and click
   `Update Metadata`, it will prompt you to go through the SSO process.

7. Set `authInternalDisabled: true` to disable login through user/pass.

8. You have successfully configured SSO!

