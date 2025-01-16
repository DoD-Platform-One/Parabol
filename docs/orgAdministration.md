# Org Administration

When a user signs up for Parabol, it will create a new organization for them based on their username (like Jordan's Org). They'll also get a personal 'Team' created for them that can house their private tasks (like Jordan's Team).

The way membership works in Parabol is any user can create a Team and invite other's to it. When they do, they'll become a member of the Organization that Team belongs two but will only have access to the data (Tasks & Meeting History) for their Teams.

- Parabol
    - Organization A
        - Team 1
        - Team 2
    - Organization B
        - Team 1
        - Team 2
        - Team 3

#### There are (4) roles users can carry in Parabol:

- **Organization Administrator** - can add remove teams and other roles
- **Billing Leader** - can view organization usage statistics
- **Team Lead** - each team has a Lead role, they can add and remove other members from their team
- **User** - can participate in meetings on their team, access that team's data

## Set or Remove Org Admin Role

### Look up the user id

```graphql
query {
  user(email: "jordan+dev@parabol.co") {
    id
  }
}
```

### Returns

```json
{
  "data": {
    "user": {
      "id": "local|v1It4k6W9q"
    }
  }
}
```

### **Give user the Org Admin role**

With this mutation you will give a certain user with `userId` the org admin role rights for the organization with `orgId`: 

```graphql
mutation {
  setOrgUserRole(orgId: "Skc7syWwNox", userId: "local|v1It4k6W9q", role: ORG_ADMIN) {
    ... on SetOrgUserRoleSuccess {
      updatedOrgMember {
        id
        role
      }
    }
  }
}

```

## **Remove the Org Admin role from user**

With this mutation you will remove the the org admin role rights for a certain user with `userId` on the organization with `orgId`:

```graphql
mutation {
  setOrgUserRole(orgId: "Skc7syWwNox", userId: "local|v1It4k6W9q", role: null) {
    ... on SetOrgUserRoleSuccess {
      updatedOrgMember {
        id
        role
      }
    }
  }
}

```

## **Superusers**

Certain users may need elevated privileges and administrative access, granting them the ability to manage and control various aspects of the system. Unlike regular users, superusers can perform advanced tasks such as creating and managing user accounts, configuring system settings, overseeing permissions, and accessing restricted data. This role is typically reserved for system administrators, or trusted personnel who need comprehensive control to maintain, troubleshoot, or enhance the application.

### To add or remove the superuser role to an account:
Shell into a running webserver pod and run the following command (with an admin email)

``` bash
node dist/assignSURole.js --add EMAIL_TO_ADD
```

### To remove the superuser role from a user account:
Repeat the above step and replace `--add` with `--remove` followed by the user email