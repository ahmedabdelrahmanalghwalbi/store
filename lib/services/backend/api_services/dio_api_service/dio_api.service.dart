import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../../utils/app_logger.utils.dart';
import '../api_logging/api.logger.dart';
import '../../endpoint_service/endpoint.model.dart';
import '../client_service.helper.dart';
import '../client_service.interface.dart';
import '../../../../data/models/operation_result.model.dart';

class DioClientService implements ClientServiceInterface {
  final Dio _dio;
  final InternetConnection _internetConnection;

  DioClientService({
    required Dio dio,
    required InternetConnection internetConnection,
  }) : _dio = dio,
       _internetConnection = internetConnection {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info("🌐 Request: ${options.method} ${options.path}");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info("📥 Response: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.error("❌ API Error: ${e.message}", error: e);
          return handler.next(e);
        },
      ),
    );
  }
  Future<bool> _hasInternetConnection() async {
    return await _internetConnection.hasInternetAccess;
  }

  @override
  Future<OperationResult<T>> get<T>(
    String url, {
    required String dataKey,
    Map<String, String>? header,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    try {
      final headers = await ApiClientHelper.buildHeadersHelperMethod(
        additionalHeaders: header,
        addToken: addToken,
        basicPassword: basicPassword,
        basicUsername: basicUsername,
        isBasicAuth: isBasicAuth,
        contentType: contentType,
      );
      ApiLogger.logRequest(method: HttpMethods.get.name, endpoint: url);
      final response = await _dio.get(url, options: Options(headers: headers));
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  @override
  Future<OperationResult<T>> post<T>(
    String url,
    dynamic data, {
    required String dataKey,
    Map<String, String>? header,
    bool? isEncodedBody = false,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    try {
      final headers = await ApiClientHelper.buildHeadersHelperMethod(
        additionalHeaders: header,
        addToken: addToken,
        basicPassword: basicPassword,
        basicUsername: basicUsername,
        isBasicAuth: isBasicAuth,
        contentType: contentType,
      );
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  @override
  Future<OperationResult<T>> postWithFormData<T>(
    String url,
    Map<String, String> data, {
    required String dataKey,
    required List<FilePickerResult> files,
    Map<String, String>? header,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    final headers = await ApiClientHelper.buildHeadersHelperMethod(
      additionalHeaders: header,
      addToken: addToken,
      basicPassword: basicPassword,
      basicUsername: basicUsername,
      isBasicAuth: isBasicAuth,
      contentType: contentType,
    );
    FormData formData = FormData.fromMap(data);
    for (var file in files) {
      formData.files.add(
        MapEntry('file', await MultipartFile.fromFile(file.paths.first!)),
      );
    }
    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  @override
  Future<OperationResult<T>> put<T>(
    String url,
    Map data, {
    required String dataKey,
    Map<String, String>? header,
    bool checkOnTokenExpiration = true,
    bool? isEncodedBody = false,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    try {
      final headers = await ApiClientHelper.buildHeadersHelperMethod(
        additionalHeaders: header,
        addToken: addToken,
        basicPassword: basicPassword,
        basicUsername: basicUsername,
        isBasicAuth: isBasicAuth,
        contentType: contentType,
      );
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  @override
  Future<OperationResult<T>> delete<T>(
    String url,
    Map data, {
    required String dataKey,
    Map<String, String>? header,
    bool? isEncodedBody = false,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    try {
      final headers = await ApiClientHelper.buildHeadersHelperMethod(
        additionalHeaders: header,
        addToken: addToken,
        basicPassword: basicPassword,
        basicUsername: basicUsername,
        isBasicAuth: isBasicAuth,
        contentType: contentType,
      );
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  @override
  Future<OperationResult<T>> postFile<T>(
    String url,
    Uint8List fileData,
    String name, {
    required String dataKey,
    Map<String, String>? requestFields,
    Map<String, String>? header,
    bool isImage = true,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  }) async {
    if (!await _hasInternetConnection()) {
      return ApiClientHelper.handleNoInternet<T>();
    }
    FormData formData = FormData.fromMap(requestFields ?? {});
    formData.files.add(
      MapEntry('file', MultipartFile.fromBytes(fileData, filename: name)),
    );
    try {
      final headers = await ApiClientHelper.buildHeadersHelperMethod(
        additionalHeaders: header,
        addToken: addToken,
        basicPassword: basicPassword,
        basicUsername: basicUsername,
        isBasicAuth: isBasicAuth,
        contentType: contentType,
      );
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(
        endpoint: url,
        response: response,
        dataKey: dataKey,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  OperationResult<T> _handleResponse<T>({
    required String endpoint,
    required Response response,
    required String dataKey,
  }) {
    // Safely get status code with fallback
    final statusCode = response.statusCode ?? 500;

    dynamic decodedResponse;
    try {
      decodedResponse = jsonDecode(response.data.toString());
    } catch (e) {
      // Fallback if response is plain text or not JSON
      decodedResponse = response.data;
    }

    ApiLogger.logResponse(
      endpoint: endpoint,
      statusCode: statusCode,
      response: decodedResponse,
      headers: response.headers.map,
    );

    // Handle unauthorized responses
    if (statusCode == 401 && ApiClientHelper.unauthrizedCallback != null) {
      ApiClientHelper.unauthrizedCallback!(response.data);
    }

    final bool isSuccess = statusCode >= 200 && statusCode < 300;

    try {
      // Handle when T is String and response is plain text
      if (T == String && decodedResponse is String) {
        return OperationResult<T>(
          data: decodedResponse as T,
          statusCode: statusCode,
          success: isSuccess,
          responseHeaders: response.headers.map,
        );
      }

      // Handle expected JSON Map with dataKey
      if (decodedResponse is Map<String, dynamic>) {
        final dynamic extractedData =
            decodedResponse[dataKey] ?? decodedResponse;

        return OperationResult<T>(
          data: extractedData as T,
          statusCode: statusCode,
          success: isSuccess,
          message: decodedResponse['message']?.toString(),
          responseHeaders: response.headers.map,
        );
      }

      // Handle List<Map<String, dynamic>> directly
      if (decodedResponse is List) {
        if (decodedResponse.every((e) => e is Map<String, dynamic>)) {
          return OperationResult<T>(
            data: List<Map<String, dynamic>>.from(decodedResponse) as T,
            statusCode: statusCode,
            success: isSuccess,
            responseHeaders: response.headers.map,
          );
        }
        // Handle other List types if they match T
        if (decodedResponse is T) {
          return OperationResult<T>(
            data: decodedResponse as T,
            statusCode: statusCode,
            success: isSuccess,
            responseHeaders: response.headers.map,
          );
        }
      }

      // Handle other types that directly match T
      if (decodedResponse is T) {
        return OperationResult<T>(
          data: decodedResponse,
          statusCode: statusCode,
          success: isSuccess,
          responseHeaders: response.headers.map,
        );
      }

      // Fallback for unexpected types
      return OperationResult<T>(
        statusCode: statusCode,
        success: false,
        message:
            "Unexpected response format. Expected type: $T, but got: ${decodedResponse.runtimeType}",
        responseHeaders: response.headers.map,
      );
    } catch (e, stackTrace) {
      ApiLogger.logError(
        endpoint: endpoint,
        error: e,
        stackTrace: stackTrace,
        statusCode: statusCode,
      );

      return OperationResult<T>(
        statusCode: statusCode,
        success: false,
        message: "Error processing response: ${e.toString()}",
        responseHeaders: response.headers.map,
      );
    }
  }
}
