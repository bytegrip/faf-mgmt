# FAF Cab Management Platform

## Project Overview
A microservices-based platform designed to manage FAF Cab organizational activities, including room bookings, visitor tracking, resource management, and community communications.

## Team Members
- Friptu Ludmila - Cab Booking Service & Check-in Service (Node.js)
- [Member 2 Name] - [Service Name] ([Language])
- [Member 3 Name] - [Service Name] ([Language])
- [Member 4 Name] - [Service Name] ([Language])
- [Member 5 Name] - [Service Name] ([Language])

## Architecture Overview

### Service Boundaries

Our platform is decomposed into the following microservices, each with clearly defined responsibilities:

#### 1. **Cab Booking Service** (Node.js)
- **Responsibility**: Managing room reservations and scheduling
- **Core Functionality**:
  - Schedule meetings in main room or kitchen
  - Prevent booking conflicts
  - Google Calendar integration
  - Time slot management
  - Booking notifications

#### 2. **Check-in Service** (Node.js)
- **Responsibility**: Tracking user presence and visitor management
- **Core Functionality**:
  - Real-time entry/exit tracking via facial recognition simulation
  - Key holder identification
  - One-time guest registration
  - Unknown person detection and admin alerts
  - Presence history logging

#### 3. **User Management Service**
- **Responsibility**: User authentication and profile management
- **Core Functionality**: User registration, role management, Discord integration

#### 4. **Notification Service**
- **Responsibility**: System-wide notification delivery
- **Core Functionality**: Multi-channel notifications, priority handling

#### 5. **Tea Management Service**
- **Responsibility**: Consumables tracking and inventory
- **Core Functionality**: Resource tracking, usage monitoring, low stock alerts

#### 6. **Communication Service**
- **Responsibility**: Chat and messaging functionality
- **Core Functionality**: Public/private chats, content moderation

#### 7. **Lost & Found Service**
- **Responsibility**: Lost item reporting and tracking
- **Core Functionality**: Item posting, comment threads, resolution tracking

#### 8. **Budgeting Service**
- **Responsibility**: Financial management and transparency
- **Core Functionality**: Fund tracking, debt management, reporting

#### 9. **Fund Raising Service**
- **Responsibility**: Crowdfunding for purchases
- **Core Functionality**: Campaign creation, donation tracking

#### 10. **Sharing Service**
- **Responsibility**: Multi-use object lending system
- **Core Functionality**: Item rental, condition tracking, ownership management

### Architecture Diagram



## Technology Stack & Communication Patterns

### Services Technology Distribution

| Service | Language/Framework | Justification |
|---------|-------------------|---------------|
| **Cab Booking Service** | Node.js (Express.js) | - Event-driven architecture perfect for real-time booking updates<br>- Excellent Google Calendar API support<br>- Non-blocking I/O ideal for handling concurrent booking requests
| **Check-in Service** | Node.js (Express.js) | - WebSocket support for real-time presence updates<br>- Efficient handling of frequent check-in/out events<br>- Easy integration with facial recognition APIs<br>- Fast response times for access control |
| *[Other Service 1]* | *[Language 2]* | *[Team member to complete]* |
| *[Other Service 2]* | *[Language 2]* | *[Team member to complete]* |
| *[Other Service 3]* | *[Language 3]* | *[Team member to complete]* |
| *[Other Service 4]* | *[Language 3]* | *[Team member to complete]* |

### Communication Patterns

- **Synchronous Communication (REST)**: Primary pattern for client-service and service-service communication
- **Asynchronous Communication (Message Queue)**: For event-driven notifications and non-critical updates
- **WebSockets**: Real-time updates for check-ins and booking status changes
- **gRPC**: High-performance inter-service communication for latency-critical operations

### Trade-offs Analysis

**Node.js for Cab Booking & Check-in Services:**
- ✅ **Pros**: Fast development, excellent async handling, rich NPM ecosystem, great for I/O-intensive operations
- ❌ **Cons**: Single-threaded (mitigated by clustering), less suitable for CPU-intensive tasks
- **Business Impact**: Enables rapid feature development and real-time user experience crucial for booking and access control

## Communication Contract

### Global Response Format
All endpoints return responses in the following format:

```json
{
  "success": boolean,
  "data": object | array | null,
  "error": {
    "code": string,
    "message": string,
    "details": object
  } | null,
  "timestamp": "ISO 8601 datetime",
  "requestId": "uuid"
}
```

### Service Endpoints

#### Cab Booking Service

**Base URL**: `/api/v1/bookings`

