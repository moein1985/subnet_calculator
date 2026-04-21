# Subnet Calculator

A lightweight Flutter app for practical IPv4 subnet calculations with beginner-friendly education and IPv6 basics.

## Features

- IPv4 subnet calculator
- Supports prefix input as `24`, `/24`, or subnet mask like `255.255.255.0`
- IPv4 outputs: Network, Broadcast, Subnet Mask, Wildcard, First/Last Host, Usable Hosts
- IPv6 basic analysis: compressed/expanded form, network prefix, classification, basic/advanced view
- Built-in learning section with schematic prefix slider and mini quiz
- Calculation history with quick reuse and delete/clear actions
- Persian and English localization (RTL/LTR support)
- Offline-first behavior using local storage only

## Tech Stack

- Flutter + Material 3
- `go_router` for navigation
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `shared_preferences` for local persistence

## Project Structure

- `lib/core`: shared infrastructure (DI, localization, storage)
- `lib/features/subnet`: IPv4 calculator
- `lib/features/ipv6`: IPv6 analysis
- `lib/features/education`: educational content
- `lib/features/history`: saved calculations
- `lib/features/settings`: language and app preferences
- `lib/router`: app shell and route configuration

## Getting Started

1. Install Flutter SDK (stable channel).
2. Run dependency install:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Quality Commands

```bash
flutter analyze
flutter test
```

## Privacy

This app is designed to work offline for core calculations. User data such as settings and history is stored locally on device via SharedPreferences.
