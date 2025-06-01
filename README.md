
# Product Catalog App

## Overview

The app follows the **MVVM (Model-View-ViewModel)** architecture, ensuring clean code structure, modularity, and scalability. The project structure is **feature-based** in the UI layer and **layer-based** in the data layer, offering clear separation of concerns and maintainability.  

---

## Architecture & Design

- **Architecture Pattern:** Chose MVVM (Model-View-ViewModel) for its simplicity, fast implementation, and ease of maintenance, making it a practical and efficient architectural choice for this project.
- **State Management:** Implemented using `provider` for dependency injection and state management.  
- **Dependency Injection:** The app is built upon dependency injection principles to ensure testability and maintainability.  
- **Localization:** Handled with `easy_localization`, supporting multiple languages with JSON-based translations.  
- **Secure Storage:** Utilizes `flutter_secure_storage` and `shared_preferences` to securely manage sensitive data.  
- **Networking:** Combines `http` and `dio` for efficient and robust API communication.  

---

## Project Structure
```plaintext
lib/
│── ui/                     # UI Layer (Feature-Based Structure)
│   ├── core/               # Core UI Components
│   ├── features/           # Feature-Based Modules (login, catalog, etc.)
│   │   ├── login/
│   │   │   ├── view/       # UI Screens
│   │   │   ├── view_model/ # Business Logic (ViewModel)
│── data/                   # Data Layer (Layer-Based Structure)
│   ├── models/             # Data Models
│   ├── repositories/       # API & Data Handling
│── utils/                  # Utility Classes & Constants
│── providers/              # App-wide providers
│── main.dart               # Entry Point
```

---

## Naming Conventions

The project follows a **consistent naming convention** where:

* **File names** reflect their parent folder to ensure clarity and consistency.

  * For example:

    * `example.widget.dart` ➡️ located inside `widgets/`
    * `example.utils.dart` ➡️ located inside `utils/`
      This approach ensures easy identification of file roles within the project.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_native_splash: ^2.4.5
  provider: ^6.1.2
  shared_preferences: ^2.5.2
  flutter_secure_storage: ^9.2.4
  http: ^1.3.0
  dio: ^5.8.0+1
  file_picker: ^9.0.2
  easy_localization: ^3.0.7+1
  auto_size_text: ^3.0.0
  flutter_svg: ^2.0.17
  delightful_toast: ^1.1.0
  equatable: ^2.0.7
  shimmer: ^3.0.0
  gradient_borders: ^1.0.1
  device_info_plus: ^11.3.3
  internet_connection_checker_plus: ^2.7.1
  package_info_plus: ^8.3.0
  intl: ^0.19.0
  geocoding: ^3.0.0
  cached_network_image: ^3.4.1
```

---

## Setup & Installation

1️⃣ **Clone the repository**

```bash
git clone https://github.com/ahmedabdelrahmanalghwalbi/store.git
cd store
```

2️⃣ **Install dependencies**

```bash
flutter pub get
```

3️⃣ **Run the project**

```bash
flutter run
```

---

## Localization

Localization is managed using `easy_localization` with JSON translation files:

```
assets/json/lang/en.json
assets/json/lang/ar.json
```

To dynamically change the language:

```dart
context.setLocale(Locale('ar'));
```

---

## Authentication Test Accounts

Use these credentials for testing the authentication functionality:

| Email                                           | Username  | Password      |
| ----------------------------------------------- | --------- | ------------- |
| [john@gmail.com](mailto:john@gmail.com)         | johnd     | m38rmF\$      |
| [william@gmail.com](mailto:william@gmail.com)   | hopkins   | William56\$hj |
| [morrison@gmail.com](mailto:morrison@gmail.com) | mor\_2314 | 83r5^\_       |
| [kevin@gmail.com](mailto:kevin@gmail.com)       | kevinryan | kev02937@     |
| [don@gmail.com](mailto:don@gmail.com)           | donero    | ewedon        |
| [derek@gmail.com](mailto:derek@gmail.com)       | derek     | jklg\*\_56    |
| [david\_r@gmail.com](mailto:david_r@gmail.com)  | david\_r  | 3478\*#54     |
| [miriam@gmail.com](mailto:miriam@gmail.com)     | snyder    | f238&@\*\$    |
| [kate@gmail.com](mailto:kate@gmail.com)         | kate\_h   | kfejk@\*\_    |
| [jimmie@gmail.com](mailto:jimmie@gmail.com)     | jimmie\_k | klein\*#%\*   |

🔐 **Note:** Passwords are case-sensitive and contain special characters as shown.