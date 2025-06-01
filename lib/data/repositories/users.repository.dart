import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../config/app_local.config.dart';
import '../../route/app_navigator.service.dart';
import '../../ui/features/login/view/login.view.dart';
import '../../ui/features/main/view/main.view.dart';
import '../../ui/features/splash/view/splash.view.dart';
import '../../utils/app_logger.utils.dart';
import '../../utils/constants_utils/app_strings.constants.dart';
import '../../utils/static_cache.utils.dart';
import '../../utils/toast.utils.dart';
import '../services/users.service.dart';

/// Handles business logic for user authentication and registration
class UsersRepository {
  final UsersService _userService;
  final AppLocalConfigurations _appConfig;

  UsersRepository({
    required UsersService usersService,
    required AppLocalConfigurations appConfig,
  }) : _userService = usersService,
       _appConfig = appConfig;

  /// Authenticates a user and handles session management
  Future<void> login({
    required String email,
    required String password,
    required Locale locale,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        ToastUtils.showWarning(AppStrings.emptyCredentials.tr());
        return;
      }

      // API call to authenticate
      final loginResult = await _userService.login(
        username: email,
        password: password,
      );

      // Handle failed authentication
      if (!loginResult.success || loginResult.data?['token'] == null) {
        AppLogger.error(
          "Authentication failed: ${loginResult.message}",
          tag: "🔐 Auth",
        );
        ToastUtils.showError(
          loginResult.message ?? AppStrings.errorWhileLoggingIn.tr(),
        );
        return;
      }

      // Save session and navigate
      await _saveSessionAndNavigate(loginResult.data!['token']!);
    } catch (e, stackTrace) {
      _handleAuthError(e, stackTrace, AppStrings.errorWhileLoggingIn.tr());
    }
  }

  /// Registers a new user account
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required Locale locale,
  }) async {
    try {
      // Validate input
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        ToastUtils.showWarning(AppStrings.emptyCredentials.tr());
        return;
      }

      // API call to register
      final registerResult = await _userService.register(
        username: username,
        email: email,
        password: password,
      );

      // Handle failed registration
      if (!registerResult.success) {
        AppLogger.error(
          "Registration failed: ${registerResult.message}",
          tag: "📝 Registration",
        );
        ToastUtils.showError(
          registerResult.message ?? AppStrings.registrationError.tr(),
        );
        return;
      }
      ToastUtils.showSuccess(AppStrings.registrationSuccess.tr());
      // Navigate back to login after short delay
      await Future.delayed(const Duration(milliseconds: 1000));
      AppNavigator.navigateTo(() => const LoginView());
    } catch (e, stackTrace) {
      _handleAuthError(e, stackTrace, AppStrings.registrationError.tr());
    }
  }

  /// Clears user session and logs out
  Future<void> logout() async {
    try {
      AppLogger.debug("Initiating logout...", tag: "🚪 Session");

      // Clear cached data
      StaticCacheManagerUtils.clearCache();
      await _appConfig.clearAllConfigs();

      // Navigate to splash screen
      AppNavigator.navigateTo(
        () => const SplashView(),
        replace: true,
        replaceAll: true,
      );
      AppLogger.info("User logged out successfully", tag: "🚪 Session");
    } catch (e, stackTrace) {
      AppLogger.error(
        "Logout failed: $e",
        stackTrace: stackTrace,
        tag: "🚪 Session",
      );
      ToastUtils.showError(AppStrings.errorWhileLoggingOut.tr());
    }
  }

  // Helper method to save session and navigate
  Future<void> _saveSessionAndNavigate(String token) async {
    await Future.wait([
      _appConfig.setToken(token: token),
      _appConfig.setIsLogin(true, notify: true),
    ]);
    AppNavigator.navigateTo(() => MainView(), replace: true, replaceAll: true);
  }

  // Helper method for error handling
  void _handleAuthError(dynamic e, StackTrace stackTrace, String errorMessage) {
    AppLogger.error(
      "Authentication error: $e",
      stackTrace: stackTrace,
      tag: "🔐 Auth",
    );
    ToastUtils.showError(errorMessage);
  }
}
