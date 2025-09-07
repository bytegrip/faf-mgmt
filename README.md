# FAF Management Platform

## Table of Contents
- [Service Boundaries](#service-boundaries)
  - [7. Lost & Found Service](#7-lost--found-service)
  - [8. Budgeting Service](#8-budgeting-service)

## Service Boundaries

### 7. Lost & Found Service

| **Aspect** | **Description** |
|------------|-----------------|
| **Core Responsibility** | Lost item management and community board |
| **Service Boundaries** | • Post creation and management for lost/found items<br>• Multi-threaded comment system under each post<br>• Post resolution status tracking and lifecycle management<br>• Operates as a relatively isolated service with minimal external dependencies |
| **Detailed Functionality** | • **Post Management**: Create, edit, delete, and categorize lost/found posts with detailed item descriptions<br>• **Advanced Search**: Filter posts by category, date, location, resolution status, and keywords<br>• **Comment System**: Nested comment threads with reply functionality and user attribution<br>• **Status Tracking**: Mark posts as "Lost", "Found", "In Progress", "Resolved" with timestamp logging<br>• **User Interaction**: Allow post creators to mark their own posts as resolved<br>• **Content Moderation**: Basic content filtering and spam prevention<br>• **Analytics**: Track post resolution rates and popular item categories<br>• **Notification Integration**: Request notifications for post updates and resolutions |

### 8. Budgeting Service

| **Aspect** | **Description** |
|------------|-----------------|
| **Core Responsibility** | Financial tracking and transparency |
| **Service Boundaries** | • Comprehensive treasury balance management<br>• Detailed transaction logging for all financial activities<br>• Debt book management for damages and resource overuse<br>• Financial reporting with CSV export capabilities<br>• Passive financial data receiver that maintains transparency without initiating business actions |
| **Detailed Functionality** | • **Treasury Management**: Track current balance, historical balance changes, and fund allocation<br>• **Transaction Logging**: Record all donations, expenses, transfers with timestamps, categories, and user attribution<br>• **Debt Management**: Maintain user debt records, calculate interest/penalties, track payment plans<br>• **Multi-Source Tracking**: Separate accounting for FAF donations vs Partner donations vs fundraising campaigns<br>• **Reporting Engine**: Generate monthly/quarterly reports, expense breakdowns, donation summaries<br>• **CSV Export**: Customizable financial reports with filtering by date range, category, user, transaction type<br>• **Audit Trail**: Immutable financial records with full transaction history and change logs<br>• **Budget Forecasting**: Track spending patterns and provide budget recommendations<br>• **Integration Points**: Receive transaction data from Fund Raising, Tea Management, and Sharing services |