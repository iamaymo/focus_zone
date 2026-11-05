import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/storage_keys.dart';

class PreferencesService {
  /// Returns true if the user has already seen and passed the gateway screen.
  static Future<bool> hasSeenGateway() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.hasSeenGateway) ?? false;
  }

  /// Marks the gateway screen as seen so it will not appear on subsequent launches.
  static Future<void> setGatewaySeen([bool value = true]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.hasSeenGateway, value);
  }

  /// Resets the gateway flag to allow viewing the gateway screen again (e.g. for testing).
  static Future<void> resetGateway() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.hasSeenGateway, false);
  }
}
