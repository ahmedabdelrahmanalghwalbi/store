import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_logger.utils.dart';

class SharedPreferenceService {
  SharedPreferences? _prefs;

  SharedPreferenceService({
    required this.listOfKeysNotRemoveWhileResetSharedPreferencesConfig,
  });

  /// any keys here will not be cleared when user signout [examples :- remember user credentials feature.]
  List<String>? listOfKeysNotRemoveWhileResetSharedPreferencesConfig;

  /// initlize the config service [you must call before calling any other function]
  Future<void> _init() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
        AppLogger.info(
          "Config Service initialized successfully ✔️",
          tag: 'Shared Preferences Service',
        );
      }
      return;
    } catch (err, t) {
      AppLogger.error(
        "❌ Failed to initialize Config Service",
        error: err,
        stackTrace: t,
        tag: 'Shared Preferences Service',
      );
    }
    return;
  }

  /// Check if data exists
  Future<bool?> checkValueExist({required String key}) async {
    await _init();
    if (_prefs == null) {
      AppLogger.error(
        "⚠️ SharedPreferences instance is null",
        tag: 'Shared Preferences Service',
      );
      return null;
    }
    return _prefs?.containsKey(key);
  }

  /// Clear all stored values except specified keys
  Future<bool> resetConfig() async {
    await _init();
    if (_prefs == null) {
      AppLogger.error(
        "⚠️ SharedPreferences instance is null",
        tag: 'Shared Preferences Service',
      );
      return false;
    }
    try {
      final keys = _prefs!.getKeys();

      for (var key in keys) {
        if (listOfKeysNotRemoveWhileResetSharedPreferencesConfig?.contains(
              key,
            ) ??
            false) {
          continue;
        }

        final removed = await _prefs!.remove(key);
        if (!removed) {
          AppLogger.error(
            "💾 resetConfig exception :Failed to remove key: $key. Clearing all preferences.",
            tag: 'Shared Preferences Service',
          );
          await _prefs!.clear();
          return true;
        }
      }

      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 resetConfig exception",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return false;
    }
  }

  /// Save data locally as String
  Future<bool> setValueString({
    required String key,
    required String? value,
  }) async {
    try {
      await _init();
      if (_prefs == null) {
        AppLogger.error(
          "⚠️ SharedPreferences instance is null",
          tag: 'Shared Preferences Service',
        );
        return false;
      }
      if (value == null) {
        return await _prefs!.remove(key);
      }
      return await _prefs!.setString(key, value);
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 setValueString failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return false;
    }
  }

  /// Get data locally as String
  Future<String?> getValueString({required String key}) async {
    await _init();
    if (_prefs == null) {
      AppLogger.error(
        "⚠️ SharedPreferences instance is null",
        tag: 'Shared Preferences Service',
      );
      return null;
    }
    return _prefs?.getString(key);
  }

  /// Save data locally as Bool
  Future<bool> setValueBool({required String key, required bool value}) async {
    try {
      await _init();
      if (_prefs == null) {
        AppLogger.error(
          "⚠️ SharedPreferences instance is null",
          tag: 'Shared Preferences Service',
        );
        return false;
      }
      return await _prefs!.setBool(key, value);
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 setValueBool failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return false;
    }
  }

  /// Get data locally as Bool
  Future<bool?> getValueBool({required String key}) async {
    await _init();
    if (_prefs == null) {
      AppLogger.error(
        "⚠️ SharedPreferences instance is null",
        tag: 'Shared Preferences Service',
      );
      return null;
    }
    return _prefs?.getBool(key);
  }

  /// Save data locally as Int
  Future<bool> setValueInt({required String key, required int value}) async {
    try {
      await _init();
      if (_prefs == null) {
        AppLogger.error(
          "⚠️ SharedPreferences instance is null",
          tag: 'Shared Preferences Service',
        );
        return false;
      }
      return await _prefs!.setInt(key, value);
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 setValueInt failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return false;
    }
  }

  /// Get data locally as Int
  Future<int?> getValueInt({required String key}) async {
    await _init();
    if (_prefs == null) {
      AppLogger.error(
        "⚠️ SharedPreferences instance is null",
        tag: 'Shared Preferences Service',
      );
      return null;
    }
    return _prefs?.getInt(key);
  }

  /// Save data locally as Map
  Future<bool> setValueMap({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _init();
      if (_prefs == null) {
        AppLogger.error(
          "⚠️ SharedPreferences instance is null",
          tag: 'Shared Preferences Service',
        );
        return false;
      }
      return await _prefs!.setString(key, json.encode(value));
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 setValueMap failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return false;
    }
  }

  /// Get data locally as Map
  Future<Map<String, dynamic>?> getValueMap({required String key}) async {
    try {
      await _init();
      if (_prefs == null) {
        AppLogger.error(
          "⚠️ SharedPreferences instance is null",
          tag: 'Shared Preferences Service',
        );
        return null;
      }
      final prefData = _prefs?.getString(key);
      if (prefData == null) return null;
      return json.decode(prefData) as Map<String, dynamic>?;
    } catch (e, stackTrace) {
      AppLogger.error(
        "💾 getValueMap failed",
        error: e,
        stackTrace: stackTrace,
        tag: 'Shared Preferences Service',
      );
      return {};
    }
  }
}
