### Parabol deployment checklist
#### Predeployment
- [ ] Server secret has been generated and configured
- [ ] Set Internal Auth to 'true' & create admin user
- [ ] Add a superuser(s)

#### After the first deployment
- [ ] [SSO - SAML](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#saml-allow-all-domains-within-single-instance)
- [ ] Disable Internal Auth once SSO is set up
- [ ] [Mattermost Integration](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#mattermost) 
- [ ] [JIRA Server Integration](https://repo1.dso.mil/big-bang/product/community/parabol/-/blob/main/chart/README.md#jira-server)
- [ ] Enable security banner for corresponding IL