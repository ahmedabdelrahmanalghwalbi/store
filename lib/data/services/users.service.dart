import 'package:easy_localization/easy_localization.dart';
import '../../services/backend/api_services/client_service.helper.dart';
import '../../services/backend/api_services/client_service.interface.dart';
import '../../services/backend/endpoint_service/endpoint.model.dart';
import '../../services/backend/endpoint_service/endpoints.service.dart';
import '../../utils/app_logger.utils.dart';
import '../../utils/constants_utils/app_strings.constants.dart';
import '../models/operation_result.model.dart';

class UsersService {
  UsersService({
    required ClientServiceInterface clientService,
    required EndpointServices endpoints,
  }) : _clientService = clientService,
       _endpoints = endpoints;
  final ClientServiceInterface _clientService;
  final EndpointServices _endpoints;

  /// Authenticates a user with username and password
  /// [username]: User's username or email
  /// [password]: User's password
  Future<OperationResult<Map<String, dynamic>>> login({
    required String username,
    required String password,
  }) async {
    try {
      final Map<String, String> body = {
        'username': username,
        'password': password,
      };
      return _clientService.post<Map<String, dynamic>>(
        _endpoints.getApiEndpoint(EndpointsNames.login).url,
        body,
        dataKey: 'data',
        addToken: false,
        basicPassword: password,
        basicUsername: username,
        isBasicAuth: false,
        contentType: RequestContentType.json,
        isEncodedBody: true,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "Authentication failed",
        error: e,
        stackTrace: stackTrace,
        tag: "🔐 Auth",
      );
      return OperationResult<Map<String, dynamic>>(
        statusCode: 500,
        success: false,
        message: AppStrings.errorWhileLoggingIn.tr(),
      );
    }
  }

  /// Registers a new user account
  /// [username]: User's desired username
  /// [email]: User's email address
  /// [password]: User's password
  Future<OperationResult<Map<String, dynamic>>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'username': username,
        'email': email,
        'password': password,
      };

      return await _clientService.post<Map<String, dynamic>>(
        _endpoints.getApiEndpoint(EndpointsNames.register).url,
        body,
        dataKey: 'data',
        addToken: false,
        contentType: RequestContentType.json,
        isEncodedBody: true,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "Registration failed",
        error: e,
        stackTrace: stackTrace,
        tag: "📝 Registration",
      );
      return OperationResult(
        statusCode: 500,
        success: false,
        message: AppStrings.registrationError.tr(),
      );
    }
  }
}
