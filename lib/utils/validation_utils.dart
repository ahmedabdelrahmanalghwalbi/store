import 'package:easy_localization/easy_localization.dart';
import 'constants_utils/app_strings.constants.dart';

abstract class ValidationUtils {
  /// validate username
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validUsername.tr();
    }
    // else if (value.length < 3) {
    //   return AppStrings.usernameMinLength.tr();
    // } else if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value)) {
    //   return AppStrings.usernameAllowedChars.tr();
    // }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterEmail.tr();
    }
    // Regex pattern for email validation
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return AppStrings.validEmail.tr();
    }
    return null;
  }

  /// Validate phone number format
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterPhone.tr();
    }
    // Regex pattern for phone number validation
    String pattern = r'^[0-9]{10}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return AppStrings.validPhone.tr();
    }
    return null;
  }

  /// Validate password format
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterPassword.tr();
    }
    // Example: Password should be at least 8 characters with one uppercase letter, one lowercase letter, one number, and one special character
    // String pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = RegExp(pattern);
    // if (!regex.hasMatch(value)) {
    //   return AppStrings.passwordRequirements.tr();
    // }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField.tr();
    }
    return null;
  }

  /// Validate numeric input
  static String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional validation if empty value is allowed
    }
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return AppStrings.onlyNumbers.tr();
    }
    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional validation if empty value is allowed
    }
    String pattern =
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$';
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (!regex.hasMatch(value)) {
      return AppStrings.validUrl.tr();
    }
    return null;
  }

  /// Validate date format
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional validation if empty value is allowed
    }
    // Customize date format pattern as per your requirement
    String pattern = r'^\d{4}-\d{2}-\d{2}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return AppStrings.validDate.tr();
    }
    // Additional validation logic can be added to check if the date is valid
    return null;
  }
}
