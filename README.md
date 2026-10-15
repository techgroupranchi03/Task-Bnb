# Task Bnb

Property and task management mobile app built with Flutter.

## Tech Stack
- **State**: Riverpod
- **Network**: Dio
- **Routing**: go_router  
- **Storage**: flutter_secure_storage + shared_preferences
- **Models**: Freezed + json_serializable
- **Env**: flutter_dotenv

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Running by Environment

```bash
# Development
flutter run -t lib/main_development.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_production.dart
```

## Environment Files
Create at project root:
- `.env.development`
- `.env.staging`
- `.env.production`

```
APP_ENV=development
BASE_URL=https://your-api-url.com
API_TIMEOUT=30000
ENABLE_LOGGING=true
```

## Architecture

Each feature: `data/` → `domain/` → `presentation/`

## Application ID
- Android & iOS: `com.taskbnb.app`
