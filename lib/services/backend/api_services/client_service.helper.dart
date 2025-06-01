import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_local.config.dart';
import '../../../route/app_navigator.service.dart';
import '../../../utils/app_logger.utils.dart';
import 'api_logging/api.logger.dart';
import '../../../data/models/operation_result.model.dart';

enum RequestContentType { json, formUrlEncoded }

abstract class ApiClientHelper {
  static Function(dynamic response)? unauthrizedCallback;
  static Future<Map<String, String>> buildHeadersHelperMethod({
    Map<String, dynamic>? additionalHeaders,
    bool? addToken = true,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    try {
      // Validate context availability
      final context = AppNavigator.navigatorKey.currentContext;
      if (context == null) {
        throw StateError('Navigation context is not available');
      }

      // Initialize headers with content type
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': _getContentTypeHeader(contentType),
      };

      // Add additional headers if provided
      _addAdditionalHeaders(headers, additionalHeaders);

      // Handle authentication headers
      await _addAuthHeaders(
        headers,
        context: context,
        addToken: addToken,
        isBasicAuth: isBasicAuth,
        basicUsername: basicUsername,
        basicPassword: basicPassword,
      );

      return headers;
    } catch (e, stackTrace) {
      AppLogger.error(
        "⚙️ Error while building request headers",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Helper method to get content type header string
  static String _getContentTypeHeader(RequestContentType contentType) {
    return switch (contentType) {
      RequestContentType.json => 'application/json',
      RequestContentType.formUrlEncoded => 'application/x-www-form-urlencoded',
    };
  }

  // Helper method to add additional headers
  static void _addAdditionalHeaders(
    Map<String, String> headers,
    Map<String, dynamic>? additionalHeaders,
  ) {
    if (additionalHeaders != null) {
      for (final entry in additionalHeaders.entries) {
        if (entry.value != null) {
          headers[entry.key] = entry.value.toString();
        }
      }
    }
  }

  // Helper method to add authentication headers
  static Future<void> _addAuthHeaders(
    Map<String, String> headers, {
    required BuildContext context,
    required bool? addToken,
    required bool isBasicAuth,
    String? basicUsername,
    String? basicPassword,
  }) async {
    final appConfigServiceProvider = Provider.of<AppLocalConfigurations>(
      context,
      listen: false,
    );

    /// using when there is no basic user name & password not passed ,so get them from the locale storage if there available
    final String? username = await appConfigServiceProvider.email;
    final String? password = await appConfigServiceProvider.password;

    if (isBasicAuth) {
      _addBasicAuthHeader(
        headers,
        basicUsername ?? username,
        basicPassword ?? password,
      );
    } else if (addToken == true) {
      await _addBearerTokenHeader(headers, appConfigServiceProvider);
    }
  }

  // Helper method for Basic Auth
  static void _addBasicAuthHeader(
    Map<String, String> headers,
    String? username,
    String? password,
  ) {
    if (username == null || password == null) {
      throw ArgumentError(
        'Both username and password are required for Basic Auth',
      );
    }

    final credentials = '$username:$password';
    final encoded = base64Encode(utf8.encode(credentials));
    headers['Authorization'] = 'Basic $encoded';
  }

  // Helper method for Bearer Token
  static Future<void> _addBearerTokenHeader(
    Map<String, String> headers,
    AppLocalConfigurations config,
  ) async {
    final token = await config.token;
    if (token?.isNotEmpty ?? false) {
      headers['Authorization'] = 'Bearer $token';
    }
  }

  // static Future<Map<String, String>> buildHeadersHelperMethod({
  //   Map<String, dynamic>? additionalHeaders,
  //   bool? addToken = true,
  //   bool isBasicAuth = false,
  //   String? basicUsername,
  //   String? basicPassword,
  //   RequestContentType contentType = RequestContentType.json,
  // }) async {
  //   final appConfigServiceProvider = Provider.of<AppLocalConfigurations>(
  //     AppNavigator.navigatorKey.currentContext!,
  //     listen: false,
  //   );
  //   // Choose content type based on flag
  //   final contentTypeHeader = switch (contentType) {
  //     RequestContentType.json => 'application/json',
  //     RequestContentType.formUrlEncoded => 'application/x-www-form-urlencoded',
  //   };
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': contentTypeHeader,
  //   };
  //   if (additionalHeaders != null && additionalHeaders.isNotEmpty) {
  //     for (var h in additionalHeaders.keys) {
  //       headers[h] = additionalHeaders[h]!;
  //     }
  //   }
  //   // Basic Authentication support
  //   if (isBasicAuth && basicUsername != null && basicPassword != null) {
  //     final credentials = '$basicUsername:$basicPassword';
  //     final encoded = base64Encode(utf8.encode(credentials));
  //     headers['Authorization'] = 'Basic $encoded';
  //   }
  //   // Bearer Token
  //   else if (addToken == true) {
  //     final token = await appConfigServiceProvider.token;
  //     if (token?.isNotEmpty ?? false) {
  //       headers['Authorization'] = token!;
  //     }
  //   }

  //   return headers;
  // }

  static OperationResult<T> handleError<T>({
    required dynamic error,
    required String endpoint,
  }) {
    ApiLogger.logError(endpoint: endpoint, error: error);
    return OperationResult(
      statusCode: 500,
      success: false,
      message: error.toString(),
    );
  }

  static OperationResult<T> handleNoInternet<T>() {
    return OperationResult<T>(
      statusCode: 503,
      success: false,
      message:
          "No internet connection. Please check your connection and try again.",
    );
  }
}
