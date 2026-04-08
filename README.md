
#  Consumer-Producer Marketplace

A full-stack marketplace platform with a shared backend powering both a web application and a Flutter mobile client.


<p align="center">
  <img src="https://github.com/user-attachments/assets/5d23684f-5d49-457e-8240-a469d4985986" width="70%">
  
  <img src="https://github.com/user-attachments/assets/1edae9d1-4d24-4f0e-99bf-c6f9d478aefa" width="30%">
</p>

---

## What It Does

A consumer-producer platform where users can list and discover products or services. The web app and mobile app share a single backend — login, auth tokens, and data are fully synchronised across both clients.

---

## Tech Stack

**Backend (Web)**
`Python` · `Django` · `Docker` · `REST API`

**Mobile**
`Dart` · `Flutter`

---

## Architecture

```
                    ┌─────────────────┐
                    │   Django API    │
                    │  (shared backend)│
                    └────────┬────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
    ┌─────────▼─────────┐       ┌──────────▼──────────┐
    │    Web Frontend   │       │   Flutter Mobile App  │
    │  (Django templates│       │   (iOS & Android)     │
    │   )               │       └──────────────────────┘
    └───────────────────┘
```

Both clients share JWT auth tokens — log in once, stay logged in on both.

---

## Project Structure

```
consumer-producer/
├── web/                      # Django web backend + frontend
│   ├── src/
│   │   └── spc/              # Main Django app
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── requirements.txt
└── flutter/                  # Mobile client
    └── lib/
        ├── main.dart
        └── ...
```

---

## Run with Docker

```bash
cd web
docker-compose up --build
# App runs at http://localhost:8000
```

## Run Flutter App

```bash
cd flutter
flutter pub get
flutter run
```

> Make sure the backend is running first — the Flutter app connects to it via the configured API base URL.

---

## Key Technical Points

- **Shared auth** — JWT tokens issued by Django, consumed by both the web and mobile clients
- **Single source of truth** — all data lives in one backend; no sync issues between platforms
- **Dockerised** — backend runs in a container for consistent environments

---

*Personal project — built to practice full-stack architecture with shared backend clients.*
