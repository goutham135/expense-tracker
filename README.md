# Flutter Expense Tracker App

## 📌 Overview
The **Flutter Expense Tracker** is a powerful and intuitive mobile application that allows users to manage their daily expenses efficiently. With Firebase integration, state management using Riverpod, and real-time currency conversion, this app ensures a seamless expense tracking experience.

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

## 🏗️ Setup & Installation
1. **Clone the repository**:
   ```sh
   git clone https://github.com/yourusername/flutter-expense-tracker.git
   cd flutter-expense-tracker
   ```

2. **Install dependencies**:
   ```sh
   flutter pub get
   ```

3. **Set up Firebase**:
   - Create a Firebase project.
   - Enable Firestore & Authentication.
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective folders.

4. **Run the app**:
   ```sh
   flutter run
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

## 📜 License
This project is licensed under the MIT License.

---
### 📧 Contact & Contributions
- Feel free to contribute by submitting a pull request.
- Found an issue? Report it [here](https://github.com/yourusername/flutter-expense-tracker/issues).
- Contact me at **your.email@example.com**.

Happy Coding! 🚀

