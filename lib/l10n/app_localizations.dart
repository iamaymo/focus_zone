import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appTitle': 'Focus zone',
      'welcomeTitle': 'أهلاً بك في Focus zone',
      'welcomeSubtitle':
          'نظّم مهامك اليومية بكفاءة وعزز تركيزك وإنتاجيتك مع مؤقت بومودورو الذكي وقائمة المهام.',
      'enterApp': 'دخول للتطبيق',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'switchLanguage': 'تغيير اللغة',
      'chooseLanguage': 'اختر اللغة',
      'homeTitle': 'Focus zone',
      'homeWelcome': 'مرحباً بك في Focus zone!',
      'homeDescription':
          'مساحتك المثالية لإنجاز المهام وزيادة التركيز بمؤقت بومودورو. لقد تم الدخول وتخطي شاشة البداية بنجاح.',
      'todoTitle': 'قائمة المهام (To-Do)',
      'pomodoroTitle': 'مؤقت بومودورو (Pomodoro)',
      'resetGatewayButton': 'إعادة ظهور صفحة البداية (للتجربة)',
      'resetGatewaySuccess':
          'تمت إعادة الضبط! عند إغلاق التطبيق وإعادة فتحه ستظهر صفحة البداية مجدداً.',
      'currentLanguageLabel': 'اللغة الحالية',
    },
    'en': {
      'appTitle': 'Focus zone',
      'welcomeTitle': 'Welcome to Focus zone',
      'welcomeSubtitle':
          'Organize your daily tasks efficiently and boost your focus and productivity with smart Pomodoro timer and To-Do list.',
      'enterApp': 'Enter App',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'switchLanguage': 'Change Language',
      'chooseLanguage': 'Select Language',
      'homeTitle': 'Focus zone',
      'homeWelcome': 'Welcome to Focus zone!',
      'homeDescription':
          'Your dedicated space to conquer tasks and maximize focus with Pomodoro timer. Gateway screen bypassed successfully.',
      'todoTitle': 'To-Do List',
      'pomodoroTitle': 'Pomodoro Timer',
      'resetGatewayButton': 'Reset Gateway Screen (For Testing)',
      'resetGatewaySuccess':
          'Reset successful! The gateway screen will appear on the next app launch.',
      'currentLanguageLabel': 'Current Language',
    },
  };

  String _translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['ar']?[key] ??
        key;
  }

  String get appTitle => _translate('appTitle');
  String get welcomeTitle => _translate('welcomeTitle');
  String get welcomeSubtitle => _translate('welcomeSubtitle');
  String get enterApp => _translate('enterApp');
  String get language => _translate('language');
  String get arabic => _translate('arabic');
  String get english => _translate('english');
  String get switchLanguage => _translate('switchLanguage');
  String get chooseLanguage => _translate('chooseLanguage');
  String get homeTitle => _translate('homeTitle');
  String get homeWelcome => _translate('homeWelcome');
  String get homeDescription => _translate('homeDescription');
  String get todoTitle => _translate('todoTitle');
  String get pomodoroTitle => _translate('pomodoroTitle');
  String get resetGatewayButton => _translate('resetGatewayButton');
  String get resetGatewaySuccess => _translate('resetGatewaySuccess');
  String get currentLanguageLabel => _translate('currentLanguageLabel');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
