import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'pages/about_page.dart';
import 'pages/data_management_page.dart';
import 'pages/language_settings_page.dart';
import 'pages/theme_settings_page.dart';
import 'pages/timer_settings_page.dart';
import 'widgets/settings_tile.dart';

/// Main settings overview screen providing access to preferences, themes, data, and app information.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SettingsTile(
            icon: Icons.timer_outlined,
            iconColor: colors.primary,
            title: loc.defaultTimerSettings,
            subtitle: loc.defaultTimerDesc,
            onTap: () => _navigate(context, const TimerSettingsPage()),
          ),
          SettingsTile(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xff6a1b9a),
            title: loc.themeSettings,
            subtitle: loc.themeDesc,
            onTap: () => _navigate(context, const ThemeSettingsPage()),
          ),
          SettingsTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xff1565c0),
            title: loc.languageSettings,
            subtitle: loc.languageDesc,
            onTap: () => _navigate(context, const LanguageSettingsPage()),
          ),
          const Divider(indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.storage_outlined,
            iconColor: const Color(0xffc62828),
            title: loc.dataManagement,
            subtitle: loc.dataManagementDesc,
            onTap: () => _navigate(context, const DataManagementPage()),
          ),
          SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xff00838f),
            title: loc.aboutApp,
            subtitle: loc.aboutDesc,
            onTap: () => _navigate(context, const AboutPage()),
          ),
        ],
      ),
    );
  }
}

