import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/app_local.config.dart';
import '../../../../route/app_navigator.service.dart';
import '../../../../utils/app_logger.utils.dart';
import '../../login/view/login.view.dart';
import '../../main/view/main.view.dart';

abstract class SplashViewModel {
  SplashViewModel();

  /// Initializes the app and navigates based on authentication state.
  static Future<void> performInitialization({
    required BuildContext context,
  }) async {
    try {
      if (!context.mounted) return;
      // Perform authentication check
      final bool isAuthenticated = await _checkAuthentication(context);

      // Navigate based on authentication status
      if (!context.mounted) return;
      _navigateToAppropriateView(context, isAuthenticated);
      return;
    } catch (err, st) {
      AppLogger.error(
        "🚀 Unexpected error during initialization",
        error: err,
        stackTrace: st,
      );
      AppNavigator.navigateTo(
        () => const LoginView(),
        replace: true,
        replaceAll: true,
      );
      return;
    }
  }

  static Future<bool> _checkAuthentication(BuildContext context) async {
    try {
      final AppLocalConfigurations appConfig =
          context.read<AppLocalConfigurations>();
      final bool? isLoggedIn = await appConfig.isLogin;
      final String? token = await appConfig.token;
      return (isLoggedIn == true) && (token?.isNotEmpty ?? false);
    } catch (authError, authStack) {
      AppLogger.error(
        "❗ Authentication check failed",
        error: authError,
        stackTrace: authStack,
      );

      return false;
    }
  }

  static void _navigateToAppropriateView(
    BuildContext context,
    bool isAuthenticated,
  ) {
    try {
      AppNavigator.navigateTo(
        () => isAuthenticated ? const MainView() : const LoginView(),
        replace: true,
        replaceAll: true,
      );
      return;
    } catch (navError, navStack) {
      AppLogger.error(
        "🧭 Navigation failed",
        error: navError,
        stackTrace: navStack,
      );
      if (context.mounted) {
        AppNavigator.navigateTo(
          () => const LoginView(),
          replace: true,
          replaceAll: true,
        );
      }
      return;
    }
  }
}
