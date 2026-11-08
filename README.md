# OrthoConnect

A Windows desktop app for an orthopedic practice: patient records, consultation history and visit scheduling, all stored locally.

> Status: paused. The core patient and visit flows work; it is kept here as a Flutter Desktop case study.

## Features

- Patient list with search, patient detail pages and photo attachments
- New patient and new visit forms with consultation history per patient
- Local SQLite database (no server, data stays on the clinic PC)
- Custom borderless window chrome and a settings screen

## Tech stack

- Flutter Desktop (Windows)
- SQLite via `sqflite_common_ffi`
- GetX for state and navigation
- `bitsdojo_window` for the custom title bar

## Why it is interesting

Flutter Desktop on Windows with a local FFI-backed SQLite database: no backend, simple deployment for a single practice, and the same UI code could later target macOS or tablets.

## Run

```bash
flutter pub get
flutter run -d windows
```

## License

MIT, see [LICENSE](LICENSE).
