# Auth Module

Clean and pragmatic structure for mid-sized Flutter apps.

## Structure

```
auth/
├── models/              # Data models & entities
│   ├── user.dart        # User entity
│   └── auth_response.dart  # API response model
│
├── services/            # Business logic & data sources
│   ├── auth_api.dart    # HTTP API calls
│   └── auth_storage.dart   # Local secure storage
│
├── providers/           # State management
│   └── auth_provider.dart  # Riverpod providers & state
│
└── screens/            # UI screens
    ├── login.dart
    ├── signup.dart
    └── wrapper.dart    # Shared auth UI wrapper
```

## Benefits

- ✅ **Simple:** Easy to understand and navigate
- ✅ **Organized:** Clear separation between models, services, state, and UI
- ✅ **Testable:** Services can be mocked for testing
- ✅ **Scalable:** Easy to add new features without restructuring
- ✅ **Pragmatic:** Not over-engineered for mid-sized apps

## Usage

```dart
// In screens
final authState = ref.watch(authStateProvider);

// Login
await ref.read(authStateProvider.notifier).login(
  email: email,
  password: password,
);

// Signup
await ref.read(authStateProvider.notifier).signup(
  email: email,
  password: password,
);

// Logout
await ref.read(authStateProvider.notifier).logout();
```

## Data Flow

```
User Action (Screen)
    ↓
Provider (authStateProvider)
    ↓
Services (auth_api, auth_storage)
    ↓
API / Local Storage
```

