
## UI and Theme
- When creating new UI components, NEVER hardcode colors like `AppColors.panel`, `AppColors.navy`, or `Colors.white`. Always use `context.surfaceColor`, `context.textColor`, etc., provided by the `BuildContextThemeExt` extension in `lib/core/theme/app_theme.dart` to ensure compatibility with dark and light modes.
