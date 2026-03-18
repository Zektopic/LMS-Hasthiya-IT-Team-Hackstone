# Hackston LMS 🎓

A full-fledged, premium Learning Management System built with **Flutter** and **Firebase**.

## Features
- 🔐 **Secure Authentication:** Firebase Auth with a premium glassmorphic UI.
- 📺 **Rich Content Delivery:** Course browsing and detailed lesson views with video support.
- 🎨 **Premium Aesthetics:** Modern dark theme using Indigo/Violet accents and Inter typography.
- 🗄️ **Seamless Backend:** Fully integrated with Firestore for real-time course management.

## Getting Started

### Prerequisites
- Flutter SDK (Installed at `C:\src\flutter`)
- Firebase Account

### Setup
1. **Configure Firebase:**
   ```powershell
   flutterfire configure
   ```
2. **Install Dependencies:**
   ```powershell
   flutter pub get
   ```
3. **Run the App:**
   ```powershell
   flutter run
   ```

## Project Structure
- `lib/core`: App themes and global constants.
- `lib/models`: Data models for Courses, Lessons, and Users.
- `lib/services`: Firestore and Firebase Auth service logic.
- `lib/viewmodels`: State management using the Provider pattern.
- `lib/views`: UI screens organized by feature.

## License
MIT
