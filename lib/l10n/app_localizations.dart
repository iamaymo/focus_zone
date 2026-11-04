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
      // Settings strings
      'settings': 'الإعدادات',
      'defaultTimerSettings': 'إعدادات المؤقت الافتراضية',
      'defaultTimerDesc': 'تعديل مدة التركيز والاستراحات',
      'languageSettings': 'اللغة',
      'languageDesc': 'تغيير لغة التطبيق',
      'themeSettings': 'المظهر والألوان',
      'themeDesc': 'الوضع الليلي والألوان والخطوط',
      'aboutApp': 'حول التطبيق',
      'aboutDesc': 'المعلومات والتراخيص',
      'dataManagement': 'إدارة البيانات',
      'dataManagementDesc': 'حذف المهام وإعادة ضبط التطبيق',
      // Theme screen
      'appearance': 'المظهر',
      'darkMode': 'الوضع الليلي',
      'lightMode': 'الوضع النهاري',
      'accentColor': 'لون التمييز',
      'font': 'الخط',
      'defaultFont': 'الخط الافتراضي',
      // About screen
      'appVersion': 'الإصدار',
      'developer': 'المطوّر',
      'githubProfile': 'حساب GitHub',
      'license': 'الترخيص',
      'licensesPage': 'تراخيص المكتبات',
      'appDescription':
          'Focus zone - تطبيق إدارة المهام ومؤقت بومودورو لمساعدتك على التركيز وزيادة الإنتاجية.',
      // Data management
      'deleteAllTasks': 'حذف جميع المهام',
      'deleteAllTasksConfirm': 'هل أنت متأكد من حذف جميع المهام؟ لا يمكن التراجع.',
      'resetApp': 'إعادة ضبط التطبيق',
      'resetAppConfirm': 'سيتم حذف جميع البيانات وإعادة التطبيق لوضعه الأولي.',
      'confirm': 'تأكيد',
      'done': 'تم',
      'taskDeleted': 'تم حذف المهمة',
      'undo': 'تراجع',
      'runningSession': 'جلسة جارية',
      'paused': 'متوقف مؤقتاً',
      'nextSession': 'الجلسة التالية',
      'breakTimeMessage': 'حان وقت أخذ استراحة قصيرة لتجديد طاقتك.',
      'focusTimeMessage': 'انتهت الاستراحة! هل أنت جاهز للعودة إلى التركيز؟',
      'skipSession': 'تخطي الجلسة',
      'mitLicenseTitle': 'ترخيص MIT',
      'mitLicenseText':
          'حقوق النشر (c) 2026 أيمن القدسي (iamaymo)\n\nيُمنح بموجب هذا إذن مجاني لأي شخص يحصل على نسخة من هذا البرنامج وملفات التوثيق المرتبطة به ("البرنامج")، للتعامل في البرنامج دون قيود، بما في ذلك دون حصر حقوق استخدام ونسخ وتعديل ودمج ونشر وتوزيع وترخيص من الباطن و/أو بيع نسخ من البرنامج، والسماح للأشخاص الذين تم تزويدهم بالبرنامج بالقيام بذلك، وفقاً للشروط التالية:\n\nيجب تضمين إشعار حقوق النشر أعلاه وإشعار الإذن هذا في جميع النسخ أو الأجزاء الجوهرية من البرنامج.\n\nيُقدم البرنامج "كما هو"، دون أي ضمان من أي نوع، صريحاً كان أم ضمنياً، بما في ذلك دون حصر ضمانات القابلية للتسويق والملاءمة لغرض معين وعدم الانتهاك. لا يتحمل المؤلفون أو أصحاب حقوق النشر بأي حال من الأحوال أي مسؤولية عن أي مطالبة أو أضرار أو التزامات أخرى تنشأ عن البرنامج أو استخدامه.',
      'close': 'إغلاق',
      'copiedToClipboard': 'تم النسخ إلى الحافظة',
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
      // Settings strings
      'settings': 'Settings',
      'defaultTimerSettings': 'Default Timer Settings',
      'defaultTimerDesc': 'Adjust focus and break durations',
      'languageSettings': 'Language',
      'languageDesc': 'Change the app language',
      'themeSettings': 'Appearance & Colors',
      'themeDesc': 'Dark mode, colors, and fonts',
      'aboutApp': 'About',
      'aboutDesc': 'Info and licenses',
      'dataManagement': 'Data Management',
      'dataManagementDesc': 'Delete tasks and reset app',
      // Theme screen
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'accentColor': 'Accent Color',
      'font': 'Font',
      'defaultFont': 'Default',
      // About screen
      'appVersion': 'Version',
      'developer': 'Developer',
      'githubProfile': 'GitHub Profile',
      'license': 'License',
      'licensesPage': 'Open Source Licenses',
      'appDescription':
          'Focus zone - A task management and Pomodoro timer app to help you stay focused and boost productivity.',
      // Data management
      'deleteAllTasks': 'Delete All Tasks',
      'deleteAllTasksConfirm':
          'Are you sure you want to delete all tasks? This cannot be undone.',
      'resetApp': 'Reset App',
      'resetAppConfirm':
          'All data will be deleted and the app will be restored to its initial state.',
      'confirm': 'Confirm',
      'done': 'Done',
      'taskDeleted': 'Task deleted',
      'undo': 'Undo',
      'runningSession': 'Running',
      'paused': 'Paused',
      'nextSession': 'Next Session',
      'breakTimeMessage': 'Time to take a short break and recharge.',
      'focusTimeMessage': 'Break is over! Ready to get back into focus?',
      'skipSession': 'Skip Session',
      'mitLicenseTitle': 'MIT License',
      'mitLicenseText':
          'Copyright (c) 2026 Ayman Al-Qadasi (iamaymo)\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
      'close': 'Close',
      'copiedToClipboard': 'Copied to clipboard',
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
  // Settings
  String get settings => _translate('settings');
  String get defaultTimerSettings => _translate('defaultTimerSettings');
  String get defaultTimerDesc => _translate('defaultTimerDesc');
  String get languageSettings => _translate('languageSettings');
  String get languageDesc => _translate('languageDesc');
  String get themeSettings => _translate('themeSettings');
  String get themeDesc => _translate('themeDesc');
  String get aboutApp => _translate('aboutApp');
  String get aboutDesc => _translate('aboutDesc');
  String get dataManagement => _translate('dataManagement');
  String get dataManagementDesc => _translate('dataManagementDesc');
  // Theme
  String get appearance => _translate('appearance');
  String get darkMode => _translate('darkMode');
  String get lightMode => _translate('lightMode');
  String get accentColor => _translate('accentColor');
  String get font => _translate('font');
  String get defaultFont => _translate('defaultFont');
  // About
  String get appVersion => _translate('appVersion');
  String get developer => _translate('developer');
  String get githubProfile => _translate('githubProfile');
  String get license => _translate('license');
  String get licensesPage => _translate('licensesPage');
  String get appDescription => _translate('appDescription');
  // Data
  String get deleteAllTasks => _translate('deleteAllTasks');
  String get deleteAllTasksConfirm => _translate('deleteAllTasksConfirm');
  String get resetApp => _translate('resetApp');
  String get resetAppConfirm => _translate('resetAppConfirm');
  String get confirm => _translate('confirm');
  String get done => _translate('done');
  String get taskDeleted => _translate('taskDeleted');
  String get undo => _translate('undo');
  String get runningSession => _translate('runningSession');
  String get paused => _translate('paused');
  String get nextSession => _translate('nextSession');
  String get breakTimeMessage => _translate('breakTimeMessage');
  String get focusTimeMessage => _translate('focusTimeMessage');
  String get skipSession => _translate('skipSession');
  String get mitLicenseTitle => _translate('mitLicenseTitle');
  String get mitLicenseText => _translate('mitLicenseText');
  String get close => _translate('close');
  String get copiedToClipboard => _translate('copiedToClipboard');
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
