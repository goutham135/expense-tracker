# Flutter Expense Tracker App

## 📌 Overview
The **Flutter Expense Tracker** is a powerful and intuitive mobile application that allows users to manage their daily expenses efficiently. With Firebase integration, state management using Riverpod, and real-time currency conversion, this app ensures a seamless expense tracking experience.


## 🚀 Getting Started
This repository contains a Flutter project. Follow the steps below to set up and run the project on your local machine.

---

## 📌 Prerequisites
Ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) version 3.22.2
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- Xcode (for iOS development)
- A connected device or emulator

To verify your setup, run:
```sh
flutter doctor
```

---

## 🛠 Installation

1. **Clone the Repository**
```sh
git clone https://github.com/goutham135/expense-tracker.git
cd expense-tracker
```

2. **Install Dependencies**
```sh
flutter pub get
```

3. **Run the Project**
- For Android:
  ```sh
  flutter run
  ```
- For iOS (Mac required):
  ```sh
  cd ios && pod install && cd ..
  flutter run
  ```

---

## 📂 Project Structure
```
lib/
│-- main.dart        # Entry point of the app
│-- screens/         # UI screens
│-- widgets/         # Reusable widgets
│-- models/          # Data models
│-- providers/       # State management (e.g., Riverpod, Bloc)
│-- services/        # API & backend communication
```



## 🚀 Features
- **Expense Management**: Add, edit, and delete expenses with required fields.
- **Firebase Firestore Integration**: Stores user-specific expenses securely.
- **Filtering & Sorting**: Filter expenses by category and date range.
- **Expense Summary Report**:
  - Monthly total expenses
  - Category-wise spending breakdown
  - Charts for data visualization using `fl_chart`
- **Currency Conversion**: Fetches live exchange rates (INR to USD, EUR, GBP) using a REST API.
- **Light & Dark Mode**: Toggle between themes using Riverpod.
- **Authentication**: Secure login using Firebase Authentication.
- **Push Notifications**: Receive reminders and alerts using Firebase Cloud Messaging (FCM).

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **Firebase** (Firestore, Authentication, Cloud Messaging)
- **State Management**: Riverpod
- **REST API Integration**: Exchange Rate API
- **Data Visualization**: fl_chart


   ```

## 📊 API Integration (Exchange Rates)
This app fetches real-time currency conversion rates from an external REST API.

- **API Used**: [ExchangeRate API](https://www.exchangerate-api.com/)
- **Example Endpoint**:
  ```sh
  https://v6.exchangerate-api.com/v6/YOUR_API_KEY/latest/INR
  ```
- **Implementation**:
  - Fetch rates and display converted expenses.
  - Supports USD, EUR, and GBP.
 
## 🏗 Why Riverpod for State Management?
We chose **Riverpod** as the state management solution for this project because:

1. **Scalability & Maintainability** – The expense tracker involves multiple interacting features (e.g., filtering, sorting, authentication), and Riverpod’s unidirectional data flow makes it easier to manage and scale.
2. **AutoDispose for Memory Optimization** – Riverpod automatically removes unused providers from memory, improving performance.
3. **Better State Isolation** – Unlike `setState` or `Provider`, Riverpod rebuilds only the necessary UI components, improving efficiency.
4. **Asynchronous Support** – Riverpod makes handling Firebase queries and API calls easier with `FutureProvider` and `StreamProvider`.
5. **Testability** – Riverpod allows mocking and dependency injection, making unit testing simpler.


## 📜 License
This project is licensed under the MIT License.

---
### 📧 Contact & Contributions
- Feel free to contribute by submitting a pull request.
- Found an issue? Report it [here](https://github.com/yourusername/flutter-expense-tracker/issues).
- Contact me at **your.email@example.com**.

Happy Coding! 🚀

