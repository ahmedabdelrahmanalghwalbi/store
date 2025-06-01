import '../data/models/user.model.dart';
import '../services/local_storage/secure_storage.service.dart';
import '../services/local_storage/shared_preference.service.dart';
import '../utils/app_logger.utils.dart';
import '../utils/constants_utils/app_local_storage.constants.dart';

class AppLocalConfigurations {
  final SharedPreferenceService? _sharedPreferenceUtils;
  final SecureStorageService? _secureStorageUtils;
  AppLocalConfigurations({
    required SharedPreferenceService sharedPreferenceUtils,
    required SecureStorageService secureStorageUtils,
  }) : _sharedPreferenceUtils = sharedPreferenceUtils,
       _secureStorageUtils = secureStorageUtils;

  /// Set user data as Map
  Future<bool?> setUserModel(Map<String, dynamic>? userData) async {
    try {
      return await _sharedPreferenceUtils?.setValueMap(
        key: AppLocalStorageConstants.userModelStorageKey,
        value: userData ?? {},
      );
    } catch (e, t) {
      AppLogger.error(
        'Error saving user model',
        error: e,
        stackTrace: t,
        tag: "🔐 App Config Service [setUserModel]",
      );
      return false;
    }
  }

  /// Get complete user model
  Future<UserModel?> get userModel async {
    try {
      final map = await _sharedPreferenceUtils?.getValueMap(
        key: AppLocalStorageConstants.userModelStorageKey,
      );
      return map != null ? UserModel.fromJson(map) : null;
    } catch (e, t) {
      AppLogger.error(
        'Error getting user model',
        error: e,
        stackTrace: t,
        tag: "🔐 App Config Service [get userModel]",
      );
      return null;
    }
  }

  /// Set User Credentials Safely For
  Future<bool> setCredentials({
    required String email,
    required String password,
    bool? notify = false,
  }) async {
    try {
      if (_secureStorageUtils == null) return false;

      // Store email and password securely
      await Future.wait<bool>([
        _secureStorageUtils.setValueString(
          key: AppLocalStorageConstants.userEmailStorageKey,
          value: email,
        ),
        _secureStorageUtils.setValueString(
          key: AppLocalStorageConstants.userPasswordStorageKey,
          value: password,
        ),
      ]);
      return true;
    } catch (e, t) {
      AppLogger.error(
        'Error saving credentials',
        error: e,
        stackTrace: t,
        tag: "🔐 App Config Service [setCredentials]",
      );
      return false;
    }
  }

  /// Get stored email
  Future<String?> get email async => await _secureStorageUtils?.getValueString(
    key: AppLocalStorageConstants.userEmailStorageKey,
  );

  /// Get stored password
  Future<String?> get password async => await _secureStorageUtils
      ?.getValueString(key: AppLocalStorageConstants.userPasswordStorageKey);

  /// setter method to set the access token status with optional parameter [notify] set it true if you wanna to notify all application and route system.
  Future<bool?> setToken({required String token, bool? notify = false}) async {
    return await _secureStorageUtils?.setValueString(
      key: AppLocalStorageConstants.accessTokenStorageKey,
      value: token,
    );
  }

  ///access token getter
  Future<String?> get token async => await _secureStorageUtils?.getValueString(
    key: AppLocalStorageConstants.accessTokenStorageKey,
  );

  /// setter method to set the cookie with optional parameter [notify] set it true if you wanna to notify all application and route system.
  Future<bool?> setCookie({
    required String cookie,
    bool? notify = false,
  }) async {
    return await _secureStorageUtils?.setValueString(
      key: AppLocalStorageConstants.cookieStorageKey,
      value: cookie,
    );
  }

  ///cookie getter
  Future<String?> get cookie async => await _secureStorageUtils?.getValueString(
    key: AppLocalStorageConstants.cookieStorageKey,
  );

  /// setter method to set the current user status with optional parameter [notify] set it true if you wanna to notify all application and route system.
  Future<bool?> setIsLogin(bool v, {bool? notify = false}) async {
    return await _sharedPreferenceUtils?.setValueBool(
      key: AppLocalStorageConstants.isLoginStorageKey,
      value: v,
    );
  }

  /// getter to get the current user login status
  Future<bool?> get isLogin async => await _sharedPreferenceUtils?.getValueBool(
    key: AppLocalStorageConstants.isLoginStorageKey,
  );

  /// Clear all stored configurations securely
  Future<bool> clearAllConfigs() async {
    try {
      AppLogger.info(
        "🗑 Clearing all local configurations...",
        tag: "🔐 App Config Service [clearAllConfigs]",
      );

      await Future.wait([
        _sharedPreferenceUtils?.resetConfig() ?? Future.value(),
        _secureStorageUtils?.resetConfig() ?? Future.value(),
      ]);
      AppLogger.info(
        "All local configurations cleared successfully.",
        tag: "🔐 App Config Service [clearAllConfigs]",
      );
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error clearing local configurations',
        error: e,
        stackTrace: stackTrace,
        tag: "🔐 App Config Service [clearAllConfigs]",
      );
      return false;
    }
  }
}
