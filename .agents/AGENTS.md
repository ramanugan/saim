## UI and Theme
- When creating new UI components, NEVER hardcode colors like `AppColors.panel`, `AppColors.navy`, or `Colors.white`. Always use `context.surfaceColor`, `context.textColor`, etc., provided by the `BuildContextThemeExt` extension in `lib/core/theme/app_theme.dart` to ensure compatibility with dark and light modes.

## State Management & Helpers
- **Reactive Dropdown/Helper Providers:** All helper providers used for dropdowns or selectors (`helperXxxxProvider`) MUST be `Provider<AsyncValue<List<Map<String, dynamic>>>>` watching the primary `StateNotifierProvider` (e.g. `ref.watch(catologProvider)`) rather than running isolated `FutureProvider` database queries. This guarantees real-time UI synchronization across all modules without stale cache.
