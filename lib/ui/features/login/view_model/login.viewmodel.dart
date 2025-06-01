import 'package:flutter/material.dart';
import '../../../../data/repositories/users.repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required UsersRepository usersRepo, required Locale locale})
    : _userRepo = usersRepo,
      _locale = locale;
  final UsersRepository _userRepo;
  final Locale _locale;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    formKey.currentState?.reset();
    super.dispose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    await _userRepo.login(
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
      locale: _locale,
    );
  }
}
