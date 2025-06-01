import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../route/app_navigator.service.dart';
import '../../features/splash/view/splash.view.dart';
import '../themes/app_theme.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      child: ElevatedButton(
        onPressed: () async {
          if (context.locale.languageCode == 'en') {
            context.setLocale(Locale('ar'));
          } else {
            context.setLocale(Locale('en'));
          }
          AppNavigator.navigateTo(
            () => SplashView(),
            replace: true,
            replaceAll: true,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor.withAlpha(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          elevation: 0,
        ),
        child: Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: AppTheme.primaryColor, size: 16.0),
            Text(
              context.locale.languageCode == 'en' ? 'Arabic' : 'English',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
