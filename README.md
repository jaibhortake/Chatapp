# ChatMe (Connect Me)

A group chat app built with **Flutter** and **Firebase**. Users sign up, create or join groups, and chat with group members in real time.

## Features

- Email/password sign up and login (Firebase Authentication)
- Stays logged in between app launches
- Create groups, search groups by name (prefix match), join or leave them
- Real-time group messaging (Cloud Firestore) with message times and Today/Yesterday dividers
- Unread dot on groups with new messages
- Group info page showing the admin and members
- Profile page with name and email

## Tech Stack

| Part      | Used                                  |
|-----------|---------------------------------------|
| App       | Flutter (Dart SDK >= 3.2)             |
| Auth      | `firebase_auth`                       |
| Database  | `cloud_firestore`                     |
| Local data| `shared_preferences`                  |

## Project Structure

```
lib/
├── main.dart            # App entry: initializes Firebase, picks login or home screen
├── pages/               # Screens: login, register, home, chat, search, group info, profile
├── service/             # auth_service.dart (Firebase Auth), database_service.dart (Firestore)
├── helper/              # Saves login state locally
├── widgets/             # Reusable UI: group tile, message tile, helpers
└── shared/constant.dart # App colors
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.16 or newer
- Android Studio (or an Android device / emulator)

### Run

```bash
git clone https://github.com/jaibhortake/Chatapp.git
cd Chatapp
flutter pub get
flutter run
```

The app is configured for **Android**. The included `android/app/google-services.json` connects it to the existing Firebase project.

### Using your own Firebase project (optional)

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com).
2. Add an Android app with package name `com.example.chatme`.
3. Download `google-services.json` and replace `android/app/google-services.json`.
4. Enable **Email/Password** sign-in under *Authentication*.
5. Create a **Cloud Firestore** database.

> iOS, web and desktop are not configured for Firebase yet. To support them, run `flutterfire configure` and pass the generated options to `Firebase.initializeApp()` in `lib/main.dart`.

## Firestore Data

- `users/{uid}` – `fullname`, `email`, `groups` (list of `groupId_groupName`)
- `groups/{groupId}` – `groupName`, `admin`, `members`, `recentMessage`, …
- `groups/{groupId}/messages` – `message`, `sender`, `time`
