import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';
import '../route/app_navigator.service.dart';

enum ToastType { success, error, warning, info }

abstract class ToastUtils {
  static const int _defaultDurationValueInMilliseconds = 3000;
  static final BuildContext _context =
      AppNavigator.navigatorKey.currentContext!;
  static void _show({
    required String message,
    ToastType type = ToastType.info,
    int duration = _defaultDurationValueInMilliseconds,
    VoidCallback? onTap,
  }) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      animationDuration: Duration(milliseconds: 700),
      snackbarDuration: Duration(milliseconds: duration),
      builder:
          (context) => ToastCard(
            title: Text(
              message,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
            leading: _getIcon(type),
            color: _getBackgroundColor(type),
            onTap: onTap,
          ),
    ).show(_context);
  }

  static void showNotification({
    required String title,
    required String message,
    VoidCallback? onClick,
  }) {
    _show(message: "$title\n$message", type: ToastType.info, onTap: onClick);
  }

  static void showSuccess(
    String message, {
    int duration = _defaultDurationValueInMilliseconds,
  }) {
    _show(message: message, type: ToastType.success, duration: duration);
  }

  static void showError(
    String message, {
    int duration = _defaultDurationValueInMilliseconds,
  }) {
    _show(message: message, type: ToastType.error, duration: duration);
  }

  static void showWarning(
    String message, {
    int duration = _defaultDurationValueInMilliseconds,
  }) {
    _show(message: message, type: ToastType.warning, duration: duration);
  }

  static void showInfo(
    String message, {
    int duration = _defaultDurationValueInMilliseconds,
  }) {
    _show(message: message, type: ToastType.info, duration: duration);
  }

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green.withAlpha(200);
      case ToastType.error:
        return Colors.red.withAlpha(200);
      case ToastType.warning:
        return Colors.orange.withAlpha(200);
      case ToastType.info:
        return Colors.blue.withAlpha(200);
    }
  }

  static Icon _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Icon(Icons.check_circle, color: Colors.white, size: 25.0);
      case ToastType.error:
        return const Icon(Icons.error, color: Colors.white, size: 25.0);
      case ToastType.warning:
        return const Icon(Icons.warning, color: Colors.white, size: 25.0);
      case ToastType.info:
        return const Icon(Icons.info, color: Colors.white, size: 25.0);
    }
  }
}
