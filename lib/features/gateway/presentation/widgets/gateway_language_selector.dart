import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/locale_controller.dart';

/// Language switcher pill with icon and Arabic/English toggle buttons.
class GatewayLanguageSelector extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isArabic;

  const GatewayLanguageSelector({
    super.key,
    required this.colorScheme,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: loc.chooseLanguage,
      button: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.22),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Language Icon
            IconButton(
              icon: Icon(
                Icons.language_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              tooltip: loc.switchLanguage,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              onPressed: () {
                LocaleController.instance.toggleLocale();
              },
            ),
            const SizedBox(width: 4),

            // Arabic Option
            InkWell(
              onTap: () {
                LocaleController.instance.setLocale(const Locale('ar'));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isArabic ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'العربية',
                  style: TextStyle(
                    color: isArabic
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: isArabic ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // English Option
            InkWell(
              onTap: () {
                LocaleController.instance.setLocale(const Locale('en'));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: !isArabic ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'English',
                  style: TextStyle(
                    color: !isArabic
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: !isArabic ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

