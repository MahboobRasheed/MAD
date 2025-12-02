# SmartTracker (Assignment 4)

SmartTracker is a Flutter app that tracks live location, captures images, and syncs activity logs to a REST API with offline caching.

Quick start (Windows):

- Ensure Flutter SDK and Node.js are installed and available in your PATH.
- Open a PowerShell terminal and start the mock API server:

```powershell
cd c:\Users\PC\Assignment4\SmartTracker\mock_server
npm install
node server.js
```

- In another PowerShell terminal fetch Flutter packages and run the app (Android emulator or connected device):

```powershell
cd c:\Users\PC\Assignment4\SmartTracker
flutter pub get
flutter run
```

Notes:
- The mock API uses port `3000`. Android emulators map `10.0.2.2` to host `localhost` (configured in `lib/main.dart`).
- On a real device, adjust `ApiService` `baseUrl` in `lib/main.dart` to the machine IP (e.g., `http://192.168.1.100:3000`).

See `UserManual.md` for the 1-page quick guide and `ProjectReport.md` for report contents and endpoints.
