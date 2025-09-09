# FAF Management Platform

## Table of Contents
- [Service Boundaries](#service-boundaries)
    - [7. Lost & Found Service](#7-lost--found-service)
    - [8. Budgeting Service](#8-budgeting-service)
- [Technologies and Communication](#technologies-and-communication)
- [Communication Contract](#communication-contract)
  -  [Data Management Across Services](#data-management-across-services)
  -  [Endpoints Definition](#endpoints-definition)
  - [Services Endpoints](#services-eps)
## Service Boundaries

### 7. Lost & Found Service

| **Aspect** | **Description** |
|------------|-----------------|
| **Core Responsibility** | Lost item management and community board |
| **Service Boundaries** | • Post creation for lost/found items<br>• Comment threads under posts<br>• Post resolution tracking<br>• Minimal external dependencies |
| **Main Features** | • Create posts about lost or found items<br>• Add comments to existing posts<br>• Search posts by item type, date, or status<br>• Mark posts as resolved when item is returned<br>• Basic content filtering<br>• Send notification requests when posts are updated |

### 8. Budgeting Service

| **Aspect** | **Description** |
|------------|-----------------|
| **Core Responsibility** | Financial tracking and transparency |
| **Service Boundaries** | • Treasury balance tracking<br>• Transaction logging<br>• Debt book for damages<br>• CSV report generation<br>• Receives data from other services |
| **Main Features** | • Track current FAF Cab and FAF NGO balance<br>• Log donations and spending with timestamps<br>• Separate FAF donations from Partner donations<br>• Maintain debt records for broken/overused items<br>• Generate CSV reports for admins<br>• Show transparent spending logs<br>• Receive transaction data from Fund Raising service |

## Technologies and Communication

|  | Services                       | Student Assigned    | Language/Framework   | DB  | Motivation | Trade-offs         |
|--|--------------------------------|---------------------|----------------------|-----|------------|--------------------|
| 1 | User Management & Notification | Colța Maria         | Typescript (Nest.js) |     |            |        |
| 2 | Tea Management & Communication | Munteanu Ecaterina  | Golang ()            |     |            |  |
| 3 | Cab Booking & Check-in         | Friptu Ludmila      | Node.js (Express.js) |     |            |     |
| 4 | Lost & Found & Budgeting       | Schipschi Daniel    | C# (ASP.NET Core)    |     |            |    |
| 5 | Fund Raising & Sharing         | Novac Felicia       | C# (ASP.NET Core)    |     |            |       |
<p align="right"><i>Table 1 – Services & Technologies</i></p>

We’ve chosen **REST over HTTP** as the communication pattern for all the services, because it’s quite simple, widely supported, especially across the three chosen stacks. It matches the needs of our business case, such that services must expose predictable, resource-oriented APIs. In this case, we’ll also benefit from its _stateless_ nature, where each call will already contain all the necessary context, simplifying future scaling as mentioned. In addition, REST integrates well with _Swagger_, making it easier to document and test, which in our case is very important you know :)
But of course there are trade-offs. REST is not optimal for real-time features, as in our case is the Communication Service, since it lacks streaming or push support. It also increases coupling because services must call each other directly to complete workflows. Even so, given that most of our operations are transactional, we’re ok )

[//]: # (### 7. Lost & Found Service)

[//]: # ()
[//]: # (**Technology Stack:**)

[//]: # (- Language: C#)

[//]: # (- Framework: ASP.NET Core Web API)

[//]: # (- Database: PostgreSQL)

[//]: # (- Communication: REST with JSON)

[//]: # ()
[//]: # (**Motivation:** C# provides good text handling for post content and comments. PostgreSQL offers full-text search for finding items and handles the post-comment relationships well. REST fits the simple CRUD operations needed.)

[//]: # ()
[//]: # (**Trade-offs:** More setup overhead than lighter alternatives, but provides reliable data handling and built-in validation for user-generated content.)

[//]: # ()
[//]: # (### 8. Budgeting Service)

[//]: # ()
[//]: # (**Technology Stack:**)

[//]: # (- Language: C#)

[//]: # (- Framework: ASP.NET Core Web API)

[//]: # (- Database: PostgreSQL)

[//]: # (- Communication: REST with JSON)

[//]: # ()
[//]: # (**Motivation:** C# decimal type prevents money calculation errors. PostgreSQL ACID compliance ensures financial data integrity. REST provides clear endpoints for different transaction types.)

[//]: # ()
[//]: # (**Trade-offs:** Heavier stack than needed for simple operations, but financial accuracy requirements justify the choice. May need multiple API calls for complex reports.)

## Communication Contract

### Data Management Across Services

We’ve decided that each microservice will be responsible for its own data and will maintain a separate database schema. No service has direct access to another service’s database, instead, data is shared strictly through REST APIs exposed by each service. In this case, each domain entity will be owned exclusively by its responsible service, and when another service will need that data - it will issue a REST request to the owning service.

### Endpoints Definition
All the services in the FAF Cab Management Platform expose RESTful HTTP APIs. They follow consistent “conventions” to keep it easy to integrate with each other.

**Some general conventions:**

* Each service is mounted under `/api/{service}`, where `{service}` is a shortened identifier (e.g., `/api/frs` = Fund Raising Service).

* Requests use `Authorization: Bearer <JWT> issued by the User Management Service. Role checks are enforced per EP.

* All requests and responses use `application/json` content type.

* All datetime fields use `ISO 8601` format in **UTC**.

* Common established error JSON shape: 
````json 
{ 
  "error": "VALIDATION_ERROR", 
  "message": "field X is required"
}
````

### Services EPs
###