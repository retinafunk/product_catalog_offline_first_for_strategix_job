# AGENTS Guide

## Project Snapshot
- This repository is a near-default Flutter starter app with a renamed root widget.
- Product goal is stated in `README.md` as an offline-first catalog, but current implementation is still template-level.
- Main app entrypoint is `lib/main.dart`; there are no feature modules, repositories, or API clients yet.

## Architecture (Current State)
- `main()` calls `runApp(const ProductsCatalogueApp())` in `lib/main.dart`.
- UI flow is single-screen: `ProductsCatalogueApp` -> `MaterialApp` -> `MyHomePage`.
- State is local-only in `_MyHomePageState` via `_counter` + `setState`; no persistence or networking.

## Developer Workflows
- Install deps:
  ```powershell
  flutter pub get
  ```
- Analyze code:
  ```powershell
  flutter analyze
  ```
  Current baseline failure: `test/widget_test.dart` references `MyApp`, but `lib/main.dart` defines `ProductsCatalogueApp`.
- Run tests:
  ```powershell
  flutter test
  ```
  Current baseline result: same `ProductsCatalogueApp` symbol mismatch causes compile failure.
- Run app locally:
  ```powershell
  flutter run
  ```

## Conventions and Patterns in This Repo
- Naming divergence from template: root app widget is `ProductsCatalogueApp` (not `MyApp`).
- Lint policy is default Flutter lints via `analysis_options.yaml` -> `include: package:flutter_lints/flutter.yaml`.
- Dependencies are minimal in `pubspec.yaml` (`flutter`, `cupertino_icons`, `flutter_test`, `flutter_lints`).
- Keep changes small and explicit; this codebase currently favors straightforward `StatefulWidget` + `setState` examples.

## Platform/Build Integration Notes
- Android uses Gradle Kotlin DSL (`android/app/build.gradle.kts`, `android/settings.gradle.kts`).
- Android plugin versions are pinned in `android/settings.gradle.kts` (`com.android.application` 8.7.0, Kotlin 1.8.22).
- Flutter Gradle plugin is applied in `android/app/build.gradle.kts` as `dev.flutter.flutter-gradle-plugin`.
- Release build type currently signs with debug keys (`android/app/build.gradle.kts`), which is dev-only scaffolding.

## Practical Guidance for AI Agents
- Before adding features, reconcile failing test scaffold (`MyApp` vs `ProductsCatalogueApp`) to restore green baseline.
- When adding offline-first behavior, create explicit layers/files instead of expanding `lib/main.dart` further.
- Reference concrete files in PR descriptions (for example, `lib/main.dart`, `test/widget_test.dart`, `pubspec.yaml`) because behavior is centralized.
- Treat README claims as product intent; treat code as source of truth for current behavior.
