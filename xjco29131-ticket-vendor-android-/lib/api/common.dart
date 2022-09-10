import 'package:dio/dio.dart';

final _options = BaseOptions(
    baseUrl: 'https://movie.m.reimu.host',
    connectTimeout: 5000,
    receiveTimeout: 3000);

Dio? _dio;
Dio get dio {
  if (_dio == null) {
    _dio = Dio(_options);
  }
  return _dio!;
}

Map<String, dynamic> unwrapResponse(Map<String, dynamic> data) {
  if (data['status'] != 1) {
    throw Exception("Request failed: ${data['status']} ($data)");
  }
  return data['data'];
}
