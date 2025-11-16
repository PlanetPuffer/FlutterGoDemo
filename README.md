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
CREATE USER postgres WITH PASSWORD 'postgres';

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

## Frontend (Flutter + gRPC)

This project includes a Flutter frontend that communicates with the Go gRPC backend.

### 1. Prerequisites

- Flutter SDK (3.x recommended)
- Xcode (for iOS simulator)
- `protoc` + Dart gRPC plugin

Install the Dart protoc plugin:
```bash
dart pub global activate protoc_plugin
```
Ensure `~/.pub-cache/bin` is in your PATH.

### 2. Project Structure (frontend/flutter_frontend)

```
lib/
  proto/                # gRPC‑generated Dart files
  pages/
    login_page.dart
    workout_log_page.dart
    account_page.dart
  services/
    grpc_client.dart
  main.dart
proto/
  user.proto            # same proto as backend
```

### 3. Generating Dart gRPC Files (only when proto changes)

From `frontend/flutter_frontend`:

```bash
rm -rf lib/proto
mkdir -p lib/proto

protoc \
  -I=proto \
  --dart_out=grpc:lib/proto \
  proto/user.proto
```

This generates:
- `user.pb.dart`
- `user.pbgrpc.dart`
- `user.pbenum.dart`
- `user.pbjson.dart`

### 4. Running the Flutter App

macOS desktop:
```bash
flutter run -d macos
```

iOS simulator:
```bash
open -a Simulator
flutter run -d ios
```

Chrome/web:
```bash
flutter run -d chrome
```

Windows (if enabled in Flutter):
```bash
flutter run -d windows
```

### 5. Frontend Features

- **User Registration / Login**
  Uses gRPC `Register` and `Login` calls.

- **Workout Logger**
  - Add workout entries
  - Edit entries
  - Delete entries
  - Categorize workouts
  - Search by content or date:
    - `2025` → year filter
    - `2025-11` → month filter
    - `2025-11-01` → daily filter
  - Sort logs (newest / oldest)

- **Profile Page**
  - Update name
  - Update email
  - Update date of birth
  - Uses gRPC `GetProfile` / `UpdateProfile`

- **Deactivate Account**
  - Uses gRPC `DeactivateAccount`
  - Backend marks user as `active = false`
  - Deactivated users cannot log in again

### 6. gRPC Client (Flutter)

The app uses a shared channel creator:

```
ClientChannel createChannel() {
  return ClientChannel(
    backendHost(),
    port: 50051,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
}
```

### 7. Backend Connection

On macOS/iOS simulator, `localhost:50051` works by default.

On physical devices, use your machine’s LAN IP:
```
192.168.x.x:50051
```

Modify `backendHost()` in Flutter accordingly.
