import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:store/data/repositories/favorites.repository.dart';
import 'package:store/data/services/favorites.service.dart';
import '../config/app_local.config.dart';
import '../data/repositories/users.repository.dart';
import '../data/repositories/products.repository.dart';
import '../data/services/users.service.dart';
import '../data/services/products.service.dart';
import '../services/backend/api_services/dio_api_service/dio_api.service.dart';
import '../services/backend/api_services/http_api_service/http_api.service.dart';
import '../services/backend/endpoint_service/endpoints.service.dart';
import '../services/local_storage/secure_storage.service.dart';
import '../services/local_storage/shared_preference.service.dart';
import '../utils/constants_utils/app_local_storage.constants.dart';

final List<SingleChildWidget> appProviders = [
  Provider<SecureStorageService>(
    lazy: true,
    create:
        (_) => SecureStorageService(
          listOfKeysNotRemoveWhileResetSecureStorageConfig:
              AppLocalStorageConstants
                  .listOfKeysNotRemoveWhileResetSecureStorageConfig,
        ),
  ),
  Provider<SharedPreferenceService>(
    lazy: true,
    create:
        (_) => SharedPreferenceService(
          listOfKeysNotRemoveWhileResetSharedPreferencesConfig:
              AppLocalStorageConstants
                  .listOfKeysNotRemoveWhileResetSharedPreferencesConfig,
        ),
  ),
  Provider<AppLocalConfigurations>(
    lazy: true,
    create: (ctx) {
      final sharedPreferences = ctx.read<SharedPreferenceService>();
      final secureStorage = ctx.read<SecureStorageService>();
      return AppLocalConfigurations(
        sharedPreferenceUtils: sharedPreferences,
        secureStorageUtils: secureStorage,
      );
    },
  ),
  Provider<DioClientService>(
    lazy: true,
    create:
        (ctx) => DioClientService(
          dio: Dio(),
          internetConnection: InternetConnection(),
        ),
  ),
  Provider<HttpClientService>(
    lazy: true,
    create:
        (ctx) => HttpClientService(internetConnection: InternetConnection()),
  ),
  Provider<EndpointServices>(lazy: true, create: (ctx) => EndpointServices()),
  Provider<UsersService>(
    lazy: true,
    create: (ctx) {
      final httpClientService = ctx.read<HttpClientService>();
      final endpoints = ctx.read<EndpointServices>();
      return UsersService(
        clientService: httpClientService,
        endpoints: endpoints,
      );
    },
  ),

  Provider<UsersRepository>(
    lazy: true,
    create: (ctx) {
      final appConfig = ctx.read<AppLocalConfigurations>();
      final usersService = ctx.read<UsersService>();
      return UsersRepository(usersService: usersService, appConfig: appConfig);
    },
  ),
  Provider<ProductsRepository>(
    lazy: true,
    create: (ctx) {
      final httpClientService = ctx.read<HttpClientService>();
      final endpoints = ctx.read<EndpointServices>();
      return ProductsRepository(
        productsService: ProductsService(
          clientService: httpClientService,
          endpoints: endpoints,
        ),
      );
    },
  ),
  Provider<FavoritesRepository>(
    lazy: true,
    create: (ctx) {
      final sharedPreferences = ctx.read<SharedPreferenceService>();
      return FavoritesRepository(
        favoritesService: FavoritesService(sharedPrefs: sharedPreferences),
      );
    },
  ),
];
