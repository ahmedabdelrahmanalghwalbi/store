import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'route/app_navigator.service.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/features/splash/view/splash.view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: ThemeMode.light,
      title: 'store',
      theme: AppTheme.getTheme(isDark: false, context: context),
      home: SplashView(),
    );
  }
}
