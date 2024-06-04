## Integrations

### Mattermost
Parabol leverages Mattermost's incoming webhook feature to connect a team to a channel.

See https://developers.mattermost.com/integrate/webhooks/incoming/ to create an incoming webhook

Add that url in Parabol team settings > integrations > mattermost > add webhook

### JIRA Server
#### Preparation

- create a new folder and run [this script](https://github.com/ParabolInc/parabol/blob/master/scripts/create-jira-keys.sh)

    
    ```bash
    cd parabol-keys
    mkdir guideline
    ./scripts/create-jira-keys.sh
    ```
You will need the output from the script to configure the integration on both the Parabol and JIRA applications.

#### These steps require JIRA admin permissions and are performed on the JIRA server instance

- Navigate to JIRA administration > Applications > Application links
- Create a new application link for Parabol
- Select `Atlassian Product` for type and enter the Parabol URL for the corresponding environment (ex. parabol.preprod.dso.mil) and select continue
- You may get a confirmation window about the URL that was entered, hit continue
- In the create link window enter the following:
    - Application Name (ex. parabol integration)
    - Check the `create incoming link` checkbox
- Hit continue
- In the incoming link window you will need to enter the following:
    - `Consumer key`
    - `Consumer name` (same consumer name entered from the previous step)
    - `Public Key`
- Those items are the same from the script that was run in the preparation step

#### Parabol configuration
A superuser will need to run this migration from the graphql endpoint
- Navigate to Admin graphql endpoint at https://your-parabol-instance/admin/graphql
- Run the following mutation and replace the needed information parabol team id, jira server base url, consumer key, private key
```
mutation AddJiraServer {
  addIntegrationProvider(input: {
    teamId: "<PARABOL_TEAM_ID>"
    service: jiraServer
    authStrategy: oauth1
    scope:org
    oAuth1ProviderMetadataInput: {
      serverBaseUrl: "<YOUR_JIRA_SERVER_URL>"
      consumerKey: "<CONSUMER_KEY>"
      consumerSecret: """-----BEGIN RSA PRIVATE KEY-----
<PRIVATE_KEY>
-----END RSA PRIVATE KEY-----
"""
    }
  }) {
    __typename
    ... on AddIntegrationProviderSuccess {
      provider {
        id
        isActive
        teamId
        ... on IntegrationProviderOAuth1 {
          id
          serverBaseUrl
        }
      }
    }
  }
}
```
Once the provider has been validated, each team member will need to connect and authorize JIRA Server with their account. This can be done on the team page > Integrations tab  

![JIRA Server Integration](images/jira_integration.png "San Juan Mountains")