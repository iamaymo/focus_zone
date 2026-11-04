import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyAccentColor = 'accent_color';
  static const String _keyFontFamily = 'font_family';

  ThemeMode _themeMode = ThemeMode.light;
  int _accentColorIndex = 0;
  String _fontFamily = 'default';

  ThemeMode get themeMode => _themeMode;
  int get accentColorIndex => _accentColorIndex;
  String get fontFamily => _fontFamily;

  // Available accent colors
  static const List<Color> accentColors = [
    Color(0xff64513f), // Original brown
    Color(0xff1565c0), // Blue
    Color(0xff2e7d32), // Green
    Color(0xffc62828), // Red
    Color(0xff6a1b9a), // Purple
    Color(0xffef6c00), // Orange
    Color(0xff00838f), // Teal
    Color(0xff37474f), // Blue Grey
  ];

  static const List<String> accentColorNames = [
    'Brown',
    'Blue',
    'Green',
    'Red',
    'Purple',
    'Orange',
    'Teal',
    'Blue Grey',
  ];

  // Arabic color names
  static const List<String> accentColorNamesAr = [
    'بني',
    'أزرق',
    'أخضر',
    'أحمر',
    'بنفسجي',
    'برتقالي',
    'تيل',
    'رمادي مزرق',
  ];

  static const List<String> fontFamilies = [
    'default',
    'Roboto',
    'Cairo',
    'Tajawal',
  ];

  Color get currentAccentColor => accentColors[_accentColorIndex];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keyThemeMode) ?? 'light';
    _themeMode = modeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    _accentColorIndex = prefs.getInt(_keyAccentColor) ?? 0;
    if (_accentColorIndex < 0 || _accentColorIndex >= accentColors.length) {
      _accentColorIndex = 0;
    }

    _fontFamily = prefs.getString(_keyFontFamily) ?? 'default';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyThemeMode,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> toggleThemeMode() async {
    final next =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(next);
  }

  Future<void> setAccentColor(int index) async {
    if (index < 0 || index >= accentColors.length) return;
    if (_accentColorIndex == index) return;
    _accentColorIndex = index;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAccentColor, index);
  }

  Future<void> setFontFamily(String font) async {
    if (_fontFamily == font) return;
    _fontFamily = font;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFontFamily, font);
  }

  ThemeData buildLightTheme() {
    final accent = currentAccentColor;
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily == 'default' ? null : _fontFamily,
      colorScheme: ColorScheme.light(
        primary: accent,
        onPrimary: Colors.white,
        secondary: accent.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: const Color(0xff1a1a1a),
        tertiary: Colors.white,
        onTertiary: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xfff5f5f5),
      appBarTheme: AppBarTheme(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  ThemeData buildDarkTheme() {
    final accent = currentAccentColor;
    // Make accent a bit brighter in dark mode for better visibility
    final brightAccent = Color.lerp(accent, Colors.white, 0.15) ?? accent;
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily == 'default' ? null : _fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: brightAccent,
        onPrimary: Colors.white,
        secondary: brightAccent.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        surface: const Color(0xff1e1e1e),
        onSurface: const Color(0xffe0e0e0),
        tertiary: const Color(0xff2a2a2a),
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xff121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff1e1e1e),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xff1e1e1e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: brightAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

