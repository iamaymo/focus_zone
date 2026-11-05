import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/locale_controller.dart';
import '../widgets/language_option_tile.dart';

/// Settings page for choosing application language (Arabic or English).
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final ctrl = LocaleController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.languageSettings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LanguageOptionTile(
                  label: 'العربية',
                  subtitle: 'Arabic',
                  isSelected: ctrl.isArabic,
                  onTap: () => ctrl.setLocale(const Locale('ar')),
                ),
                const SizedBox(height: 12),
                LanguageOptionTile(
                  label: 'English',
                  subtitle: 'الإنجليزية',
                  isSelected: !ctrl.isArabic,
                  onTap: () => ctrl.setLocale(const Locale('en')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

