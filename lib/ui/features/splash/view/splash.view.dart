import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/info.utils.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/splash.viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String _appVersion = "";
  static const TextStyle _appVersionTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );
  static const double _splashIconSize = 125.0;

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _fetchAppVersion() async {
    String version = await InfoUtils.getAppVersion();
    setState(() {
      _appVersion = "V.$version";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: FutureBuilder(
        future: SplashViewModel.performInitialization(context: context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 24.0,

                    children: [FlutterLogo(size: _splashIconSize)],
                  ),
                ),
                // App Version & Build number
                Text(_appVersion, style: _appVersionTextStyle),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
