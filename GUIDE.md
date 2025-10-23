# Gateway & Discovery Integration Guide

This document explains how to integrate your service with the Gateway and Discovery systems, configure Prometheus/Grafana metrics, and ensure smooth operation within the distributed environment.

---

## 1. Registration

### Health Endpoint

Your service must implement:

```http
GET /health
```

It should return **HTTP 200** when the service is healthy.

---

### Load Endpoint

Implement:

```http
GET /load
```

It should return the **CPU** and **memory** load percentages (calculated on each request) in JSON format:

```json
{
  "cpu": 24.2,
  "memory": 34.6
}
```

**Important:** Without the `/load` endpoint, the service will **not register** with Discovery.

---

### Environment Variables

Your service must read the following environment variables:

```
GATEWAY_URL
DISCOVERY_URL
```

---

### Registration Request

On application startup, make a `POST` request to:

```
{DISCOVERY_URL}/register
```

Request body format:

```json
{
  "serviceName": "lostFoundService",
  "port": 80
}
```

* Use your own `serviceName` and `port`.
* Keep service names **camelCase**, following this convention:

```yaml
loadBalancing:
  budgetingService: "ROUND_ROBIN"
  lostFoundService: "SERVICE_LOAD"
  userManagementService: "SERVICE_LOAD"
  notificationService: "ROUND_ROBIN"
  teaManagementService: "ROUND_ROBIN"
  communicationService: "SERVICE_LOAD"
  cabBookingService: "ROUND_ROBIN"
  checkInService: "ROUND_ROBIN"
  fundRaisingService: "SERVICE_LOAD"
  sharingService: "SERVICE_LOAD"
```

---

### Service Ping Task

Implement a background task that performs a **5-second ping** between your private services.
Every 5 seconds, send a request:

```
GET {GATEWAY_URL}/api/yourOtherService/health
```

and log the result.
This ensures continuous communication monitoring between services.

---

## 2. Grafana / Prometheus Configuration

Each service must expose **Prometheus metrics**.

Expose a `/metrics` endpoint using your Prometheus client library (this is usually done automatically).

Use Prometheus metrics for:

* **Counters** (e.g., errors, total requests)
* **Histograms** (e.g., latency, response times)

Prometheus will automatically scrape these endpoints on an interval.

---

## 3. Docker Compose Changes

Several refactors were made for simplicity and consistency:

* Ports are now **hardcoded**. Each service is responsible for reporting its own port to the Gateway.
* Ports are **not exposed externally**, so they no longer need to appear in `.env`.
* Verify that your application correctly reads both environment variables and Docker Compose configuration.

If something fails, double-check that your environment and service registration logic match the updated setup.

---

## 4. Logging

All logs should be written to **STDOUT**.
Promtail automatically scrapes and forwards these logs to the central system.

You can use your logging library or direct console output.

When logging events, remember to increment related Prometheus metrics (for example, increase the error counter when logging an error):

```js
logger.error("Failed to process request");
metrics.errors.inc();
```

---

## 5. Prometheus Sources

Because the system is scalable, Prometheus cannot rely on static single targets.
It dynamically scrapes all services defined in:

```
monitoring/prometheus.yml
```

You must:

* Specify the **ports** for each service.
* Ensure that the **job** and **target names** match exactly with the service names in `docker-compose.yml`.

Example:

```yaml
- job_name: 'lostFoundService'
  static_configs:
    - targets: ['lostfound:8080']
```

**Do not set `container_name` in `docker-compose.yml`**, as this breaks replication and scaling.

---

## Summary Checklist

| Task                                     | Status |
| ---------------------------------------- | ------ |
| `/health` returns 200                    | ☐      |
| `/load` returns CPU & memory             | ☐      |
| POST to Discovery `/register` on startup | ☐      |
| 5-second ping between private services   | ☐      |
| Prometheus `/metrics` endpoint enabled   | ☐      |
| Logs to STDOUT & metrics increment       | ☐      |
| Ports defined in `prometheus.yml`        | ☐      |
| No `container_name` in docker-compose    | ☐      |

---

## Notes

* Keep service names **consistent** and **camelCase**.
* If registration fails, first verify the `/load` endpoint and registration payload.
* Prometheus and logging setup should be automatically compatible once your service implements the required endpoints.

---
