import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:store/services/backend/api_services/client_service.helper.dart';
import '../../../data/models/operation_result.model.dart';

abstract class ClientServiceInterface {
  Future<OperationResult<T>> get<T>(
    String url, {
    required String dataKey,
    Map<String, String>? header,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  });

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
  });

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
  });

  Future<OperationResult<T>> put<T>(
    String url,
    Map data, {
    required String dataKey,
    Map<String, String>? header,
    bool? isEncodedBody = false,
    bool checkOnTokenExpiration = true,
    bool? addToken,
    bool isBasicAuth = false,
    String? basicUsername,
    String? basicPassword,
    RequestContentType contentType = RequestContentType.json,
  });

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
  });

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
  });
}
