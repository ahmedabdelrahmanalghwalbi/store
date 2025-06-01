import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../api_logging/api.logger.dart';
import '../client_service.helper.dart';
import '../client_service.interface.dart';
import '../../../../data/models/operation_result.model.dart';

class HttpClientService implements ClientServiceInterface {
  final InternetConnection _internetConnection;
  HttpClientService({required InternetConnection internetConnection})
    : _internetConnection = internetConnection;
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
      final response = await http.get(Uri.parse(url), headers: headers);
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
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: (isEncodedBody == true) ? jsonEncode(data) : data,
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
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header ?? {});
    request.headers.addAll(headers);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath('file', file.paths.first!),
      );
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
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
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: (isEncodedBody == true) ? jsonEncode(data) : data,
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
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        body: isEncodedBody == true ? jsonEncode(data) : data,
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
    final headers = await ApiClientHelper.buildHeadersHelperMethod(
      additionalHeaders: header,
      addToken: addToken,
      basicPassword: basicPassword,
      basicUsername: basicUsername,
      isBasicAuth: isBasicAuth,
      contentType: contentType,
    );
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header ?? {});
    request.headers.addAll(headers);
    requestFields?.forEach((key, value) {
      request.fields[key] = value;
    });
    request.files.add(
      http.MultipartFile.fromBytes('file', fileData, filename: name),
    );
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse<T>(
        response: response,
        dataKey: dataKey,
        endpoint: url,
      );
    } catch (e) {
      return ApiClientHelper.handleError<T>(error: e, endpoint: url);
    }
  }

  OperationResult<T> _handleResponse<T>({
    required http.Response response,
    required String dataKey,
    required String endpoint,
  }) {
    dynamic decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body);
    } catch (e) {
      // Fallback if response is plain text or not JSON
      decodedResponse = response.body;
    }
    ApiLogger.logResponse(
      endpoint: endpoint,
      response: decodedResponse,
      statusCode: response.statusCode,
      headers: response.headers,
    );
    // Handle unauthorized responses
    if (response.statusCode == 401 &&
        ApiClientHelper.unauthrizedCallback != null) {
      ApiClientHelper.unauthrizedCallback!(decodedResponse);
      return OperationResult<T>(
        statusCode: response.statusCode,
        success: false,
        message: "Unauthorized",
        responseHeaders: response.headers,
      );
    }

    // Successful response
    final bool isSuccess =
        response.statusCode >= 200 && response.statusCode < 300;
    try {
      // Handle when T is String and response is plain text
      if (T == String && decodedResponse is String) {
        return OperationResult<T>(
          data: decodedResponse as T,
          statusCode: response.statusCode,
          success: isSuccess,
          responseHeaders: response.headers,
        );
      }

      // Handle expected JSON Map with dataKey
      if (decodedResponse is Map<String, dynamic>) {
        final dynamic extractedData =
            decodedResponse[dataKey] ?? decodedResponse;

        return OperationResult<T>(
          data: extractedData as T,
          statusCode: response.statusCode,
          success: isSuccess,
          message: decodedResponse['message']?.toString(),
          responseHeaders: response.headers,
        );
      }

      // ✅ Handle List<Map<String, dynamic>> directly
      if (decodedResponse is List &&
          decodedResponse.every((e) => e is Map<String, dynamic>)) {
        try {
          final parsedList = List<Map<String, dynamic>>.from(decodedResponse);
          return OperationResult<T>(
            data: parsedList as T,
            statusCode: response.statusCode,
            success: isSuccess,
            responseHeaders: response.headers,
          );
        } catch (e) {
          return OperationResult<T>(
            statusCode: response.statusCode,
            success: false,
            message: "Error casting list of objects to expected type: $e",
            responseHeaders: response.headers,
          );
        }
      }

      // Handle List or other types
      if (decodedResponse is T) {
        return OperationResult<T>(
          data: decodedResponse,
          statusCode: response.statusCode,
          success: isSuccess,
          responseHeaders: response.headers,
        );
      }

      return OperationResult<T>(
        statusCode: response.statusCode,
        success: false,
        message:
            "Unexpected response format. Expected type: $T, but got: ${decodedResponse.runtimeType}",
        responseHeaders: response.headers,
      );
    } catch (e, stackTrace) {
      ApiLogger.logError(
        endpoint: endpoint,
        error: e,
        stackTrace: stackTrace,
        statusCode: response.statusCode,
      );

      return OperationResult<T>(
        statusCode: response.statusCode,
        success: false,
        message: "Error processing response: ${e.toString()}",
        responseHeaders: response.headers,
      );
    }
  }
}
