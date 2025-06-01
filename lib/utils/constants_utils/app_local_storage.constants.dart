abstract class AppLocalStorageConstants {
  static const String accessTokenStorageKey = 'accessToken';
  static const String cookieStorageKey = 'cookie';
  static const String languageStorageKey = 'language';
  static const String isLoginStorageKey = 'isLogin';
  static const String userEmailStorageKey = 'userEmail';
  static const String userPasswordStorageKey = 'userPassword';
  static const String userModelStorageKey = 'user_model';
  static const List<String> listOfKeysNotRemoveWhileResetSecureStorageConfig =
      [];
  static const List<String>
  listOfKeysNotRemoveWhileResetSharedPreferencesConfig = [];
}
