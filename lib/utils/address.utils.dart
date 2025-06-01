import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'app_logger.utils.dart';

abstract class AddressUtils {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Gets the address from coordinates using:
  /// 1. OSM
  /// 2. Native geocoding (geocoding package)
  static Future<String> getAddressFromCoordinates(
    double lat,
    double lng, {
    String languageCode = 'en',
  }) async {
    try {
      final osmAddress = await _getAddressFromOSM(lat, lng, languageCode);
      if (osmAddress != null) return osmAddress;

      return await _getAddressUsingNativeGeocoder(lat, lng);
    } catch (e, s) {
      AppLogger.error(
        'Unexpected error while getting address',
        error: e,
        stackTrace: s,
      );
      return 'Location unavailable';
    }
  }

  /// 1. Get address from OpenStreetMap (Nominatim)
  static Future<String?> _getAddressFromOSM(
    double lat,
    double lng,
    String languageCode,
  ) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {'format': 'json', 'lat': lat, 'lon': lng},
        options: Options(
          headers: {
            'Accept-Language': languageCode,
            'User-Agent': 'FlutterApp',
          },
        ),
      );

      if (response.statusCode == 200) {
        final address = response.data['display_name'] as String?;
        return (address != null && address.isNotEmpty) ? address : null;
      }
    } catch (e, s) {
      AppLogger.error('OSM reverse geocoding failed', error: e, stackTrace: s);
    }
    return null;
  }

  /// 2. Native geocoding fallback
  static Future<String> _getAddressUsingNativeGeocoder(
    double lat,
    double lng,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((part) => part != null && part.trim().isNotEmpty).join(', ');

        return address.isNotEmpty ? address : 'Location unavailable';
      }
    } catch (e, s) {
      AppLogger.error('Native geocoding failed', error: e, stackTrace: s);
    }
    return 'Location unavailable';
  }
}
