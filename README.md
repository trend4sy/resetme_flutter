# ResetMe

مساعدك اليومي للتوتر والنوم — افهم توترك، نم أفضل، ابدأ بروتين قصير يناسب يومك.

## Quick Start

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+

### Setup

```bash
# 1. Install Flutter
# Download from https://flutter.dev/docs/get-started/install

# 2. Clone & install dependencies
cd resetme_flutter
flutter pub get

# 3. Set up Supabase
# Create a project at https://supabase.com
# Copy your URL and anon key
# Run supabase/schema.sql in Supabase SQL Editor

# 4. Run with env vars
flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

### Environment Variables

All API keys are passed at build time via `--dart-define`. No secrets in the code.

| Variable | Required | Purpose |
|----------|----------|---------|
| `SUPABASE_URL` | Yes | Supabase project URL |
| `SUPABASE_ANON_KEY` | Yes | Supabase anonymous key |
| `OPENAI_API_KEY` | No | AI features (Premium) |
| `REVENUECAT_API_KEY` | No | Subscriptions (Premium) |

## Architecture

```
lib/
├── main.dart                    # Entry point + DI setup
├── app.dart                     # MaterialApp.router
├── core/                        # Theme, constants, router
├── data/                        # Models, Hive, Supabase, repos
├── services/                    # AI, audio, notifications
├── features/                    # Each feature = folder
│   ├── onboarding/              # First-use questionnaire
│   ├── checkin/                 # Daily mood/stress tracker
│   ├── breathing/               # 3 breathing techniques
│   ├── meditation/              # Short audio sessions
│   ├── journal/                 # Venting + gratitude
│   ├── sleep/                   # Sleep routine builder
│   ├── analytics/               # Weekly stats & charts
│   ├── settings/                # Profile & preferences
│   ├── subscription/            # Premium paywall
│   └── home/                    # Main dashboard
└── widgets/                     # Shared UI components
```

## Security

- API keys are server-side only (Supabase Edge Functions)
- Flutter obfuscation: `flutter build apk --obfuscate --split-debug-info=obfuscate/`
- RevenueCat handles payment validation
- Row Level Security on all Supabase tables
- No diagnostic claims — wellness support only

## Offline First

- Hive caches all data locally
- Supabase syncs in background when online
- All features work without internet

## Remote Control

Supabase `app_config` table controls:
- Free vs Premium features
- Feature flags (no app update needed)
- App settings (sounds, meditations count)

## Build

```bash
# Debug
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Release (Android)
flutter build apk --release --obfuscate --split-debug-info=obfuscate/ \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...

# Release (iOS)
flutter build ios --release --obfuscate --split-debug-info=obfuscate/ \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```
