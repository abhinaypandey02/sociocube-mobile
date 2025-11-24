# SocioCube Mobile - Project Structure

Clean and organized structure for a mid-sized Flutter app.

## Directory Structure

```
lib/
├── auth/                    # 🔐 Authentication feature module
│   ├── models/             # User & auth response models
│   ├── services/           # API & storage services
│   ├── providers/          # Riverpod state management
│   └── screens/            # Login, signup, wrapper
│
├── widgets/                 # 🎨 Reusable UI components
│   ├── button.dart         # Custom button with variants
│   ├── input.dart          # Styled text input
│   └── text.dart           # Text style helpers
│
├── theme/                   # 🎨 App theming
│   └── app_theme.dart      # Colors, gradients, theme config
│
├── screens/                 # 📱 Top-level app screens
│   ├── home.dart           # Main home screen
│   └── splash_screen.dart  # App launch screen
│
├── router/                  # 🗺️ Navigation
│   └── app_router.dart     # GoRouter configuration
│
├── utils/                   # 🛠️ Utilities
│   └── env.dart            # Environment variables helper
│
└── main.dart               # 🚀 App entry point
```

## Architecture Principles

### 1. Feature-Based Organization
- Each major feature (like `auth/`) is self-contained
- Easy to find and modify feature-specific code
- Can be extracted into a package if needed

### 2. Separation of Concerns
- **models/** - Data structures
- **services/** - Business logic & external data
- **providers/** - State management
- **screens/** - UI components

### 3. Shared Resources
- **widgets/** - Reusable across features
- **theme/** - Consistent styling
- **utils/** - Shared utilities
- **router/** - App-wide navigation

## Naming Conventions

### Files
- Snake_case: `auth_provider.dart`, `splash_screen.dart`
- Descriptive names that match class names

### Classes
- PascalCase: `AuthProvider`, `SplashScreen`
- Screen suffix for screens: `HomeScreen`, `LoginScreen`
- Provider suffix for providers: `authStateProvider`

### Folders
- Lowercase, plural when containing multiple items
- `models/`, `services/`, `screens/`, `providers/`

## Adding New Features

When adding a new feature (e.g., "posts"):

```
lib/
└── posts/
    ├── models/
    │   └── post.dart
    ├── services/
    │   ├── posts_api.dart
    │   └── posts_storage.dart (if needed)
    ├── providers/
    │   └── posts_provider.dart
    └── screens/
        ├── posts_list_screen.dart
        └── post_detail_screen.dart
```

## Best Practices

1. ✅ Keep features self-contained
2. ✅ Use barrel files (exports) sparingly - explicit imports are clearer
3. ✅ One widget/class per file (with same name)
4. ✅ Co-locate tests with source files (when using test folders)
5. ✅ Use relative imports within a feature, absolute for cross-feature

## Import Guidelines

```dart
// Within same feature - relative
import '../models/user.dart';
import '../services/auth_api.dart';

// Cross-feature or shared - absolute (from lib/)
import 'package:sociocube_mobile/widgets/button.dart';
import 'package:sociocube_mobile/theme/app_theme.dart';

// Third-party packages
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
```

## Why This Structure?

- ✅ **Scalable:** Easy to add new features without restructuring
- ✅ **Maintainable:** Clear where code lives
- ✅ **Testable:** Features can be tested independently
- ✅ **Team-Friendly:** Multiple developers can work on different features
- ✅ **Pragmatic:** Not over-engineered, suitable for mid-sized apps

