import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class InfoUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static Future<String?> getDeviceIdForAndroid10Plus() async {
    AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
    return androidInfo.id;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber}";
  }
}
