# training-sessions-terraform-advanced

## Ideas for Breakages

  - Dynamo table created in the bootstrap for duplicate resource on on dynamodb
    - Students must import existing table

  - Lambda initially created with read only role ARN
    - Students will need to fix role name

  - An example module for lambda to prove workshop for state move example
    - Lambda possibly initially created by the bootstrap code
    - Students will make their own module and do a state move to claim
      ownership of the resource
    - This module is for us to prove the course and wouldn't be given to
      students
