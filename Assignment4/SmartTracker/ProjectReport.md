# SmartTracker — Project Report

## Introduction & Objectives
- Objective: Build a cross-platform Flutter app that captures GPS location and camera images, stores a recent cache, and syncs activities with a REST API.

## API Design & Endpoints
- GET /activities — returns all activities
- POST /activities — create an activity (body: activity JSON)
- DELETE /activities/:id — delete an activity

## App Architecture
- Layers: UI (`lib/screens`, `lib/widgets`) → Provider (`lib/providers`) → Repository (`lib/repositories`) → Services (`lib/services`)
- Data flow: UI calls provider → provider calls repository → repository uses `ApiService` and Hive box for cache

## Sensor Handling
- GPS: `geolocator` used to request permissions and fetch current position.
- Camera: `image_picker` is used to capture images and return a local file path.

## Offline Storage
- Hive box `activities` stores up to 5 recent activity JSON objects for quick access when API unavailable.

## Testing Scenarios
- API: use `mock_server` with `postman_collection.json` to run CRUD tests.
- Sensor: test permission flows and capture on device/emulator (camera may be limited on emulators).
- Offline: stop the mock server and verify cached activities are shown.

## Files of Note
- `lib/main.dart` — app entry, Hive initialization, DI
- `lib/models/activity.dart` — activity model
- `lib/services/api_service.dart` — HTTP client
- `lib/repositories/activity_repository.dart` — cache + API logic
- `lib/providers/activity_provider.dart` — state management

## Future Improvements
- Upload images to server or cloud storage and store remote URLs.
- Add real-time location tracking with background service.
- Add user authentication and per-user activity lists.