| Endpoint | Method | Description | Request | Response |
|----------|--------|-------------|---------|----------|
| `/bookings` | GET | List all bookings | Query params: `?room={main|kitchen}&date={YYYY-MM-DD}&status={pending|confirmed|cancelled}` | `{ bookings: [BookingObject] }` |
| `/bookings` | POST | Create new booking | ```json<br>{<br>  "room": "main|kitchen",<br>  "title": "string",<br>  "description": "string",<br>  "startTime": "ISO 8601",<br>  "endTime": "ISO 8601",<br>  "attendees": ["userId"],<br>  "recurring": {<br>    "frequency": "daily|weekly|monthly",<br>    "until": "ISO 8601"<br>  }<br>}``` | ```json<br>{<br>  "bookingId": "uuid",<br>  "status": "confirmed",<br>  "conflictsWith": [],<br>  "calendarEventId": "string"<br>}``` |
| `/bookings/{id}` | GET | Get booking details | Path param: `id` | `{ booking: BookingObject }` |
| `/bookings/{id}` | PUT | Update booking | Same as POST | `{ booking: BookingObject }` |
| `/bookings/{id}` | DELETE | Cancel booking | Path param: `id` | `{ message: "Booking cancelled" }` |
| `/bookings/{id}/confirm` | POST | Confirm booking | Path param: `id` | `{ booking: BookingObject }` |
| `/bookings/availability` | GET | Check room availability | Query params: `?room={main|kitchen}&date={YYYY-MM-DD}` | `{ availableSlots: [TimeSlot] }` |
| `/bookings/conflicts` | POST | Check for conflicts | Same as create booking request | `{ hasConflicts: boolean, conflicts: [BookingObject] }` |
| `/bookings/sync` | POST | Sync with Google Calendar | `{ forceSync: boolean }` | `{ syncedCount: number, errors: [] }` |

#### Check-in Service

**Base URL**: `/api/v1/checkin`

| Endpoint | Method | Description | Request | Response |
|----------|--------|-------------|---------|----------|
| `/checkin/enter` | POST | Record entry | ```json<br>{<br>  "userId": "string",<br>  "method": "facial|manual|card",<br>  "faceData": "base64_encoded",<br>  "timestamp": "ISO 8601"<br>}``` | ```json<br>{<br>  "checkInId": "uuid",<br>  "userId": "string",<br>  "hasKey": boolean,<br>  "currentOccupancy": number<br>}``` |
| `/checkin/exit` | POST | Record exit | ```json<br>{<br>  "userId": "string",<br>  "timestamp": "ISO 8601",<br>  "keyReturned": boolean<br>}``` | ```json<br>{<br>  "checkOutId": "uuid",<br>  "duration": "minutes",<br>  "keyHolder": "userId|null"<br>}``` |
| `/checkin/current` | GET | Get current occupants | Query params: `?includeGuests=true` | `{ occupants: [UserPresence], totalCount: number }` |
| `/checkin/keyholder` | GET | Identify key holder | None | `{ keyHolder: { userId: "string", name: "string", checkInTime: "ISO 8601" } }` |
| `/checkin/guests` | POST | Register guest | ```json<br>{<br>  "guestName": "string",<br>  "hostUserId": "string",<br>  "purpose": "string",<br>  "expectedDuration": "minutes",<br>  "photo": "base64_encoded"<br>}``` | ```json<br>{<br>  "guestId": "uuid",<br>  "accessCode": "string",<br>  "expiresAt": "ISO 8601"<br>}``` |
| `/checkin/guests/{id}` | DELETE | Remove guest | Path param: `id` | `{ message: "Guest removed" }` |
| `/checkin/history` | GET | Get check-in history | Query params: `?userId={id}&from={date}&to={date}&limit={number}` | `{ history: [CheckInRecord], total: number }` |
| `/checkin/unknown` | POST | Report unknown person | ```json<br>{<br>  "description": "string",<br>  "photo": "base64_encoded",<br>  "location": "string",<br>  "reportedBy": "userId"<br>}``` | ```json<br>{<br>  "reportId": "uuid",<br>  "notificationSent": boolean<br>}``` |
| `/checkin/stats` | GET | Get presence statistics | Query params: `?period={day|week|month}` | `{ peakHours: [], averageOccupancy: number, totalVisits: number }` |

### Data Models

#### BookingObject
```json
{
  "bookingId": "uuid",
  "room": "main|kitchen",
  "title": "string",
  "description": "string",
  "organizerId": "userId",
  "attendees": ["userId"],
  "startTime": "ISO 8601",
  "endTime": "ISO 8601",
  "status": "pending|confirmed|cancelled",
  "recurring": {
    "frequency": "daily|weekly|monthly",
    "until": "ISO 8601"
  },
  "googleCalendarId": "string",
  "createdAt": "ISO 8601",
  "updatedAt": "ISO 8601"
}
```

#### UserPresence
```json
{
  "userId": "string",
  "userName": "string",
  "checkInTime": "ISO 8601",
  "hasKey": boolean,
  "isGuest": boolean,
  "guestHost": "userId|null",
  "lastSeenLocation": "string"
}
```

