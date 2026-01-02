# Password Manager (Flutter)

A cross-platform **Password Manager** app built with **Flutter**.  
This repository contains the Flutter app plus platform targets (Android, iOS, Web, Windows, macOS, Linux).

> ⚠️ **Disclaimer:** This project is for learning/personal use. Review the code and security model carefully before storing real secrets.

---

## ✨ Goals

- Store credentials in a simple, searchable vault
- Keep data **local-first**
- Protect the vault with a **master password** (and optionally biometrics)
- Provide a secure **password generator**
- Support multiple platforms via Flutter

---

## ✅ Features (current / planned)

This project may still be evolving—treat the list below as a roadmap-style checklist.

- [ ] Master password / lock screen
- [ ] Add / edit / delete vault items (site, username, password, notes)
- [ ] Search + filter
- [ ] Password generator (length, symbols, numbers, etc.)
- [ ] Copy-to-clipboard with auto-clear timer
- [ ] Encrypted local storage (vault)
- [ ] Optional biometric unlock
- [ ] Import / export (CSV/JSON) *(optional)*

---

## 🧰 Tech Stack

- **Flutter** / **Dart**
- Platform targets: Android, iOS, Web, Windows, macOS, Linux

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- A configured device/emulator (Android Studio / Xcode) **or** a desktop/web target enabled

Verify Flutter setup:
```bash
flutter doctor
Install dependencies
From the project root:
```
```bash
flutter pub get
Run the app
```
```bash
flutter run
```
Run on a specific platform
Examples:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```
🏗️ Build
Android (APK)
```bash
flutter build apk
```
iOS
```bash
flutter build ios
```
Web
```bash
flutter build web
```
Windows / macOS / Linux
```bash
flutter build windows
flutter build macos
flutter build linux
```
🗂️ Project Structure (typical Flutter)
```bash
lib/        # App source code (UI + logic)
test/       # Tests
android/    # Android native project
ios/        # iOS native project
web/        # Web target
windows/    # Windows target
macos/      # macOS target
linux/      # Linux target
```
🔐 Security Notes
If you plan to store real passwords:

Ensure the vault is encrypted at rest

Avoid logging sensitive values (passwords, keys, tokens)

Prefer well-reviewed crypto/storage packages

Implement auto-lock and clipboard timeout behavior

Consider device backups/cloud sync implications

🧪 Testing
```bash
flutter test
```
