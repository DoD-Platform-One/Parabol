# Parabol deployment checklist
#### Predeployment
- [ ] Server secret has been generated and configured
- [ ] Set Internal Auth to 'true' & create admin user
- [ ] Add a superuser(s) - see below

#### After the first deployment
- [ ] [SSO - SAML](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#saml-allow-all-domains-within-single-instance)
- [ ] Disable Internal Auth once SSO is set up
- [ ] [Mattermost Integration](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#mattermost) 
- [ ] [JIRA Server Integration](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#jira-server)
- [ ] Enable security banner for corresponding IL

## REST API
Our API can be accessed via a REST/HTTP client but exchanges GraphQL JSON documents. To access the API and its documentation, you'll need to update your Parabol user to have superuser access ("su") and then navigate to the `/admin/graphql` route in a web browser

### Superuser
**Note:** A user will have to exist in the db before this can be done

1. Shell into the webserver pod and run the following command (with the admin
   email)
    ```
    node dist/assignSURole.js --add EMAIL_TO_ADD
    ```
2. Logout then log back in to the UI.