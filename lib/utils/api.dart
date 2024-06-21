import 'package:dio/dio.dart';

const kApiBaseUrl = "http://192.168.1.6:5000/";

final dio = Dio(
  BaseOptions(baseUrl: kApiBaseUrl),
);
