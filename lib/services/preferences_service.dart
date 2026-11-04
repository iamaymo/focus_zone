import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyHasSeenGateway = 'has_seen_gateway';

  /// Returns true if the user has already seen and passed the gateway screen.
  static Future<bool> hasSeenGateway() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenGateway) ?? false;
  }

  /// Marks the gateway screen as seen so it will not appear on subsequent launches.
  static Future<void> setGatewaySeen([bool value = true]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenGateway, value);
  }

  /// Resets the gateway flag to allow viewing the gateway screen again (e.g. for testing).
  static Future<void> resetGateway() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenGateway, false);
  }
}
