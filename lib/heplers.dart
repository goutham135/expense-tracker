final List<String> categories = ['Food', 'Travel', 'Bills', 'Shopping', 'Other'];

final List<String> categoriesFilter = ['Food', 'Travel', 'Bills', 'Shopping', 'Other', 'All'];


bool isValidEmail(String email) {
  // Define the regular expression for a valid email
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Return true if the email matches the regular expression, false otherwise
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  // Regular expression for password validation
  final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$',
  );

  // Return true if the password matches the regular expression, false otherwise
  return passwordRegex.hasMatch(password);
}