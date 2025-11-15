# FlutterGoDemo


# Backend Service (Go + gRPC + PostgreSQL)

This backend provides a simple user service with:

- User registration
- User login
- Fetch user by ID

Tech stack:

- Go
- gRPC
- PostgreSQL
- GORM (ORM)

---

## 1. Prerequisites

- Go (1.20+)
- `protoc` (Protocol Buffers compiler)
- PostgreSQL (locally installed)
- Git

## 2. Install PostgreSQL via Homebrew (macOS)

```bash
brew install postgresql@16
brew services start postgresql@16
```

### Create the database and grant permissions:

```bash
psql sample_db
```
### In the psql prompt:

```bash
CREATE DATABASE sample_db;

GRANT ALL PRIVILEGES ON DATABASE sample_db TO postgres;
GRANT ALL ON SCHEMA public TO postgres;
ALTER SCHEMA public OWNER TO postgres;

\q
```
By default, the backend connects with:
	•	host: localhost
	•	port: 5432
	•	user: postgres
	•	password: postgres (or empty, depending on your local setup)
	•	db: sample_db

You can override these using environment variables (see below).


## 3. Go Dependencies
From the backend/ folder:
```bash
go mod tidy
```
This will ensure all Go dependencies are installed (GORM, gRPC, protobuf, etc.).

## 4. gRPC Code Generation (only if user.proto changes)

The generated Go files (user.pb.go, user_grpc.pb.go) are already checked in.

If you modify internal/proto/user.proto, regenerate them:
### 1.	Install the protoc plugins (one time):
```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```
Make sure $(go env GOPATH)/bin is in your PATH.


### 2.	From backend/internal/proto:
```bash
cd internal/proto

protoc \
  --go_out=. \
  --go-grpc_out=. \
  --go_opt=paths=source_relative \
  --go-grpc_opt=paths=source_relative \
  user.proto
```

## 5. Running the server

From the backend/ directory:
```bash
go run ./cmd/server
```
Expected log output:
```text
connected to database
gRPC server listening on :50051
```

# Frontend Services (Flutter)

