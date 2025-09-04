// lib/validation_helper.dart
//helper function to validate fields

class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    // Check if the password is empty
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Check for minimum length
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // If all conditions are satisfied, return null (no error)
    return null;
  }


  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number';
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must be exactly 10 digits';
    }
    return null;
  }

}
