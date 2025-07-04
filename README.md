# Sociocube Mobile

A Flutter app with GraphQL integration and Instagram-like bottom navigation.

## Features

- GraphQL client setup for backend communication
- Instagram-style bottom navigation with 3 tabs
- Placeholder screens for Home, Search, and Profile
- Material Design 3 theme

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Update the GraphQL endpoint in `lib/services/graphql_service.dart`:
```dart
static const String _endpoint = 'https://your-actual-graphql-endpoint.com/graphql';
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with GraphQL setup
├── screens/
│   ├── main_screen.dart     # Main screen with bottom navigation
│   ├── home_screen.dart     # Home screen placeholder
│   ├── search_screen.dart   # Search screen placeholder
│   └── profile_screen.dart  # Profile screen placeholder
└── services/
    └── graphql_service.dart # GraphQL client and queries
```

## Dependencies

- `graphql_flutter`: GraphQL client for Flutter
- `provider`: State management (ready for future use)
- `cupertino_icons`: iOS-style icons

## Next Steps

1. Implement actual GraphQL queries and mutations
2. Add state management with Provider
3. Create data models for posts, users, etc.
4. Implement authentication
5. Add image handling and caching
6. Implement actual screen functionality 