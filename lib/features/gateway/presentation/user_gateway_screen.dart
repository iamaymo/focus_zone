import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/preferences_service.dart';
import '../../../view/home_screen.dart';
import 'widgets/floating_task_badges.dart';
import 'widgets/gateway_hero_illustration.dart';
import 'widgets/gateway_language_selector.dart';

/// Gateway welcome screen displayed on first launch.
class UserGatewayScreen extends StatefulWidget {
  const UserGatewayScreen({super.key});

  @override
  State<UserGatewayScreen> createState() => _UserGatewayScreenState();
}

class _UserGatewayScreenState extends State<UserGatewayScreen> {
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
              Color.lerp(colors.primary, Colors.black, 0.4) ??
                  const Color(0xff3a2b1f),
              colors.primary,
              Color.lerp(colors.primary, Colors.white, 0.15) ??
                  const Color(0xff7c6653),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative floating task & pomodoro background icons
            FloatingTaskBadges(colorScheme: colors),

            // Top section: Pomodoro & To-Do Hero badge
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 310,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: GatewayHeroIllustration(
                      colorScheme: colors,
                      isArabic: isArabic,
                    ),
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
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
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
                          color: colors.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Welcome Message
                      Text(
                        loc.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface,
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
                          color: colors.onSurface.withValues(alpha: 0.72),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Enter App Button
                      AppButton(
                        label: loc.enterApp,
                        backgroundColor: colors.primary,
                        textColor: colors.onPrimary,
                        icon: isArabic
                            ? Icon(
                                Icons.arrow_back_rounded,
                                color: colors.onPrimary,
                              )
                            : null,
                        trailingIcon: !isArabic
                            ? Icon(
                                Icons.arrow_forward_rounded,
                                color: colors.onPrimary,
                              )
                            : null,
                        onPressed: _enterApp,
                      ),

                      const SizedBox(height: 18),

                      // Language Switcher Icon & Selector
                      GatewayLanguageSelector(
                        colorScheme: colors,
                        isArabic: isArabic,
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
}

