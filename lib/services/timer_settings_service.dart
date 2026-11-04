import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerSettingsService extends ChangeNotifier {
  static final TimerSettingsService instance = TimerSettingsService._internal();
  TimerSettingsService._internal();

  static const String _keyFocusMinutes = 'default_focus_minutes';
  static const String _keyShortBreak = 'default_short_break_minutes';
  static const String _keyLongBreak = 'default_long_break_minutes';

  int _focusMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;

  int get focusMinutes => _focusMinutes;
  int get shortBreakMinutes => _shortBreakMinutes;
  int get longBreakMinutes => _longBreakMinutes;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _focusMinutes = prefs.getInt(_keyFocusMinutes) ?? 25;
    _shortBreakMinutes = prefs.getInt(_keyShortBreak) ?? 5;
    _longBreakMinutes = prefs.getInt(_keyLongBreak) ?? 15;
    notifyListeners();
  }

  Future<void> setFocusMinutes(int val) async {
    if (val < 1 || val > 90) return;
    _focusMinutes = val;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFocusMinutes, val);
  }

  Future<void> setShortBreakMinutes(int val) async {
    if (val < 1 || val > 30) return;
    _shortBreakMinutes = val;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyShortBreak, val);
  }

  Future<void> setLongBreakMinutes(int val) async {
    if (val < 1 || val > 45) return;
    _longBreakMinutes = val;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLongBreak, val);
  }

  Future<void> setAll({
    required int focus,
    required int shortBreak,
    required int longBreak,
  }) async {
    _focusMinutes = focus.clamp(1, 90);
    _shortBreakMinutes = shortBreak.clamp(1, 30);
    _longBreakMinutes = longBreak.clamp(1, 45);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyFocusMinutes, _focusMinutes);
    await prefs.setInt(_keyShortBreak, _shortBreakMinutes);
    await prefs.setInt(_keyLongBreak, _longBreakMinutes);
  }
}

