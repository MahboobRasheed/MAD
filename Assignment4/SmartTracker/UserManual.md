# SmartTracker — User Manual (1-page)

Quick steps:

- Start the mock API server (for development):

  ```powershell
  cd c:\Users\PC\Assignment4\SmartTracker\mock_server
  npm install
  node server.js
  ```

- Launch the Flutter app (emulator or device):

  ```powershell
  cd c:\Users\PC\Assignment4\SmartTracker
  flutter pub get
  flutter run
  ```

Using the app:

- Get Location: taps device GPS and displays coordinates.
- Capture Image: opens camera and stores captured image locally.
- Save Activity: saves current location + optional image with timestamp and syncs to the mock API. If the API is unavailable, it caches locally (last 5).
- Open Map: opens map view (requires Google Maps setup for API keys to show tiles).
- View Activities: view, refresh, search (basic listing), and delete activities.

Notes & Troubleshooting:
- Emulator: use `10.0.2.2` to access host `localhost` (already configured).
- If images do not appear on emulator, test on a real device or use an emulator that supports camera.
- To change API endpoint, edit `ApiService` `baseUrl` in `lib/services/api_service.dart` or `lib/main.dart`.
