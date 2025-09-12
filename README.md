# FAF Management Platform

## Table of Contents
- [Service Boundaries](#service-boundaries)
    - [Services Overview](#services-overview)
    - [Architecture Diagram](#architecture-diagram)
- [Technologies and Communication](#technologies-and-communication)
- [Communication Contract](#communication-contract)
  -  [Data Management Across Services](#data-management-across-services)
  -  [Endpoints Definition](#endpoints-definition)
  - [Services Endpoints](#services-eps)
    - [1. User Management Service](#1-user-management-service)
    - [2. Notification Service](#2-notification-service)
    - [3. Tea Management Service](#3-tea-management-service)
    - [5. Booking Service](#5-booking-service)
    - [6. Check-in Service](#6-check-in-service)
    - [7. Lost & Found Service](#7-lost--found-service-lfs)
    - [8. Budgeting Service](#8-budgeting-service-bs)
    - [9. Fund Raising Service](#9-fund-raising-service-frs)
    - [10. Sharing Service](#10-sharing-service-shs)
- [GitHub Workflow](#github-workflow)
  - [Branch Naming Convention](#branch-naming-convention)
  - [Branch Rules](#branch-rules)
  - [Contribution Rules](#contribution-rules)

## Service Boundaries

### Services Overview
| Service Name | Core Responsibilities (Boundaries) |
| :--- | :--- |
| **User Management** | • Handles user registration, login and authentication.<br>• Stores user profiles (name, nickname, group, role).<br>• Central source of truth for user identity. <br>• Integrates with Discord API to fetch user data. |
| **Notification** | • Handles all outgoing communications (e.g., email, Discord DMs).<br>• Sends alerts based on events from other services (e.g., low supplies, new bookings).<br>• Ensures timely and targeted delivery of messages. |
| **Tea Management** | • Tracks inventory levels of all consumables (tea, sugar, cups, markers).<br>• Logs which user consumes which items and when.<br>• Triggers notifications for low stock or excessive resource usage. |
| **Communication** | • Facilitates real-time chat between users (public and private channels).<br>• Allows users to find each other by nickname.<br>• Enforces communication rules through word censorship and user bans. |
| **Cab Booking** | • Manages the schedule for bookable spaces (main room, kitchen).<br>• Prevents scheduling conflicts.<br>• Integrates with Google Calendar to sync events. |
| **Check-in** | • Tracks user presence inside FAF Cab by processing entry and exit events.<br>• Manages a log of one-time guest registrations.<br>• Identifies and alerts admins about unrecognized individuals. |
| **Lost & Found** | • Manages user-generated posts about lost or found items.<br>• Supports comment threads for discussion on each post.<br>• Allows the original poster to mark an issue as resolved. |
| **Budgeting** | • Tracks all financial transactions (donations, spending).<br>• Maintains the FAF NGO treasury balance and a public log.<br>• Manages a debt book for property damage or overuse.<br>• Allows admins to generate financial reports in CSV format. |
| **Fund Raising** | • Allows admins to create and manage fundraising campaigns for specific items.<br>• Tracks user donations towards a goal within a set timeframe.<br>• Orchestrates the registration of newly acquired items into other relevant services (e.g., Sharing, Budgeting). |
| **Sharing** | • Manages the inventory of multi-use, non-consumable items (games, cables, kettles).<br>• Handles the "renting" and "returning" lifecycle of shared objects.<br>• Tracks the state/condition of each item and its ownership (personal or FAF). |
| 
<p align="right"><i>Table 1 – Services Boundaries</i></p>

## Architecture Diagram

![FAF Cab Logo](./assets/fafcab.png)
<p align="right"><i>Figure 1 – Architecture Diagram</i></p>

## Technologies and Communication

|   | Services                       | Student Assigned    | Language/Framework   | DB                             | Motivation | Trade-offs         |
|---|--------------------------------|---------------------|----------------------|--------------------------------|------------|--------------------|
| 1 | User Management & Notification | Colța Maria         | Typescript (Nest.js) | PostgreSQL | Nest.js offers good structure for organizing code, catches errors early, works well with Discord API. PosgresSQL is a reliable data storage, good for handling user relationships and permissions. | Nest.js takes more time to learn than simpler frameworks, but makes code easier to maintain. PostgresSQL has a higher resource usage vs NoSQL, but is necessary for consistent relationships. |
| 2 | Tea Management & Communication | Munteanu Ecaterina  | Golang ()            |                                |            |  |
| 3 | Cab Booking & Check-in         | Friptu Ludmila      | Node.js (Express.js) | PostgreSQL, MongoDB            | Node.js handles I/O-heavy tasks and real-time camera check-ins with its event-driven, non-blocking model. PostgreSQL provides ACID reliability to prevent double-bookings, while MongoDB’s flexible schema and fast writes suit large volumes of time-series logs (check-ins/check-outs). | The single-threaded nature of Node.js makes CPU-heavy tasks (e.g., video or ML processing) inefficient unless you offload them to worker processes or native modules. PostgreSQL comes with a more rigid schema model and greater complexity when scaling horizontally or handling very high write volumes. MongoDB lacks the same relational constraints and strict consistency. |
| 4 | Lost & Found & Budgeting       | Schipschi Daniel    | C# (ASP.NET Core)    | PostgreSQL                     | C# provides excellent decimal handling for financial calculations and strong type safety for money operations. ASP.NET Core offers robust validation and security features essential for financial data. PostgreSQL ensures ACID compliance for transaction integrity and supports full-text search for Lost & Found posts. | Heavier resource usage compared to lighter frameworks. More complex setup and deployment process. Less flexibility for rapid prototyping compared to dynamic languages. |
| 5 | Fund Raising & Sharing         | Novac Felicia       | C# (ASP.NET Core)    | PostgreSQL                     | ASP.NET Core with PostgreSQL offers reliability, security, and strong transactional guarantees, well suited for handling financial and resource-sharing workflows.           | Adds overhead in schema management and is heavier compared to lighter frameworks, which can slow iteration and increase resource usage.      |
<p align="right"><i>Table 2 – Services & Technologies</i></p>

We've chosen **REST over HTTP** as the communication pattern for all the services, because it's quite simple, widely supported, especially across the three chosen stacks. It matches the needs of our business case, such that services must expose predictable, resource-oriented APIs. In this case, we'll also benefit from its _stateless_ nature, where each call will already contain all the necessary context, simplifying future scaling as mentioned. In addition, REST integrates well with _Swagger_, making it easier to document and test, which in our case is very important you know :)
But of course there are trade-offs. REST is not optimal for real-time features, as in our case is the Communication Service, since it lacks streaming or push support. It also increases coupling because services must call each other directly to complete workflows. Even so, given that most of our operations are transactional, we're ok )

## Communication Contract

### Data Management Across Services

We've decided that each microservice will be responsible for its own data and will maintain a separate database schema. No service has direct access to another service's database, instead, data is shared strictly through REST APIs exposed by each service. In this case, each domain entity will be owned exclusively by its responsible service, and when another service will need that data - it will issue a REST request to the owning service.

### Endpoints Definition
All the services in the FAF Cab Management Platform expose RESTful HTTP APIs. They follow consistent "conventions" to keep it easy to integrate with each other.

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

## Services EPs

### 1. User Management Service
#### Base URL: /api/ums
#### Entities:
- **User** - registered or potential user in the FAF Cab Management Platform.
- **OTP** - handles OTP verification for user registration process.
#### Query parameters:
- **role** (optional) - Filter by role ("student", "teacher", "admin")
- **group** (optional) - Filter by group
- **page** (optional) - Page number for pagination
- **limit** (optional) - Number of users per page

#### EP List:
| Method | Path                   | Auth   | Purpose                                    |
| ------ | ---------------------- | ------ | ------------------------------------------ |
| GET    | /users                 | admin  | Get the list of all users (members from FAF Community Server) |
| GET    | /users/:id             | user   | Get a specific user                        |
| POST   | /users/login           | public | Login a user to the system                 |
| POST   | /send_otp              | public | Send OTP to the user for registering       |
| POST   | /users/register        | public | Register a user to the system              |
| POST   | /users/logout          | user   | Logout user from the system                |

#### GET /users
- *Response 200:*
```json
{
  "users": [
    {
      "id": "string",
      "username": "string",
      "nickname": "string",
      "email": "string",
      "group": "string",
      "role": ["string"], // "student", "teacher", "admin"
      "discordId": "string",
      "isRegistered": "boolean",
      "createdAt": "datetime",
      "lastLoginAt": "datetime"
    }
  ],
  "pagination": {
    "page": "number",
    "limit": "number",
    "total": "number",
    "totalPages": "number"
  }
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### GET /users/:id
- *Response 200:*
```json
  {
    "id": "string",
    "username": "string",
    "nickname": "string",
    "email": "string",
    "group": "string",
    "role": ["string"], // "student", "teacher", "admin"
    "discordId": "string",
    "isActive": "boolean",
    "createdAt": "datetime",
    "lastLoginAt": "datetime"
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### POST /users/login
- *Request:*
```json
  {
    "username": "string",
    "password": "string",
  }
```

- *Response 200:*
```json
  {
    "token": "string", // JWT
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### POST /send_otp
- *Request:*
```json
  {
    "username": "string"
  }
```

- *Response 200:*
```json
  {
    "success": true,
    "message": "OTP sent successfully",
    "otpExpiresAt": "datetime"
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### POST /users/register
- *Request:*
```json
  {
    "username": "string",
    "otp": "string",
    "password": "string",
  }
```

- *Response 201:*
```json
  {
    "token": "string", // JWT
    "user": {
      "id": "string",
      "username": "string",
      "group": "string",
      "role": "string",
      "createdAt": "datetime"
    },
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### POST /users/logout
- *Response 200:*
```json
  {
    "success": true,
    "message": "Logged out successfully"
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

### 4. Notification Service
#### Base URL: /api/ntf

#### EP List:
| Method | Path                   | Auth   | Purpose                                    |
| ------ | ---------------------- | ------ | ------------------------------------------ |
| POST   | /send_notification     | admin  | Send notification to the right persion     |

#### POST /send_notification
- *Response 200:*
```json
  {
    "messageType": "string", // "dm" or "channel"
    "username": "string",
    "channelId": "string",
    "message": "string"
  }
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 


### 3. Tea Management Service
#### Base URL: /api/tms
#### Entities:
- **Consumable** - represents an item like tea, sugar, cups, paper, etc.
- **ConsumptionLog** - record of when a user consumes a consumable.
- **ThresholdAlert** - triggered when consumables run low or a user exceeds fair use.

#### EP List:
| Method | Path                   | Auth   | Purpose                                    |
| ------ | ---------------------- | ------ | ------------------------------------------ |
| POST   | /consumables           | admin  | Add a new consumable item                  |
| GET    | /consumables           | public | List all consumables with stock levels     |
| GET    | /consumables/{id}      | public | Get details of a consumable                |
| PUT    | /consumables/{id}      | admin  | Update stock levels or details             |
| POST   | /consumptions          | user   | Log a consumption event                    |
| GET    | /consumptions          | admin  | View all consumption logs                  |
| GET    | /consumptions/{userId} | admin  | View consumption logs by user              |
| GET    | /alerts                | admin  | List triggered alerts (low stock, overuse) |

#### POST /consumables
- *Request:*
```json
{
  "name": "Tea Bags",
  "unit": "bags",
  "stock": 200,
  "lowStockThreshold": 20
}
```
- *Response 201:*
```json
{
  "id": "uuid",
  "name": "Tea Bags",
  "unit": "bags",
  "stock": 200,
  "lowStockThreshold": 20,
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden 

#### GET /consumables
- *Response 200:*
```json
{
  "consumables": [
    {
      "id": 0,
      "name": "Tea Bags",
      "unit": "bags",
      "stock": 150,
      "lowStockThreshold": 20,
      "updatedAt": "ISO Date"
    }
  ]
}
```
- *Errors:* 401 Unauthorized 

#### GET /consumables/{id}
*Response 200:*
```json
{
  "id": "3f9c07f2-8d3d-45a6-90b2-7c37e7c62a2f",
  "name": "Tea Bags",
  "unit": "bags",
  "stock": 150,
  "lowStockThreshold": 20,
  "createdAt": "2025-09-01T10:00:00Z",
  "updatedAt": "2025-09-11T14:00:00Z"
}
```
- *Errors:* 400 Bad Request, 404 Not Found

#### PUT /consumables/{id}
- *Request:*
```json
{
  "stock": 180
}
```
- *Response 200:*
```json
{
  "id": 0,
  "name": "Tea Bags",
  "unit": "bags",
  "stock": 180,
  "lowStockThreshold": 20,
  "updatedAt": "ISO Date"
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found

#### POST /consumptions
- *Request:*
```json
{
  "userId": 42,
  "consumableId": 0,
  "amount": 3
}

```
- *Response 201:*
```json
{
  "id": 0,
  "userId": 42,
  "consumableId": 0,
  "amount": 3,
  "createdAt": "ISO Date"
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found

#### GET /consumptions
- *Response 200:*
```json
{
  "logs": [
    {
      "id": "6b77216c-39e8-4ef9-b2f1-4a7c24d3428e",
      "userId": "5f8b6c3e-0e29-4d7b-a6f1-68eae87c73f3",
      "consumableId": "3f9c07f2-8d3d-45a6-90b2-7c37e7c62a2f",
      "amount": 2,
      "createdAt": "2025-09-11T12:00:00Z"
    },
    {
      "id": "ab12d3e4-f6c7-48b9-8d1a-2c3d4e5f6789",
      "userId": "2c9a6bff-1a3e-4c9b-9d5c-123456789abc",
      "consumableId": "3f9c07f2-8d3d-45a6-90b2-7c37e7c62a2f",
      "amount": 1,
      "createdAt": "2025-09-11T11:45:00Z"
    }
  ]
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden

#### GET /consumptions/{userId}
- *Response 200:*
```json
{
  "logs": [
    {
      "id": 0,
      "userId": 42,
      "consumableId": 0,
      "amount": 3,
      "createdAt": "ISO Date"
    }
  ]
}
```
- *Errors:* 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found

#### GET /alerts
- *Response 200:*
```json
{
  "alerts": [
    {
      "id": 0,
      "type": "LOW_STOCK",
      "consumableId": 0,
      "currentStock": 10,
      "threshold": 20,
      "createdAt": "ISO Date"
    },
    {
      "id": 1,
      "type": "OVERUSE",
      "userId": 42,
      "consumableId": 0,
      "amountUsed": 50,
      "limit": 20,
      "createdAt": "ISO Date"
    }
  ]
}
```
- *Errors:* 401 Unauthorized, 403 Forbidden

### 5. Booking Service

### Synchronous Communication (REST API)

#### `POST /bookings`

Creates a new booking for a room.

  * **Request Body:**

    ```json
    {
      "userId": "string",
      "room": "string",
      "startTime": "datetime",
      "endTime": "datetime"
    }
    ```

  * **Response (201 Created):**

    ```json
    {
      "bookingId": "string",
      "userId": "string",
      "room": "string",
      "startTime": "datetime",
      "endTime": "datetime",
      "createdAt": "datetime"
    }
    ```

  * **Error Responses:** `400 Bad Request`, `409 Conflict (time slot taken)`

#### `GET /bookings?start={date}&end={date}`

Gets all bookings within a specified date range.

  * **Response (200 OK):**
    ```json
    [
      {
        "bookingId": "string",
        "userId": "string",
        "room": "string",
        "startTime": "datetime",
        "endTime": "datetime"
      }
    ]
    ```

#### `DELETE /bookings/{bookingId}`

Cancels a specific booking.

  * **Response (204 No Content)**
  * **Error Responses:** `403 Forbidden`, `404 Not Found`

-----

### 6. Check-in Service

### Synchronous Communication (REST API)

#### `GET /status/current`

Gets a list of all users currently inside FAFCab.

  * **Response (200 OK):**
    ```json
    [
      {
        "userId": "string",
        "nickname": "string",
        "checkInTime": "datetime"
      }
    ]
    ```

#### `GET /history/{userId}?start={date}&end={date}`

Gets the entry and exit history for a specific user within a date range.

  * **Response (200 OK):**
    ```json
    [
      {
        "event_type": "string",
        "timestamp": "datetime"
      }
    ]
    ```
  * **Error Responses:** `404 Not Found`

#### `POST /guest`

Registers a one-time guest.

  * **Request Body:**
    ```json
    {
      "hostUserId": "string",
      "guestName": "string"
    }
    ```
  * **Response (201 Created):**
    ```json
    {
      "guestLogId": "string",
      "guestName": "string",
      "hostUserId": "string",
      "entryTime": "datetime"
    }
    ```
  * **Error Responses:** `400 Bad Request`

-----

### 7. Lost & Found Service (LFS)

**Base URL:** `/api/lfs`

**Entities:**
* `Post` — represents a lost or found item announcement with status and metadata
* `Comment` — represents a comment thread under a specific post

**Endpoints List:**

| Method | Path                     | Auth   | Purpose                         |
|--------|--------------------------|--------|---------------------------------|
| POST   | /posts                   | user   | Create a new lost/found post    |
| GET    | /posts                   | public | List all posts with filters     |
| GET    | /posts/{id}              | public | Get specific post details       |
| PATCH  | /posts/{id}              | user   | Update post (author/admin only) |
| POST   | /posts/{id}/comments     | user   | Add comment to a post           |
| GET    | /posts/{id}/comments     | public | Get all comments for a post     |
| PATCH  | /posts/{id}/resolve      | user   | Mark post as resolved           |

**Endpoints Specs:**

`POST /posts`

**Request:**
````json
{
  "type": "string (enum: LOST, FOUND)",
  "title": "string",
  "description": "string",
  "itemCategory": "string (enum: ELECTRONICS, CLOTHING, DOCUMENTS, BOOKS, OTHER)",
  "location": "string",
  "contactInfo": "string (optional)"
}
````

**Response 201:**
````json
{
  "id": "string",
  "type": "string (enum: LOST, FOUND)",
  "title": "string",
  "description": "string",
  "itemCategory": "string (enum: ELECTRONICS, CLOTHING, DOCUMENTS, BOOKS, OTHER)",
  "location": "string",
  "contactInfo": "string",
  "status": "string (enum: OPEN, RESOLVED)",
  "authorId": "string (userId)",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

`GET /posts`

**Query Parameters:**
- `type` (optional): LOST or FOUND
- `category` (optional): item category
- `status` (optional): OPEN or RESOLVED
- `limit` (optional): number of posts per page (default: 20)
- `offset` (optional): pagination offset (default: 0)

**Response 200:**
````json
{
  "posts": [
    {
      "id": "string",
      "type": "string (enum: LOST, FOUND)",
      "title": "string",
      "description": "string",
      "itemCategory": "string",
      "location": "string",
      "status": "string (enum: OPEN, RESOLVED)",
      "authorId": "string",
      "commentCount": 3,
      "createdAt": "ISO Date",
      "updatedAt": "ISO Date"
    }
  ],
  "total": 42
}
````

`GET /posts/{id}`

**Response 200:**
````json
{
  "id": "string",
  "type": "string (enum: LOST, FOUND)",
  "title": "string",
  "description": "string",
  "itemCategory": "string",
  "location": "string",
  "contactInfo": "string",
  "status": "string (enum: OPEN, RESOLVED)",
  "authorId": "string",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

`POST /posts/{id}/comments`

**Request:**
````json
{
  "content": "string"
}
````

**Response 201:**
````json
{
  "id": "string",
  "postId": "string",
  "authorId": "string (userId)",
  "content": "string",
  "createdAt": "ISO Date"
}
````

`GET /posts/{id}/comments`

**Response 200:**
````json
{
  "comments": [
    {
      "id": "string",
      "postId": "string",
      "authorId": "string",
      "content": "string",
      "createdAt": "ISO Date"
    }
  ]
}
````

`PATCH /posts/{id}/resolve`

**Request:**
````json
{
  "status": "RESOLVED"
}
````

**Response 200:**
````json
{
  "id": "string",
  "status": "RESOLVED",
  "updatedAt": "ISO Date"
}
````

-----

### 8. Budgeting Service (BS)

**Base URL:** `/api/bs`

**Entities:**
* `Transaction` — represents income or expense transaction with categorization
* `Balance` — current treasury balance for FAF Cab and FAF NGO
* `DebtEntry` — represents money owed by users for damages or overuse

**Endpoints List:**

| Method | Path                   | Auth   | Purpose                           |
|--------|------------------------|--------|-----------------------------------|
| GET    | /balance               | public | Get current treasury balance      |
| POST   | /transactions/income   | admin  | Record income transaction         |
| POST   | /transactions/expense  | admin  | Record expense transaction        |
| GET    | /transactions          | admin  | List all transactions with filters|
| GET    | /reports/csv           | admin  | Download financial report as CSV  |
| POST   | /debt                  | admin  | Add debt entry for user           |
| GET    | /debt                  | admin  | List all debt entries             |
| GET    | /debt/{userId}         | user   | Get debt for specific user        |
| PATCH  | /debt/{id}             | admin  | Update debt entry (mark paid)     |

**Endpoints Specs:**

`GET /balance`

**Response 200:**
````json
{
  "fafCabBalance": {
    "amount": 1250.75,
    "currency": "MDL",
    "lastUpdated": "ISO Date"
  },
  "fafNgoBalance": {
    "amount": 3420.50,
    "currency": "MDL",
    "lastUpdated": "ISO Date"
  }
}
````

`POST /transactions/income`

**Request:**
````json
{
  "amount": 150.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "source": "string (enum: FAF_DONATION, PARTNER_DONATION, FUNDRAISING, OTHER)",
  "description": "string",
  "fundTarget": "string (enum: FAF_CAB, FAF_NGO)",
  "referenceId": "string (optional - for linking to fundraising campaigns)"
}
````

**Response 201:**
````json
{
  "id": "string",
  "type": "INCOME",
  "amount": 150.00,
  "currency": "string",
  "source": "string",
  "description": "string",
  "fundTarget": "string",
  "referenceId": "string",
  "recordedBy": "string (userId)",
  "createdAt": "ISO Date"
}
````

`POST /transactions/expense`

**Request:**
````json
{
  "amount": 75.50,
  "currency": "string (enum: MDL, EUR, USD)",
  "category": "string (enum: CONSUMABLES, EQUIPMENT, MAINTENANCE, UTILITIES, OTHER)",
  "description": "string",
  "fundSource": "string (enum: FAF_CAB, FAF_NGO)",
  "receiptUrl": "string (optional)"
}
````

**Response 201:**
````json
{
  "id": "string",
  "type": "EXPENSE",
  "amount": 75.50,
  "currency": "string",
  "category": "string",
  "description": "string",
  "fundSource": "string",
  "receiptUrl": "string",
  "recordedBy": "string (userId)",
  "createdAt": "ISO Date"
}
````

`GET /transactions`

**Query Parameters:**
- `type` (optional): INCOME or EXPENSE
- `startDate` (optional): ISO date
- `endDate` (optional): ISO date
- `fundTarget` (optional): FAF_CAB or FAF_NGO
- `limit` (optional): default 50
- `offset` (optional): default 0

**Response 200:**
````json
{
  "transactions": [
    {
      "id": "string",
      "type": "string (enum: INCOME, EXPENSE)",
      "amount": 150.00,
      "currency": "string",
      "description": "string",
      "fundTarget": "string",
      "recordedBy": "string",
      "createdAt": "ISO Date"
    }
  ],
  "total": 156
}
````

`GET /reports/csv`

**Query Parameters:**
- `startDate` (required): ISO date
- `endDate` (required): ISO date
- `fundTarget` (optional): FAF_CAB or FAF_NGO

**Response 200:**
Returns CSV file with headers: `Date,Type,Amount,Currency,Description,Fund,RecordedBy`

`POST /debt`

**Request:**
````json
{
  "userId": "string",
  "amount": 50.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "reason": "string (enum: DAMAGE, OVERUSE, LOST_ITEM, OTHER)",
  "description": "string",
  "itemId": "string (optional - reference to damaged item)"
}
````

**Response 201:**
````json
{
  "id": "string",
  "userId": "string",
  "amount": 50.00,
  "currency": "string",
  "reason": "string",
  "description": "string",
  "itemId": "string",
  "status": "string (enum: PENDING, PAID, FORGIVEN)",
  "createdBy": "string (userId)",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

`GET /debt`

**Query Parameters:**
- `status` (optional): PENDING, PAID, FORGIVEN
- `userId` (optional): filter by specific user

**Response 200:**
````json
{
  "debts": [
    {
      "id": "string",
      "userId": "string",
      "amount": 50.00,
      "currency": "string",
      "reason": "string",
      "description": "string",
      "status": "string",
      "createdAt": "ISO Date"
    }
  ],
  "totalPending": 125.75
}
````

`GET /debt/{userId}`

**Response 200:**
````json
{
  "userDebts": [
    {
      "id": "string",
      "amount": 50.00,
      "currency": "string",
      "reason": "string",
      "description": "string",
      "status": "string",
      "createdAt": "ISO Date"
    }
  ],
  "totalOwed": 50.00
}
````

`PATCH /debt/{id}`

**Request:**
````json
{
  "status": "string (enum: PAID, FORGIVEN)",
  "note": "string (optional)"
}
````

**Response 200:**
````json
{
  "id": "string",
  "status": "PAID",
  "note": "string",
  "updatedBy": "string (userId)",
  "updatedAt": "ISO Date"
}
````

-----

### 9. Fund Raising Service (FRS)
**Base URL:** `/api/frs`

**Entities:**
* `Initiative` — represents a fundraising effort for an object or consumable, with goal, deadline, and status
* `Donation` - a contribution made by a user to an initiative

**Endpoints List:**

| Method | Path                          | Auth       | Purpose                    |
|--------|-------------------------------|------------|----------------------------|
| POST   | /initiatives                  | admin      | Create fund                |
| GET    | /initiatives                  | public     | List all the funds         |
| GET    | /initiatives/{id}             | public     | Get fund by id             |
| POST   | /initiatives/{id}/donations   | user       | donate                     |
| GET    | /frs/initiative/{id}/donations| admin      | list donations for a fund  |
| POST   | /initiatives/{id}/finalize    | system use | finalize fund              |

**Endpoints Specs:**

`POST /initiatives`

**Request:**
````json
{
  "title": "string",
  "description": "string",
  "qty":1,
  "goal": 120.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "deadline": "ISO date",
  "targetType": "string (enum: ASSET, CONSUMABLE)",         
  "targetSubtype": "string"
}
````
**Response 201:**
````json
{
  "id": "string",
  "status": "string (enum: OPEN, CLOSED, CANCELED, FINALIZED)",
  "title": "string",
  "description": "string",
  "qty": 1,
  "goal": 120.00,
  "raised": 0.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "deadline": "ISO date",
  "targetType": "string (enum: ASSET, CONSUMABLE)",
  "targetSubtype": "string",
  "createdBy": "string (userId)",
  "createdAt": "ISO date",
  "updatedAt": "ISO date"
}
````

`GET /initiatives`

**Response 200:**

````json
{
  "initiatives": [
    {
      "id": "string",
      "status": "string (enum: OPEN, CLOSED, CANCELED, FINALIZED)",
      "title": "string",
      "description": "string",
      "qty": 1,
      "goal": 120.00,
      "raised": 90.00,
      "currency": "string (enum: MDL, EUR, USD)",
      "deadline": "ISO Date",
      "targetType": "string (enum: ASSET, CONSUMABLE)",
      "targetSubtype": "string",
      "createdAt": "ISO Date",
      "updatedAt": "ISO Date"
    }
  ]
}
````

`GET /initiatives/{id}`

**Response 200:**

````json
{
  "id": 0,
  "status": "string (enum: OPEN, CLOSED, CANCELED, FINALIZED)",
  "title": "string",
  "description": "string",
  "qty": 1,
  "goal": 120.00,
  "raised": 90.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "deadline": "ISO Date",
  "targetType": "string (enum: ASSET, CONSUMABLE)",
  "targetSubtype": "string",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

`POST /initiatives/{id}/donations`

**Request:**
````json
{
  "amount": 20.00
}
````
**Response 201:**
````json
{
  "id": "string",
  "status": "string (enum: OPEN, CLOSED, CANCELED, FINALIZED)",
  "title": "string",
  "description": "string",
  "qty": 1,
  "goal": 120.00,
  "raised": 90.00,
  "currency": "string (enum: MDL, EUR, USD)",
  "deadline": "ISO Date",
  "targetType": "string (enum: ASSET, CONSUMABLE)",
  "targetSubtype": "string",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

`GET /initiative/{id}/donations`

**Response 200:**
````json
{
  "donations": [
    {
      "id": "string",
      "userId": "string",
      "amount": 20.00,
      "currency": "string (enum: MDL, EUR, USD)",
      "createdAt": "ISO Date"
      }
  ]
}
````
-------

### 10. Sharing Service (SHS)

**Base URL:** `/api/shs`

**Entities:**
* `Object` — shareable multi-use asset with ownership and condition.
* `Rental` — record of an object being borrowed, including renter and status.


**Endpoints List:**

| Method | Path                         | Auth        | Purpose                    |
|--------|------------------------------|-------------|----------------------------|
| POST   | /objects                     | user/admin  | Create object              |
| GET    | /objects                     | public      | List all the objects       |
| GET    | /objects/{id}                | public      | Get obj by id              |
| POST   | /objects/{id}/rentals        | user        | request rental             |
| POST   | /rentals/{rentalId}/checkout | owner/admin | approve rental             |
| PATCH  | rentals/{rentalId}/return    | user        | return rental              |
| POST   | /objects/{id}/damage         | user        | report damage              |
| PATCH  | /objects/{id}                | user        | update the state of an obj |

**Endpoints Specs:**

`POST /objects`

**Request:**
````json
{
  "name": "string",
  "type": "string", 
  "ownerType": "string (enum: PERSONAL, FAF)",              
  "ownerUserId": "string (or null if FAF)",
  "condition": "string (enum: NEW, GOOD, FAIR, POOR)",           
  "notes": "string"
}

````

**Response 201:**

````json
{
	"id": "string",
	"name": "string",
	"type": "string", 
  "ownerType": "string (enum: PERSONAL, FAF)",
    "ownerUserId": "string (or null if FAF)",
	"condition": "string (enum: NEW, GOOD, FAIR, POOR)",
    "notes": "string",
	"createdBy": "string (userId)",
	"createdAt": "ISO Date",
	"updatedAt": "ISO Date"
}

````


`GET /objects`

**Response 200:**
````json
{
	"items": [
		{
			"id": "string",
			"name": "string",
			"type": "string",
			"ownerType": "string (enum: PERSONAL, FAF)",
			"ownerUserId": "string (or null if FAF)",
			"condition": "string (enum: NEW, GOOD, FAIR, POOR)",
			"activeRental": "string (rentalId or null)"
		}
	]
}

````

`GET /objects/{id}`
**Response 200:**
````json
{
    "id": "string",
    "name": "string",
    "type": "string",
    "ownerType": "string (enum: PERSONAL, FAF)",
    "ownerUserId": "string (or null if FAF)",
    "condition": "string (enum: NEW, GOOD, FAIR, POOR)",
    "notes": "string",
    "activeRental": "string (rentalId or null)",
    "createdBy": "string (userId)",
    "createdAt": "ISO Date",
    "updatedAt": "ISO Date"
}
````

`POST /objects/{id}/rentals`

**Request:**
````json
{
  "dueAt": "ISO Date"
}
````

**Response 201:**
````json
{
  "rentalId": "string",
  "objectId": "string",
  "renterId": "string (userId)",
  "status": "string (enum: PENDING, CHECKED_OUT, RETURNED, OVERDUE)",
  "dueAt": "ISO Date",
  "createdAt": "ISO Date"
}
````

`POST /rentals/{rentalId}/checkout`
**Request:**
````json
{
	"status": "CHECKED_OUT"
}
````

**Response 201:**
````json
{
  "rentalId": "string",
  "objectId": "string",
  "renterId": "string (userId)",
  "status": "string (enum: PENDING, CHECKED_OUT, RETURNED, OVERDUE)",
  "dueAt": "ISO Date",
  "createdAt": "ISO Date",
  "checkedOutAt": "ISO Date"
}
````

`PATCH /rentals/{rentalId}/return`

**Request:**
````json
{
  "condition": "string (enum: NEW, GOOD, FAIR, POOR)"          
}
````

**Response 200:**
````json
{
  "rentalId": "string",
  "objectId": "string",
  "renterId": "string (userId)",
  "status": "string (enum: PENDING, CHECKED_OUT, RETURNED, OVERDUE)",
  "dueAt": "ISO Date",
  "createdAt": "ISO Date",
  "checkedOutAt": "ISO Date",
  "returnedAt": "ISO Date"
}
````

`POST /objects/{id}/damage`

**Request:**
````json
{
  "description": "string",
  "severity": "string (enum: MINOR, MAJOR, CRITICAL)"
}
````

**Response 201:**
````json
{
  "reportId": "string",
  "objectId": "string",
  "reportedBy": "string (userId)",
  "description": "string",
  "severity": "string (enum: MINOR, MAJOR, CRITICAL)",
  "reportedAt": "ISO Date"
}
````

`PATCH /objects/{id}`

**Request:**
````json
{
  "condition": "string (enum: NEW, GOOD, FAIR, POOR)",
  "notes": "string"
}
````    
**Response 200:**
````json
{
  "id": "string",
  "name": "string",
  "type": "string",
  "ownerType": "string (enum: PERSONAL, FAF)",
  "ownerUserId": "string (or null if FAF)",
  "condition": "string (enum: NEW, GOOD, FAIR, POOR)",
  "notes": "string",
  "createdBy": "string (userId)",
  "createdAt": "ISO Date",
  "updatedAt": "ISO Date"
}
````

## GitHub Workflow

### Branch Naming Convention

Format: `type/scope/short-description`  

| Type     | Description | Example |
|----------|-------------|---------|
| feature | New functionality | feature/user-service/discord-login |
| bugfix  | Issue resolution | bugfix/booking-service/calendar-sync |
| chore   | Maintenance/config | chore/cpr/add-submodules |
| docs    | Documentation only | docs/cpr/readme-structure |

### Branch Rules

| Branch | Merge Strategy | Description |
|--------|----------------|-------------|
| `main` | **Rebase and merge** | Clean, linear history for production releases |
| `dev`  | **Squash and merge** | Condensed commits for feature integration |

**Branch Protection:**
- Direct pushes to `main` and `dev` are prohibited
- All changes must go through Pull Requests
- `main` and `dev` branches cannot be deleted
- Conversation issues must be resolved before merging
- Stale pull requests are dismissed

### Contribution Rules
| Requirement          | Policy |
|----------------------|--------|
| Code Review          | Minimum 2 contributor approvals before merging into dev or main |
| Commit Security      | All commits must pass GitGuardian checks (no secrets, no .env files) |
| Branch Naming        | All feature branches must pass the **Branch Name Check** action, enforcing the convention `type/scope/short-description` |
| Test Coverage        | Each microservice must maintain ≥ 80% |
| Pull Requests        | PRs must have a meaningful title and a short description of the changes if needed.|
| Versioning           | We follow **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`.<br> - `MAJOR`: breaking changes across services<br> - `MINOR`: new backward-compatible functionality<br> - `PATCH`: backward-compatible bug fixes |

### PR Structure Guide

#### PR Title Format

```
Type: Brief description
```

**Examples:**
- `Feature: Add post resolution functionality`
- `Bugfix: Fix decimal precision in transaction calculations`
- `Chore: Update authentication middleware`

#### PR Description Template

```markdown
## Summary
Brief description of what this PR accomplishes and why it's needed.

## Changes Made
- [ ] List specific changes
- [ ] Use checkboxes for major modifications
- [ ] Include both backend and frontend changes if applicable

## Service Impact
**Primary Service:** [Service Name]
**Secondary Services:** [List any services that might be affected]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] API testing done

## Screenshots/Evidence (if applicable)
<!-- Add screenshots for UI changes, API response examples, or logs -->

## Related Issues
- Closes #[issue-number]
- Related to #[issue-number]

## Breaking Changes
<!-- List any breaking changes or mark as "None" -->

## Additional Notes
<!-- Any additional context, deployment notes, or follow-up tasks -->
```

#### General Guidelines

- Reference the specific microservice in brackets
- Include test coverage information
- Mention database schema changes when applicable
- Note any environment variable additions
- Keep descriptions concise but informative
- Use checkboxes to track completion status

#### PR Size Guidelines

- **Small (< 200 lines):** Quick review, single feature/fix
- **Medium (200-500 lines):** Standard review, may need discussion
- **Large (> 500 lines):** Break down if possible, requires thorough review