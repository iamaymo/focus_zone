import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/theme_controller.dart';

/// Settings page for customizing dark mode, accent colors, and app typography.
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.themeSettings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: ThemeController.instance,
        builder: (context, _) {
          final themeCtrl = ThemeController.instance;
          final isDark = themeCtrl.themeMode == ThemeMode.dark;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Dark / Light mode toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: colors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.appearance,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isDark ? loc.darkMode : loc.lightMode,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDark,
                      activeThumbColor: colors.primary,
                      onChanged: (_) => themeCtrl.toggleThemeMode(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Accent color selector
              Text(
                loc.accentColor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(ThemeController.accentColors.length, (
                  index,
                ) {
                  final color = ThemeController.accentColors[index];
                  final isSelected = themeCtrl.accentColorIndex == index;
                  final names = loc.isArabic
                      ? ThemeController.accentColorNamesAr
                      : ThemeController.accentColorNames;

                  return GestureDetector(
                    onTap: () => themeCtrl.setAccentColor(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? colors.onSurface
                              : Colors.transparent,
                          width: isSelected ? 3 : 0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 28,
                            )
                          : Tooltip(
                              message: names[index],
                              child: const SizedBox(),
                            ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Font selector
              Text(
                loc.font,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ...ThemeController.fontFamilies.map((fontName) {
                final isSelected = themeCtrl.fontFamily == fontName;
                final displayName = fontName == 'default'
                    ? loc.defaultFont
                    : fontName;

                return Card(
                  elevation: isSelected ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      displayName,
                      style: TextStyle(
                        fontFamily: fontName == 'default' ? null : fontName,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: colors.primary,
                          )
                        : null,
                    onTap: () => themeCtrl.setFontFamily(fontName),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

