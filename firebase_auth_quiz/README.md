 # Firebase Auth Quiz

This Flutter project implements Email/Password authentication using Firebase.

What this update includes
- Login, Signup and Home screens using `firebase_auth`.
- Basic input validation, loading states and clearer error messages.
- `AuthGate` in `main.dart` to route users based on authentication state.

Prerequisites
- Flutter (stable) installed and on your PATH
- A Firebase project (console.firebase.google.com)

Quick setup
1. Create a Firebase project and enable Email/Password sign-in: Firebase Console > Authentication > Sign-in method.
2. Add an Android app to Firebase and download `google-services.json`. Place it in `android/app/`.
3. (iOS) Add an iOS app and download `GoogleService-Info.plist`. Place it in `ios/Runner/`.
4. From the project root run:

```powershell
flutter pub get
flutter run
```

If you see build errors referencing Gradle or Firebase plugins, follow the official Firebase Flutter installation docs:
https://firebase.flutter.dev/docs/installation

Generating the PDF report
- Open `report_template.md` and replace the screenshot placeholders with your screenshots (images placed in `assets/screens/`).
- Add your Git repository URL in the designated spot.
- Convert to PDF locally with `pandoc` or use VS Code `Markdown: Export (PDF)`:

```powershell
pandoc report_template.md -o firebase_auth_report.pdf
```

If you want me to create the PDF for you, upload the screenshots and provide the Git repo link and I will generate the PDF.

Need help committing/pushing?
- I can prepare a branch and show the `git` commands to push to your repo. Provide the remote URL and credentials or run the commands locally as instructed.

Enjoy — if anything fails while running, copy the terminal output here and I'll fix it.
