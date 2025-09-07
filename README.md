# FAF Management Platform

## Table of Contents
- [Service Boundaries](#service-boundaries)
  - [7. Lost & Found Service](#7-lost--found-service)
  - [8. Budgeting Service](#8-budgeting-service)
- [Technologies and Communication](#technologies-and-communication)
  - [7. Lost & Found Service](#7-lost--found-service-1)
  - [8. Budgeting Service](#8-budgeting-service-1)

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

### 7. Lost & Found Service

**Technology Stack:**
- Language: C#
- Framework: ASP.NET Core Web API
- Database: PostgreSQL
- Communication: REST with JSON

**Motivation:** C# provides good text handling for post content and comments. PostgreSQL offers full-text search for finding items and handles the post-comment relationships well. REST fits the simple CRUD operations needed.

**Trade-offs:** More setup overhead than lighter alternatives, but provides reliable data handling and built-in validation for user-generated content.

### 8. Budgeting Service

**Technology Stack:**
- Language: C#
- Framework: ASP.NET Core Web API
- Database: PostgreSQL
- Communication: REST with JSON

**Motivation:** C# decimal type prevents money calculation errors. PostgreSQL ACID compliance ensures financial data integrity. REST provides clear endpoints for different transaction types.

**Trade-offs:** Heavier stack than needed for simple operations, but financial accuracy requirements justify the choice. May need multiple API calls for complex reports.