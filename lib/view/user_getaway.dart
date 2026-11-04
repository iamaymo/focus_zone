import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_controller.dart';
import '../services/preferences_service.dart';
import 'home_screen.dart';

class UserGatewayPage extends StatefulWidget {
  const UserGatewayPage({super.key});

  @override
  State<UserGatewayPage> createState() => _UserGatewayPageState();
}

class _UserGatewayPageState extends State<UserGatewayPage> {
  bool _isNavigating = false;

  Future<void> _enterApp() async {
    if (_isNavigating) return;
    setState(() {
      _isNavigating = true;
    });

    // Save the flag so this screen only shows once after install
    await PreferencesService.setGatewaySeen(true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final loc = AppLocalizations.of(context);
    final isArabic = loc.isArabic;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff3a2b1f),
              colors.primary,
              const Color(0xff7c6653),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative floating task & pomodoro background icons
            ..._buildFloatingTaskIcons(colors),

            // Top section: Pomodoro & To-Do Hero badge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 310,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: _buildHeroIllustration(colors, isArabic),
                  ),
                ),
              ),
            ),

            // Bottom card with welcome message, enter button, and language selector
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.98),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.secondary.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Grab handle
                      Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: colors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Welcome Message (رسالة ترحيبية)
                      Text(
                        loc.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.secondary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.secondary.withValues(alpha: 0.72),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Enter App Button (زر دخول للتطبيق)
                      MyButton(
                        label: loc.enterApp,
                        backgroundColor: colors.primary,
                        textColor: colors.onPrimary,
                        icon: Icon(
                          isArabic
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          color: colors.onPrimary,
                        ),
                        onPressed: _enterApp,
                      ),

                      const SizedBox(height: 18),

                      // Language Switcher Icon & Selector (وتحته ايقونة اختيار اللغة عربي او انجليزي)
                      Semantics(
                        label: loc.chooseLanguage,
                        button: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.22),
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
                                  color: colors.primary,
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
                                  LocaleController.instance
                                      .setLocale(const Locale('ar'));
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isArabic
                                        ? colors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "العربية",
                                    style: TextStyle(
                                      color: isArabic
                                          ? colors.onPrimary
                                          : colors.secondary,
                                      fontWeight: isArabic
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 4),

                              // English Option
                              InkWell(
                                onTap: () {
                                  LocaleController.instance
                                      .setLocale(const Locale('en'));
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isArabic
                                        ? colors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "English",
                                    style: TextStyle(
                                      color: !isArabic
                                          ? colors.onPrimary
                                          : colors.secondary,
                                      fontWeight: !isArabic
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Scattered floating decorative icons representing tasks, timers, and focus
  List<Widget> _buildFloatingTaskIcons(ColorScheme colors) {
    final iconColor = colors.onPrimary;

    final iconsData = [
      _IconBadge(
        top: 40,
        left: 24,
        icon: Icons.checklist_rounded,
        size: 34,
        opacity: 0.16,
        angle: -0.2,
      ),
      _IconBadge(
        top: 75,
        right: 32,
        icon: Icons.timer_outlined,
        size: 38,
        opacity: 0.20,
        angle: 0.25,
      ),
      _IconBadge(
        top: 155,
        left: 36,
        icon: Icons.check_circle_outline_rounded,
        size: 30,
        opacity: 0.15,
        angle: 0.15,
      ),
      _IconBadge(
        top: 180,
        right: 30,
        icon: Icons.hourglass_top_rounded,
        size: 32,
        opacity: 0.18,
        angle: -0.18,
      ),
      _IconBadge(
        top: 260,
        left: 45,
        icon: Icons.track_changes_rounded,
        size: 28,
        opacity: 0.14,
        angle: 0.1,
      ),
      _IconBadge(
        top: 275,
        right: 50,
        icon: Icons.alarm_on_rounded,
        size: 30,
        opacity: 0.16,
        angle: -0.15,
      ),
    ];

    return iconsData.map((data) {
      return Positioned(
        top: data.top,
        left: data.left,
        right: data.right,
        child: Transform.rotate(
          angle: data.angle,
          child: Icon(
            data.icon,
            size: data.size,
            color: iconColor.withValues(alpha: data.opacity),
          ),
        ),
      );
    }).toList();
  }

  /// Central illustration highlighting the Pomodoro timer and task checklist
  Widget _buildHeroIllustration(ColorScheme colors, bool isArabic) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer glowing ring
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.onPrimary.withValues(alpha: 0.08),
                border: Border.all(
                  color: colors.onPrimary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),

            // Middle ring
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.onPrimary.withValues(alpha: 0.14),
              ),
            ),

            // Center Pomodoro Timer icon and text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_rounded,
                  size: 46,
                  color: colors.onPrimary,
                ),
                const SizedBox(height: 2),
                Text(
                  "25:00",
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            // Floating Top Chip: "Task Done"
            Positioned(
              top: -8,
              right: isArabic ? null : -24,
              left: isArabic ? -24 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xff81c784),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? "إنجاز المهام" : "Tasks Done",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Bottom Chip: "Focus Session"
            Positioned(
              bottom: -8,
              left: isArabic ? null : -20,
              right: isArabic ? -20 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xffffb74d),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? "تركيز بومودورو" : "Focus Mode",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Brand Title Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: colors.onPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Focus zone",
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBadge {
  final double? top;
  final double? left;
  final double? right;
  final IconData icon;
  final double size;
  final double opacity;
  final double angle;

  const _IconBadge({
    this.top,
    this.left,
    this.right,
    required this.icon,
    required this.size,
    required this.opacity,
    required this.angle,
  });
}
