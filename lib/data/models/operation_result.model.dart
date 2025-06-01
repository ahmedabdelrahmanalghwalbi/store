import 'base.model.dart';

class OperationResult<T> {
  final int statusCode;
  final int? bodyStatusCode;
  final bool success;
  final T? data;
  final String? message;
  final ApiStatus? status;
  final Map<String, dynamic>? responseHeaders;

  OperationResult({
    required this.statusCode,
    this.bodyStatusCode,
    this.success = false,
    this.data,
    this.status,
    this.message,
    this.responseHeaders,
  });
}

class ApiStatus {
  final int code;
  final String message;
  final String token;

  ApiStatus({required this.code, required this.message, required this.token});

  factory ApiStatus.fromJson(Map<String, dynamic> json) {
    return ApiStatus(
      code: BaseModel.parseInt(json['code']) ?? 500,
      message: BaseModel.parseString(json['message']) ?? 'Unknown error',
      token: json['token'] as String? ?? '',
    );
  }
}