#### CheckInRecord
```json
{
  "recordId": "uuid",
  "userId": "string",
  "checkInTime": "ISO 8601",
  "checkOutTime": "ISO 8601|null",
  "duration": "minutes|null",
  "hadKey": boolean,
  "method": "facial|manual|card"
}
```

### Inter-Service Communication

#### Event Publishing

**Cab Booking Service publishes:**
- `booking.created` - When new booking is made
- `booking.updated` - When booking is modified
- `booking.cancelled` - When booking is cancelled
- `booking.reminder` - 15 minutes before booking starts

**Check-in Service publishes:**
- `user.entered` - When user enters FAF Cab
- `user.exited` - When user leaves
- `key.transferred` - When key holder changes
- `unknown.detected` - When unknown person detected
- `guest.registered` - When guest is registered

#### Service Dependencies

**Cab Booking Service requires:**
- User Management Service: User validation and role checking
- Notification Service: Sending booking confirmations and reminders

**Check-in Service requires:**
- User Management Service: User identification and validation
- Notification Service: Security alerts and key holder notifications

## Database Design

### Cab Booking Service Database
- **Database Type**: PostgreSQL (for ACID compliance and complex queries)
- **Main Collections/Tables**:
  - `bookings` - Booking records with full history
  - `rooms` - Room configurations and capacity
  - `booking_rules` - Booking restrictions and policies
  - `recurring_patterns` - Templates for recurring bookings

### Check-in Service Database
- **Database Type**: MongoDB (for flexible schema and fast writes)
- **Main Collections**:
  - `checkins` - Active and historical check-in records
  - `guests` - Temporary guest registrations
  - `unknown_reports` - Unknown person sightings
  - `key_transfers` - Key holder history

## GitHub Workflow

### Branch Strategy
- **Main Branch**: `main` - Production-ready code
- **Development Branch**: `develop` - Integration branch
- **Feature Branches**: `feature/{service-name}/{feature-description}`
- **Bugfix Branches**: `bugfix/{issue-number}-{description}`
- **Hotfix Branches**: `hotfix/{issue-number}-{description}`

### Merge Requirements
- Minimum 2 approvals required for merging to `develop`
- Minimum 3 approvals required for merging to `main`
- All CI/CD checks must pass
- Code coverage must be maintained above 80%

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No sensitive data exposed
```

### Commit Convention
Format: `<type>(<scope>): <subject>`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

Example: `feat(booking): add recurring booking support`

### Versioning Strategy
- Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`
- Tag releases: `v1.0.0`
- Maintain CHANGELOG.md

## Development Guidelines

### Code Quality Standards
- ESLint configuration for Node.js services
- Prettier for code formatting
- Pre-commit hooks for linting
- Minimum 80% test coverage

### Security Practices
- Never commit `.env` files
- Use environment variables for sensitive data
- Implement rate limiting on all public endpoints
- Input validation and sanitization
- JWT tokens for authentication

### Naming Conventions
- **Services**: PascalCase (e.g., `CabBookingService`)
- **Endpoints**: kebab-case (e.g., `/check-in/current`)
- **Variables**: camelCase (e.g., `userId`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_BOOKING_DURATION`)
- **Database**: snake_case (e.g., `user_id`)

## Project Management

### GitHub Project Board
- **Columns**: Backlog → To Do → In Progress → Review → Done
- **Issue Labels**:
  - `priority: high/medium/low`
  - `type: bug/feature/enhancement`
  - `service: booking/checkin/etc`
  - `status: blocked/help-wanted`

### Task Estimation
- Story points: 1, 2, 3, 5, 8, 13
- Sprint duration: 1 week

## Getting Started

### Prerequisites
- Node.js 18+ (for Node.js services)
- Docker & Docker Compose
- PostgreSQL 14+
- MongoDB 6+
- Redis (for caching)

### Local Development Setup

1. Clone the repository with submodules:
```bash
git clone --recurse-submodules https://github.com/[your-org]/faf-cab-platform.git
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. Install dependencies:
```bash
# For Node.js services
cd services/cab-booking-service
npm install

cd ../checkin-service
npm install
```

4. Start services:
```bash
docker-compose up -d
```

### Running Tests
```bash
# Unit tests
npm test

# Integration tests
npm run test:integration

# Coverage report
npm run test:coverage
```

## Deployment

### Container Registry
- Docker images tagged with version
- Latest tag for development branch
- Stable tag for production

### Environment Configuration
- Development: `.env.development`
- Staging: `.env.staging`
- Production: `.env.production`

## Monitoring & Logging

### Logging Standards
- Structured JSON logging
- Log levels: ERROR, WARN, INFO, DEBUG
- Correlation IDs for request tracing

### Metrics
- Response time percentiles (p50, p95, p99)
- Error rates by endpoint
- Service availability (uptime)
- Database connection pool metrics
