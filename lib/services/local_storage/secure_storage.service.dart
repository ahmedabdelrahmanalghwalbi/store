import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../utils/app_logger.utils.dart';

class SecureStorageService {
  late final FlutterSecureStorage _secureStorage;
  final AndroidOptions androidOptions;
  final IOSOptions iosOptions;
  List<String>? listOfKeysNotRemoveWhileResetSecureStorageConfig;

  SecureStorageService({
    AndroidOptions? androidOpts,
    IOSOptions? iosOpts,
    required this.listOfKeysNotRemoveWhileResetSecureStorageConfig,
  }) : androidOptions =
           androidOpts ??
           const AndroidOptions(encryptedSharedPreferences: true),
       iosOptions =
           iosOpts ??
           const IOSOptions(accessibility: KeychainAccessibility.first_unlock) {
    _secureStorage = FlutterSecureStorage();
  }

  /// Save a string value securely
  Future<bool> setValueString({
    required String key,
    required String value,
  }) async {
    try {
      await _secureStorage.write(
        key: key,
        value: value,
        aOptions: androidOptions,
        iOptions: iosOptions,
      );
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 setValueString failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Secure Storage',
      );
      return false;
    }
  }

  /// Get a string value securely
  Future<String?> getValueString({required String key}) async {
    try {
      return await _secureStorage.read(
        key: key,
        aOptions: androidOptions,
        iOptions: iosOptions,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 getValueString failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Secure Storage',
      );
      return null;
    }
  }

  /// Save a boolean value securely
  Future<bool> setValueBool({required String key, required bool value}) async {
    return await setValueString(key: key, value: value.toString());
  }

  /// Get a boolean value securely
  Future<bool?> getValueBool({required String key}) async {
    final value = await getValueString(key: key);
    return value == 'true';
  }

  /// Save an integer value securely
  Future<bool> setValueInt({required String key, required int value}) async {
    return await setValueString(key: key, value: value.toString());
  }

  /// Get an integer value securely
  Future<int?> getValueInt({required String key}) async {
    final value = await getValueString(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  /// Save a Map'<'String, dynamic'>' securely
  Future<bool> setValueMap({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return await setValueString(key: key, value: json.encode(value));
  }

  /// Get a Map'<'String, dynamic'>' securely
  Future<Map<String, dynamic>?> getValueMap({required String key}) async {
    try {
      final jsonString = await getValueString(key: key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 getValueMap failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Secure Storage',
      );
      return {};
    }
  }

  /// Check if a key exists
  Future<bool> checkValueExist({required String key}) async {
    try {
      return await _secureStorage.containsKey(
        key: key,
        aOptions: androidOptions,
        iOptions: iosOptions,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 checkValueExist failed",
        error: e,
        stackTrace: stackTrace,

        tag: 'Secure Storage',
      );
      return false;
    }
  }

  /// Remove a specific key
  Future<bool> removeValue({required String key}) async {
    try {
      await _secureStorage.delete(
        key: key,
        aOptions: androidOptions,
        iOptions: iosOptions,
      );
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        "⚠️ Failed to remove key: $key. Clearing all storage.",
        error: e,
        stackTrace: stackTrace,
        tag: 'Secure Storage',
      );
      return false;
    }
  }

  /// Clear all stored values except specified keys
  Future<bool> resetConfig() async {
    try {
      final allKeys = await _secureStorage.readAll(
        aOptions: androidOptions,
        iOptions: iosOptions,
      );

      for (var key in allKeys.keys) {
        if (listOfKeysNotRemoveWhileResetSecureStorageConfig?.contains(key) ??
            false) {
          continue;
        }

        final removed = await removeValue(key: key);
        if (!removed) {
          AppLogger.warning(
            "⚠️ Failed to remove key: $key. Clearing all storage.",
            tag: 'Secure Storage',
          );
          await _secureStorage.deleteAll(
            aOptions: androidOptions,
            iOptions: iosOptions,
          );
          return true;
        }
      }

      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        "🧹 clearAll failed",
        tag: 'Secure Storage',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
