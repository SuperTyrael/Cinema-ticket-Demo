import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static bool isLogin = false;
  static bool _tokenLoaded = false;
  static String? _accessToken;
  static const _KEY_ACCESS_TOKEN = "accessToken";

  static Future<String?> get token {
    if (_tokenLoaded) {
      return SynchronousFuture(_accessToken);
    } else {
      return _loadToken();
    }
  }

  static Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();

    _setToken(token);

    if (token != null) {
      await prefs.setString(_KEY_ACCESS_TOKEN, token);
    } else {
      await prefs.remove(_KEY_ACCESS_TOKEN);
    }
  }

  static Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_KEY_ACCESS_TOKEN);

    _setToken(token);

    return token;
  }

  static _setToken(String? token) {
    _accessToken = token;
    _tokenLoaded = true;
    isLogin = token != null;
  }
}
