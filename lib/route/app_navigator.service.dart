import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ui/core/shared_widgets/custom_action_button.widget.dart';
import '../ui/core/themes/app_theme.dart';

enum AnimationTypes { none, fade, slide }

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Future<dynamic> navigateTo(
    Widget Function() creator, {
    bool replace = false,
    bool replaceAll = false,
    AnimationTypes animationType = AnimationTypes.none,
  }) {
    final navigator = navigatorKey.currentState!;
    PageRoute route = _createRoute(creator, animationType);

    if (replaceAll) {
      return navigator.pushAndRemoveUntil(route, (route) => false);
    } else if (replace) {
      return navigator.pushReplacement(route);
    } else {
      return navigator.push(route);
    }
  }

  static void goBack({dynamic result}) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  static void goBackUntil({required String routeName}) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  static PageRoute _createRoute(
    Widget Function() creator,
    AnimationTypes type,
  ) {
    final context = navigatorKey.currentContext!;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoPageRoute(builder: (_) => creator());
    }

    switch (type) {
      case AnimationTypes.fade:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => creator(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case AnimationTypes.slide:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => creator(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      default:
        return MaterialPageRoute(builder: (_) => creator());
    }
  }

  static Future<bool> showConfirmMessage({
    required String title,
    String? message,
    String? imageSvgAsset,
    Widget? icon,
    String confirmText = "Confirm",
    String denyText = "Cancel",
    Color confirmButtonColor = Colors.blue,
    Color denyButtonColor = Colors.white,
    double width = 320.0,
    double borderRadius = 12.0,
    bool? showOnlyConfirmButton,
  }) async {
    var result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            insetPadding: EdgeInsets.zero,
            child: Container(
              constraints: BoxConstraints(maxWidth: width),
              padding: EdgeInsets.all(AppTheme.pagePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🖼️ Image or Icon
                  if (imageSvgAsset != null)
                    SvgPicture.asset(imageSvgAsset, width: 120, height: 80)
                  else if (icon != null)
                    SizedBox(width: 100, height: 80, child: icon),

                  const SizedBox(height: 16.0),

                  /// 📝 Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (message != null) ...[
                    const SizedBox(height: 12.0),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 20.0),

                  /// ✅❌ Ok & No Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomActionButtonWidget(
                        text: confirmText,
                        backgroundColor: confirmButtonColor,
                        isPrimary: false,
                        width: 135.0,
                        height: 40,
                        borderRadius: 5.0,
                        onPressed: () => Navigator.pop(dialogContext, true),
                        gredientColors: [Colors.red, confirmButtonColor],
                        isGredient: true,
                      ),
                      if (showOnlyConfirmButton != true) ...[
                        const SizedBox(width: 10.0),
                        CustomActionButtonWidget(
                          isPrimary: true,
                          text: denyText,
                          backgroundColor: denyButtonColor,
                          width: 135.0,
                          height: 40,
                          borderRadius: 5.0,
                          onPressed: () => Navigator.pop(dialogContext, false),
                          isGredient: true,
                          gredientColors: [denyButtonColor, denyButtonColor],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}
