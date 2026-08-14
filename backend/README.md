# RoadGuard AI - Spring Boot Backend

Crowd-verified road hazard alerts backend built with Spring Boot 3, PostgreSQL + PostGIS.

## Tech Stack

- **Java 21**, Spring Boot 3.2
- **PostgreSQL 16** + **PostGIS 3.4** (geospatial queries)
- **Spring Security** + **JWT** (stateless auth)
- **Spring Data JPA** + **Hibernate Spatial**
- **MapStruct** (DTO mapping)
- **Lombok** (boilerplate reduction)
- **Cloudinary** (image upload)
- **WebSocket/STOMP** (real-time alerts)
- **Apache Commons Imaging** (EXIF, perceptual hash)
- **Testcontainers** (integration tests)

## Quick Start

### Prerequisites

- Java 21+
- Maven 3.9+
- Docker & Docker Compose (for PostgreSQL + Redis)

### 1. Start Infrastructure

```bash
cd backend
docker-compose up -d
```

### 2. Configure Environment

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

Required variables:
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `JWT_SECRET` (base64 encoded, min 256 bits)
- `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`

### 3. Run Application

```bash
# First time: generate Maven wrapper (or use system Maven)
mvn wrapper:wrapper
./mvnw spring-boot:run
```

Server starts at `http://localhost:8080/api/v1`

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register new user |
| POST | `/auth/login` | Login, get access + refresh tokens |
| POST | `/auth/refresh` | Refresh access token |

### Reports
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/reports` | Create report (multipart: `data` JSON + `image` file) |
| GET | `/reports` | List reports (paginated, filterable) |
| GET | `/reports/{id}` | Get report by ID |
| GET | `/reports/nearby` | Get hazards near lat/lng (public) |
| POST | `/reports/check-route` | Check hazards along route polyline |
| PUT | `/reports/{id}/status` | Update authority status (AUTHORITY/ADMIN) |

### Votes
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/reports/{reportId}/votes` | Cast upvote/downvote |
| GET | `/reports/{reportId}/votes/me` | Get current user's vote + status |

### WebSocket
Connect to `/ws` (SockJS/STOMP):
- Subscribe to `/topic/hazards/nearby/{lat,lng}` for nearby alerts
- Subscribe to `/topic/reports/new` for new report broadcasts
- Subscribe to `/topic/reports/{reportId}` for report updates

## Key Features

### Image Verification (Heuristic)
- **Blur detection**: Laplacian variance threshold
- **EXIF GPS cross-check**: Compare photo GPS vs submitted location
- **Perceptual hash deduplication**: pHash + Hamming distance within radius/lookback window

### Trust System
- Default trust score: 50
- Trusted threshold: 75
- Trusted votes count 2x
- Confirmation (+5 trust) / Dispute (-8 trust) applied once per report

### Community Verification
- Vote score ≥ 5 → CONFIRMED
- Vote score ≤ -5 → DISPUTED
- Separate from authority workflow status

### Geospatial Queries
- Nearby hazards: `ST_DWithin` with geography type (meters)
- Route hazards: `ST_Within` buffered LineString

## Project Structure

```
src/main/java/com/roadguard/backend/
├── config/           # WebSocket, security config
├── controller/       # REST endpoints
├── dto/              # Request/response DTOs
├── entity/           # JPA entities
├── exception/        # Global exception handling
├── repository/       # Spring Data JPA repos
├── security/         # JWT, filters, UserDetails
├── service/          # Business logic
└── util/             # Image verification, geo utils
```

## Testing

```bash
./mvnw test
```

Uses Testcontainers for PostgreSQL integration tests.

## Environment Variables

See `.env.example` for all configurable options.

## License

MIT