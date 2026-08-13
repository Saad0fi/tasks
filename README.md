# Tasks — Thick Client vs Thin Client

A Flutter To-do app that demonstrates **two client architectures in one codebase**, switchable at runtime:

| Mode | Strategy | Source of truth |
|---|---|---|
| **Thin Client** | Cloud-first | Supabase (network required) |
| **Thick Client** | Offline-first | **Isar** local DB + sync to Supabase |

> Architecture demo — same UI, different data strategy.

## Why this project matters

This project focuses on architecture trade-offs, not only CRUD:

- Offline-first thinking and sync when connectivity returns
- Repository facade that swaps data sources (Thin vs Thick)
- Local persistence with **Isar** + remote API with **Supabase**
- Clean Architecture + BLoC with clear domain / data / presentation boundaries
- Architecture **trade-offs**, not only widgets

## Architecture

```
lib/
├── core/
│   ├── client_mode/          # Thin vs Thick toggle + service
│   ├── isar_module.dart
│   ├── supabase_module.dart
│   └── di.dart
└── features/todo/
    ├── data/
    │   ├── data_source/      # local (Isar) + remote (Supabase)
    │   ├── repositories/     # facade chooses implementation
    │   └── sync/             # todo_sync_service
    ├── domain/               # entities + use cases
    └── presentation/         # BLoC + UI
```

### Flow

```
UI → TodoBloc → TodosUseCase → TodoRepositoryFacade
                                      ├─ Thin  → RemoteDataSource (Supabase)
                                      └─ Thick → LocalDataSource (Isar) + SyncService
```

## Tech Stack

| Area | Tools |
|---|---|
| State | flutter_bloc, bloc, equatable |
| Local DB | isar_community |
| Backend | supabase_flutter |
| DI | get_it, injectable |
| Mapping | dart_mappable |

## Getting Started

```bash
git clone https://github.com/Saad0fi/tasks.git
cd tasks
cp .env.example .env
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Required `.env` keys

```
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

Copy `.env.example` → `.env`. Never commit real keys.

## How to try both modes

1. Launch the app
2. Use the in-app **Thin / Thick** toggle
3. **Thin:** create/edit tasks while online only
4. **Thick:** create tasks offline, then reconnect and watch sync

## Demo



https://github.com/user-attachments/assets/11668326-2cb5-45bd-a015-8395ba06d580



Thin vs Thick client toggle, offline create, and sync when back online.

## Related content

- TikTok: [Thin Client & Thick Client](https://www.tiktok.com/@saad_0fi/video/7640627063077997845)

## License

Portfolio / educational use.

## Author

**Saad Alharbi** — Flutter Developer  
LinkedIn: https://www.linkedin.com/in/saad-alharbi-659a94267/  
GitHub: https://github.com/Saad0fi
