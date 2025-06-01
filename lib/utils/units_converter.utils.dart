import 'package:easy_localization/easy_localization.dart';
import 'constants_utils/app_strings.constants.dart';

abstract class UnitsConverterUtils {
  // 🔹 Conversion: Knots (kn) → Kilometers per hour (km/h)
  static String convertSpeed(double? speedKn) {
    if (speedKn == null) return '--';
    try {
      final speedKph = speedKn * 1.852; // 1 kn = 1.852 km/h
      return '${speedKph.toStringAsFixed(1)} ${AppStrings.kmPerHour.tr()}'; // Use localization for km/h
    } catch (e) {
      return '--';
    }
  }

  // 🔹 Conversion: Meters → Kilometers
  static String convertDistance(double? distanceMeters) {
    if (distanceMeters == null) return '--';
    try {
      final distanceKm = distanceMeters / 1000.0;
      return '${distanceKm.toStringAsFixed(1)} ${AppStrings.km.tr()}'; // Use localization for km
    } catch (e) {
      return '--';
    }
  }

  // 🔹 Conversion: Milliseconds → H:M:S
  static String convertTime(int? milliseconds) {
    if (milliseconds == null) return '--';
    try {
      final totalSeconds = (milliseconds / 1000).round();
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      final seconds = totalSeconds % 60;

      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--';
    }
  }

  // 🔹 Generic Fallback Handler
  static String formatValue<T>(
    T? value,
    String unitKey, {
    int fractionDigits = 1,
  }) {
    if (value == null) return '--';
    try {
      if (value is double) {
        return '${value.toStringAsFixed(fractionDigits)} ${unitKey.tr()}';
      }
      return '$value ${unitKey.tr()}';
    } catch (e) {
      return '--';
    }
  }
}
