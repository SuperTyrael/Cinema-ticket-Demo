import 'package:cinema_tickets/api/common.dart';

class UserApi {
  static Future<String> login(String username, String password) async {
    final response = await dio.post("/auth/login",
        data: {"username": username, "password": password});

    return unwrapResponse(response.data)['token'];
  }

  static Future<String> register(String username, String password) async {
    final response = await dio.post("/auth/register", data: {
      "username": username,
      "password": password,
      "email": "a@example.com"
    });

    return unwrapResponse(response.data)['token'];
  }
}
