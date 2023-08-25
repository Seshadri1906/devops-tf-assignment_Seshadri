# DevOps Technical Assignment

This is a technical assignment for DevOps engineers.

Our goal of this assignment:
- a way for us to test the knowledge and skillset of the candidates.
- a good use of time for candidates to learn from the assignment.

## Orientation & Instruction

### Pre-requisites

The following setup is required:

- Docker or equivalent, and dind (aka docker-in-docker) support
- Gitlab Account to push the completed assignment (for task 5 only)

### Task Overview

- There are 5 main tasks.
- There is no time limit on this.
- Feel free to complete as many tasks (or as little as one), quality is better than quantity.
- Feel free to modify the setup up till the interview.

### Getting Start

1. Create a new repository on gitlab.com and clone it to local machine.
2. Make changes according to the tasks.
3. Push the changes to the repository.
4. Open the repo to public or grant private access to us.

## Tasks

### Preparation

The setup will be done in container with all these frameworks/tools installed (no action required from candidates).
- localstack (free edition with limited features)
- terraform v1.5
- awscli v1
- jq, curl, make etc

1. Execute `make up`, which will deploy the necessary pieces for the tasks
    * localstack
    * terraform

2. Execute `make conn`, this will enter the container `terraform`.


### A. Create lambda function

**Context**

- Use Terraform to deploy lambda function
- helloworld nodejs has been provided.
- `main.tf` and `variables.tf` have been provided for direction and scope.

**Tasks**

1. Execute `make list1`, which should return
```json
{
  "Functions": []
}
```

2. Update [lambda.tf](./app/lambda.tf)

3. Create/Update lambda resources, execute `make apply` for the change.

4. List lambda functions, `make list1` should return

```
# incomplete json is displayed here
{
  "Functions": [
  {
    "FunctionName": "helloworld-localstack",
    "FunctionArn": "...",
    "Runtime": "nodejs18.x",
    "Role": "...",
    ...
  }
}
```
   
5. Invoke lambda function, `make test1` should return

```json
{
  "statusCode": 200,
  "headers": {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json"
  },
  "body": "{\"payload\":\"Hello, world.\"}"
}
```

Note: 
- Use `make plan` or `tflocal plan` to test the change.
- Use `make apply` or `tflocal apply --auto-approve` to apply the change.
- Use `make destroy` or `tflocal destroy` to remove the change.

### B. Create API Gateway

**Context**

- Use terraform to add an apigateway
- Route the lambda function traffic via apigateway

**Tasks**

1. Execute `make list2`, which should return
    
```json
{
  "items": []
}
```

2. Update [apigateway.tf](./app/apigateway.tf)

3. Add/Update apigateway resources

4. Execute `make apply` for the change.

5. List apigateway, `make list2` should now return

```
# incomplete json is displayed here
{
  "items": [
    {
      "id": "...",
      "name": "helloworld-localstack",
      "description": "Test",
      "types": [
        "..."
      ],
      ...
    }
  ]
}
```

6. Call apigateway endpoint, `make test2` to return

```json
{
  "payload": "Hello, world."
}
```

### C. Add API Key to API Gateway

**Context**

- Protect the apigateway by using apikey.

**Tasks**

1. Update [apigateway.tf](./app/apigateway.tf)
   
2. Create apikey with name `helloworld-localstack-test` and associate that with the apigateway method
   
3. Execute `make apply` for the change.

4. Execute `make test3` should return an apikey
```
# example
MTSNsBnqF6heXYZA32kxZmyzlf8Wwv9HYruIKpd
```

Note: 
- API Key in localstack doesn't have actual functionality.

### D. Use Custom Domain

**Context**

- Use terraform to create custom domain mapping for the apigateway
- Allow request to be called via custom domain (we don't need to manipulate /etc/hosts)

**Tasks**

1. Update [apigateway.tf](./app/apigateway.tf) with custom domain mapping of domain `helloworld.myapp.earth`.

2. Execute `make apply` for the change.

3. Execute `make test4` should return

```
helloworld.myapp.earth
```

### E. Create Gitlab CI/CD Pipeline

**Tasks**

1. Look into [.gitlab-ci.yml](./app/gitlab-ci.yml)
   
2. Create pipeline step to perform testing of `app/nodejs` application

3. Create pipeline step to simulate the deployment (depends on how many previous tasks have been completed)
   
4. Feel free to add extra CI/CD stages/steps based on past experience of creating a robust, production ready environment.

### Done?

Send the link of the GitLab repository to the person who requested for this assignment.
