import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_controller.dart';
import 'services/preferences_service.dart';
import 'services/task_service.dart';
import 'services/theme_controller.dart';
import 'services/timer_settings_service.dart';
import 'view/home_screen.dart';
import 'view/user_getaway.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.init();
  await TaskService.instance.init();
  await ThemeController.instance.init();
  await TimerSettingsService.instance.init();
  final hasSeenGateway = await PreferencesService.hasSeenGateway();

  runApp(MyApp(hasSeenGateway: hasSeenGateway));
}

class MyApp extends StatelessWidget {
  final bool hasSeenGateway;

  const MyApp({super.key, this.hasSeenGateway = false});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        return ListenableBuilder(
          listenable: ThemeController.instance,
          builder: (context, _) {
            final currentLocale = LocaleController.instance.locale;
            final themeCtrl = ThemeController.instance;

            return MaterialApp(
              title: "Focus zone",
              debugShowCheckedModeBanner: false,
              locale: currentLocale,
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: themeCtrl.buildLightTheme(),
              darkTheme: themeCtrl.buildDarkTheme(),
              themeMode: themeCtrl.themeMode,
              home: hasSeenGateway
                  ? const HomeScreen()
                  : const UserGatewayPage(),
            );
          },
        );
      },
    );
  }
}
