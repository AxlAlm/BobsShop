# Bob's Shop

A IaC (Infrastructure as Code) project for a shop backend running AWS Lambda, AWS API Gateway and <DB NOT DECIDED!>, all configured and setup with Terraform

### TODO:

- setup REST API terraform module

  - setup database
  - setup APIGateway
  - setup CloudWatch (?)

- create lambda functions for CRUD for:

  - orders
  - items
  - payment

- setup REST APIS for all the above resources with the REST API Lambda module

- setup up some Message Queue system for events (?)

- find microservice architecture that deals with data consistency and implement that system on top of the REST APIs

  - prob SAGA?

- Package service as lambda layer and use for all functions

- enable pre-merge tests in github actions; pytest, isort, black and mypy
