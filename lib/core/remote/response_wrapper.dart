import 'package:grad_ease/core/remote/rest_exception.dart';

class RestResponse<T> {
  final int statusCode;
  final String? message;
  final T? data;

  RestResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }

  factory RestResponse.fromJson(Map<String, dynamic> json,
      {T Function(dynamic)? fromJson}) {
    return RestResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : json['data'] as T?,
    );
  }

  static List<String> listOfStringData(Map<String, dynamic> data) {
    return (data['data'] as List<dynamic>).map((e) => e as String).toList();
  }
}

class Failure {
  final String? message;

  Failure([this.message = "Something Went Wrong !"]);

  factory Failure.handleException(Object e) {
    if (e is RestResponseException) {
      return Failure(e.message);
    } else if (e is Exception) {
      return Failure(e.toString());
    }
    return Failure("Something Went Wrong !");
  }
}
