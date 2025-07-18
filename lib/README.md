# Sociocube Mobile App

## Project Structure

```
lib/
├── config/                    # Configuration files
│   ├── router.dart            # Go Router configuration
│   └── theme.dart             # App theme configuration
├── providers/                 # Riverpod state management
│   ├── auth.dart              # Authentication state providers
│   └── graphql.dart           # GraphQL client provider
├── screens/                   # App screens
│   └── home.dart              # Home screen with token status
├── services/                  # Business logic services
│   └── graphql.dart           # GraphQL client and auth link
├── utils/                     # Utility functions
│   └── auth.dart              # Authentication helper functions
├── widgets/                   # Reusable widgets
│   └── app.dart               # Main app widget
├── README.md                  # Project documentation
└── main.dart                  # App entry point
```

## Features

### 🔐 Authentication System
- **Access Token**: Stored in memory (Riverpod state)
- **Refresh Token**: Stored securely using `flutter_secure_storage`
- **Automatic 401 Handling**: Clears access token on authentication failures
- **GraphQL Integration**: Automatic bearer token inclusion in requests

### 🏗️ Architecture
- **Riverpod**: State management
- **Go Router**: Navigation
- **GraphQL Flutter**: API communication
- **Flutter Hooks**: Functional components

### 📱 UI Components
- **Material 3**: Modern design system
- **Dark/Light Theme**: Theme configuration
- **Responsive Design**: Adaptive layouts

## Usage

### Authentication
```dart
// Login
await AuthUtils.login(ref, 
  accessToken: 'your_access_token',
  refreshToken: 'your_refresh_token'
);

// Logout
await AuthUtils.logout(ref);

// Check authentication
bool isAuth = AuthUtils.isAuthenticated(ref);
```

### GraphQL Queries
```dart
// Automatic authentication included
final result = await client.query(
  QueryOptions(document: gql('''
    query GetUser {
      user {
        id
        name
      }
    }
  '''))
);
```

## Development

1. **Install dependencies**: `flutter pub get`
2. **Run the app**: `flutter run`
3. **Test token management**: Use the test buttons on the home screen

## Configuration

Update the GraphQL endpoint in `lib/services/graphql.dart`:
```dart
final HttpLink httpLink = HttpLink(
  'https://your-graphql-endpoint.com/graphql', // Replace with your endpoint
);
``` 