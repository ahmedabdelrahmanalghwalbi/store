import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/repositories/users.repository.dart';

class RegistrationViewModel extends ChangeNotifier {
  final UsersRepository _usersRepo;
  final Locale _locale;

  RegistrationViewModel({
    required UsersRepository usersRepo,
    required Locale locale,
  }) : _usersRepo = usersRepo,
       _locale = locale;

  // Controllers for form fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Dispose controllers when no longer needed
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates passwords match
  String? validatePasswordMatch(String? value) {
    if (value != passwordController.text) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }

  /// Handles the registration process
  // Update the register method in RegistrationViewModel
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    try {
      await _usersRepo.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        locale: _locale,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to update loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
