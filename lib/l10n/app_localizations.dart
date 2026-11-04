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
          'مساحتك المثالية لإنجاز المهام وزيادة التركيز بمؤقت بومودورو.',
      'todoTitle': 'قائمة المهام',
      'pomodoroTitle': 'مؤقت بومودورو',
      'resetGatewayButton': 'إعادة ظهور صفحة البداية (للتجربة)',
      'resetGatewaySuccess':
          'تمت إعادة الضبط! عند إغلاق التطبيق وإعادة فتحه ستظهر صفحة البداية مجدداً.',
      'currentLanguageLabel': 'اللغة الحالية',
      'all': 'الكل',
      'high': 'عالية',
      'medium': 'متوسطة',
      'low': 'منخفضة',
      'addTask': 'إضافة مهمة جديدة',
      'editTask': 'تعديل المهمة',
      'taskTitle': 'عنوان المهمة',
      'taskTitleHint': 'ما الذي تريد إنجازه؟',
      'priority': 'الأهمية',
      'isCompleted': 'المهمة منتهية / مكتملة',
      'save': 'حفظ التعديلات',
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'noTasks': 'لا توجد مهام في هذا التصنيف',
      'emptyTasksHelp': 'أضف مهمتك الأولى وابدأ التركيز!',
      'search': 'بحث',
      'searchHint': 'ابحث في المهام...',
      'focusSession': 'جلسة تركيز',
      'shortBreak': 'استراحة قصيرة',
      'longBreak': 'استراحة طويلة',
      'start': 'بدء',
      'pause': 'إيقاف مؤقت',
      'resume': 'استئناف',
      'reset': 'إعادة ضبط',
      'customizeTimers': 'تعديل المؤقتات',
      'focusMinutes': 'مدة التركيز (بالدقائق)',
      'shortBreakMinutes': 'استراحة قصيرة (دقائق)',
      'longBreakMinutes': 'استراحة طويلة (دقائق)',
      'sessionCompleted': 'أحسنت! انتهت الجلسة.',
      'workingOn': 'التركيز على مهمة:',
      'generalFocus': 'جلسة تركيز عامة',
      'markTaskAsDone': 'تحديد المهمة كمنتهية',
      'taskDone': 'مكتملة',
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
          'Your dedicated space to conquer tasks and maximize focus with Pomodoro timer.',
      'todoTitle': 'To-Do List',
      'pomodoroTitle': 'Pomodoro Timer',
      'resetGatewayButton': 'Reset Gateway Screen (For Testing)',
      'resetGatewaySuccess':
          'Reset successful! The gateway screen will appear on the next app launch.',
      'currentLanguageLabel': 'Current Language',
      'all': 'All',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'addTask': 'Add New Task',
      'editTask': 'Edit Task',
      'taskTitle': 'Task Title',
      'taskTitleHint': 'What do you want to achieve?',
      'priority': 'Priority',
      'isCompleted': 'Completed / Done',
      'save': 'Save Changes',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'noTasks': 'No tasks in this category',
      'emptyTasksHelp': 'Add your first task and start focusing!',
      'search': 'Search',
      'searchHint': 'Search tasks...',
      'focusSession': 'Focus Session',
      'shortBreak': 'Short Break',
      'longBreak': 'Long Break',
      'start': 'Start',
      'pause': 'Pause',
      'resume': 'Resume',
      'reset': 'Reset',
      'customizeTimers': 'Customize Timers',
      'focusMinutes': 'Focus Duration (minutes)',
      'shortBreakMinutes': 'Short Break (minutes)',
      'longBreakMinutes': 'Long Break (minutes)',
      'sessionCompleted': 'Well done! Session completed.',
      'workingOn': 'Focusing on task:',
      'generalFocus': 'General Focus Session',
      'markTaskAsDone': 'Mark Task as Done',
      'taskDone': 'Completed',
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
  String get all => _translate('all');
  String get high => _translate('high');
  String get medium => _translate('medium');
  String get low => _translate('low');
  String get addTask => _translate('addTask');
  String get editTask => _translate('editTask');
  String get taskTitle => _translate('taskTitle');
  String get taskTitleHint => _translate('taskTitleHint');
  String get priority => _translate('priority');
  String get isCompleted => _translate('isCompleted');
  String get save => _translate('save');
  String get delete => _translate('delete');
  String get cancel => _translate('cancel');
  String get noTasks => _translate('noTasks');
  String get emptyTasksHelp => _translate('emptyTasksHelp');
  String get search => _translate('search');
  String get searchHint => _translate('searchHint');
  String get focusSession => _translate('focusSession');
  String get shortBreak => _translate('shortBreak');
  String get longBreak => _translate('longBreak');
  String get start => _translate('start');
  String get pause => _translate('pause');
  String get resume => _translate('resume');
  String get reset => _translate('reset');
  String get customizeTimers => _translate('customizeTimers');
  String get focusMinutes => _translate('focusMinutes');
  String get shortBreakMinutes => _translate('shortBreakMinutes');
  String get longBreakMinutes => _translate('longBreakMinutes');
  String get sessionCompleted => _translate('sessionCompleted');
  String get workingOn => _translate('workingOn');
  String get generalFocus => _translate('generalFocus');
  String get markTaskAsDone => _translate('markTaskAsDone');
  String get taskDone => _translate('taskDone');
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
