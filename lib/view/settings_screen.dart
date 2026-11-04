import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/locale_controller.dart';
import '../services/theme_controller.dart';
import '../services/timer_settings_service.dart';
import '../services/task_service.dart';
import '../services/preferences_service.dart';

// ─────────────────────────────────────────────
//  Main Settings Screen
// ─────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          _SettingsTile(
            icon: Icons.timer_outlined,
            iconColor: colors.primary,
            title: loc.defaultTimerSettings,
            subtitle: loc.defaultTimerDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _TimerSettingsPage()),
            ),
          ),
          _SettingsTile(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xff6a1b9a),
            title: loc.themeSettings,
            subtitle: loc.themeDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _ThemeSettingsPage()),
            ),
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xff1565c0),
            title: loc.languageSettings,
            subtitle: loc.languageDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _LanguageSettingsPage()),
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          _SettingsTile(
            icon: Icons.storage_outlined,
            iconColor: const Color(0xffc62828),
            title: loc.dataManagement,
            subtitle: loc.dataManagementDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _DataManagementPage()),
            ),
          ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xff00838f),
            title: loc.aboutApp,
            subtitle: loc.aboutDesc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _AboutPage()),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared tile widget
// ─────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: colors.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colors.onSurface.withValues(alpha: 0.4),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

// ─────────────────────────────────────────────
//  1. Default Timer Settings Page
// ─────────────────────────────────────────────
class _TimerSettingsPage extends StatefulWidget {
  const _TimerSettingsPage();

  @override
  State<_TimerSettingsPage> createState() => _TimerSettingsPageState();
}

class _TimerSettingsPageState extends State<_TimerSettingsPage> {
  late int _focus;
  late int _shortBreak;
  late int _longBreak;

  @override
  void initState() {
    super.initState();
    final s = TimerSettingsService.instance;
    _focus = s.focusMinutes;
    _shortBreak = s.shortBreakMinutes;
    _longBreak = s.longBreakMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.defaultTimerSettings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDurationAdjuster(
              title: loc.focusMinutes,
              value: _focus,
              min: 1,
              max: 90,
              color: colors.primary,
              onChanged: (v) => setState(() => _focus = v),
            ),
            const SizedBox(height: 14),
            _buildDurationAdjuster(
              title: loc.shortBreakMinutes,
              value: _shortBreak,
              min: 1,
              max: 30,
              color: const Color(0xff43a047),
              onChanged: (v) => setState(() => _shortBreak = v),
            ),
            const SizedBox(height: 14),
            _buildDurationAdjuster(
              title: loc.longBreakMinutes,
              value: _longBreak,
              min: 1,
              max: 45,
              color: const Color(0xfff57c00),
              onChanged: (v) => setState(() => _longBreak = v),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await TimerSettingsService.instance.setAll(
                    focus: _focus,
                    shortBreak: _shortBreak,
                    longBreak: _longBreak,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  loc.save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationAdjuster({
    required String title,
    required int value,
    required int min,
    required int max,
    required Color color,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: color,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: color,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  2. Theme & Appearance Settings Page
// ─────────────────────────────────────────────
class _ThemeSettingsPage extends StatelessWidget {
  const _ThemeSettingsPage();

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
                      activeColor: colors.primary,
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

// ─────────────────────────────────────────────
//  3. Language Settings Page
// ─────────────────────────────────────────────
class _LanguageSettingsPage extends StatelessWidget {
  const _LanguageSettingsPage();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
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
                _LanguageOption(
                  label: 'العربية',
                  subtitle: 'Arabic',
                  isSelected: ctrl.isArabic,
                  onTap: () => ctrl.setLocale(const Locale('ar')),
                ),
                const SizedBox(height: 12),
                _LanguageOption(
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

class _LanguageOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.onSurface.withValues(alpha: 0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? colors.primary
                  : colors.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  4. Data Management Page
// ─────────────────────────────────────────────
class _DataManagementPage extends StatelessWidget {
  const _DataManagementPage();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.dataManagement,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Delete all tasks
            _DangerTile(
              icon: Icons.delete_sweep_outlined,
              title: loc.deleteAllTasks,
              onTap: () => _confirmAction(
                context,
                title: loc.deleteAllTasks,
                message: loc.deleteAllTasksConfirm,
                onConfirm: () async {
                  await TaskService.instance.deleteAllTasks();
                },
              ),
            ),
            const SizedBox(height: 14),

            // Reset app (gateway + tasks)
            _DangerTile(
              icon: Icons.restore_rounded,
              title: loc.resetApp,
              onTap: () => _confirmAction(
                context,
                title: loc.resetApp,
                message: loc.resetAppConfirm,
                onConfirm: () async {
                  await TaskService.instance.deleteAllTasks();
                  await PreferencesService.resetGateway();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await onConfirm();
    }
  }
}

class _DangerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DangerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.red.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  5. About Page
// ─────────────────────────────────────────────
class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.aboutApp,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App icon / logo section
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.timer_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Focus zone',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.appDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Info cards
          _InfoCard(
            icon: Icons.numbers_rounded,
            label: loc.appVersion,
            value: '1.0',
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.person_outline_rounded,
            label: loc.developer,
            value: 'Ayman Al-Qadasi',
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.code_rounded,
            label: loc.githubProfile,
            value: 'github.com/iamaymo',
            trailingIcon: Icons.open_in_new_rounded,
            onTap: () => _openGitHub(context),
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.description_outlined,
            label: loc.license,
            value: 'MIT License',
            trailingIcon: Icons.chevron_right_rounded,
            onTap: () => _showLicenseDetails(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openGitHub(BuildContext context) async {
    final uri = Uri.parse('https://github.com/iamaymo');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('https://github.com/iamaymo'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showLicenseDetails(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22),
        actionsPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_outlined,
                color: colors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.mitLicenseTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Focus zone • iamaymo',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 340),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.onSurface.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.08),
              ),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                loc.mitLicenseText,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.55,
                  color: colors.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: loc.mitLicenseText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.copiedToClipboard),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: Text(loc.isArabic ? 'نسخ' : 'Copy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(loc.close),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? trailingIcon;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isClickable = onTap != null;

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isClickable
              ? colors.primary.withValues(alpha: 0.25)
              : colors.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isClickable ? colors.primary : colors.onSurface,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 18,
              color: colors.primary,
            ),
          ],
        ],
      ),
    );

    if (isClickable) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: content,
        ),
      );
    }

    return content;
  }
}
