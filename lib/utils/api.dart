import 'package:dio/dio.dart';

const kApiBaseUrl = "http://192.168.1.6:5000/";

class ApiError implements Exception {
  final String message;
  final int code;

  ApiError({required this.message, required this.code});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['error']['message'],
      code: json['error']['code'],
    );
  }

  @override
  String toString() {
    return message;
  }
}

final dio = Dio(
  BaseOptions(baseUrl: kApiBaseUrl),
);
