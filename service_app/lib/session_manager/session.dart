import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static bool isLoggedIn = false;
  static String? userId;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    userId = prefs.getString('userId');
  }

  static Future<void> login(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = true;
    SessionManager.userId = userId;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = false;
    userId = null;
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
  }
}
