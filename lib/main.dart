import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app.provider.dart';
import 'services/backend/api_services/client_service.helper.dart';
import 'utils/app_logger.utils.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();
void _handleUnauthorizedResponse(dynamic response) {
  // Clear user session and navigate to login screen
  AppLogger.warning(
    "Unauthorized: ${response.toString()}",
    tag: "📍 Permissions",
  );
  // Perform logout actions like clearing tokens, navigating to login, etc.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Locks to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // handle unauthorized callback
  ApiClientHelper.unauthrizedCallback = _handleUnauthorizedResponse;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/json/lang',
      fallbackLocale: const Locale('en'),
      // Enable saving the selected locale in local storage
      saveLocale: true,
      child: MultiProvider(
        // inject all providers to make it accessable intire all application via context.
        providers: appProviders,
        child: const MyApp(),
      ),
    ),
  );
}
