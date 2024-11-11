# Org Activity & Usage

Super users or admins who have permissions are able to execute a graphql query to get the org activity and usage for a Parabol instance. This query will return a list of objects containing the month, the number of signups, the number of participants, and the number of meetings for that month.

### Query
```graphql
query {
  orgActivities(
    startDate: "2024-07-01T00:00:00.000Z") {
    ... on OrgActivitiesSuccess {
      rows {
        monthStart
        signups {
          orgName
          count
        }
        participantCount
        meetingCount
      }
    }
    ... on ErrorPayload {
      error {
        message
      }
    }
  }
}
```
### Parameters
| Parameter | Type | Description |
| --- | --- | --- |
| startDate | DateTime | Start date for reporting output (Stats since July 1, 2024) |

### Returns
```json
{
  "data": {
    "orgActivities": {
      "rows": [
        {
          "monthStart": "2024-07-01T00:00:00.000Z",
          "signups": [
            {
              "orgName": "Dale-test",
              "count": 1
            },
            {
              "orgName": "neiltestorg",
              "count": 1
            },
            {
              "orgName": "Platform One",
              "count": 1
            }
          ],
          "participantCount": 5,
          "meetingCount": 11
        },
        {
          "monthStart": "2024-08-01T00:00:00.000Z",
          "signups": [
            {
              "orgName": "sbuss@rackner.com's Org",
              "count": 1
            }
          ],
          "participantCount": 1,
          "meetingCount": 22
        },
        {
          "monthStart": "2024-09-01T00:00:00.000Z",
          "signups": [
            {
              "orgName": "All Organizations",
              "count": 0
            }
          ],
          "participantCount": 1,
          "meetingCount": 15
        },
        {
          "monthStart": "2024-10-01T00:00:00.000Z",
          "signups": [
            {
              "orgName": "All Organizations",
              "count": 0
            }
          ],
          "participantCount": 1,
          "meetingCount": 4
        },
        {
          "monthStart": "2024-11-01T00:00:00.000Z",
          "signups": [
            {
              "orgName": "All Organizations",
              "count": 0
            }
          ],
          "participantCount": 0,
          "meetingCount": 1
        }
      ]
    }
  }
}
```
### Notes
- The `signups` array is a list of all the organizations that were created during the month.
- The `participantCount` is the total number of participants in meetings during the month.
- The `meetingCount` is the total number of meetings during the month.
- The `monthStart` is the first day of the month.
- `orgName` is the name of the organization created either by the user or the default name of the organization.
- Oranizations that were created during the month will be listed in the `signups` array.
