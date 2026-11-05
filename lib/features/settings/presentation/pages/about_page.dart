import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/info_card.dart';
import '../widgets/license_dialog.dart';

/// About page detailing app version, developer information, and open source license.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
          InfoCard(
            icon: Icons.numbers_rounded,
            label: loc.appVersion,
            value: '1.0',
          ),
          const SizedBox(height: 10),
          InfoCard(
            icon: Icons.person_outline_rounded,
            label: loc.developer,
            value: 'Ayman Al-Qadasi',
          ),
          const SizedBox(height: 10),
          InfoCard(
            icon: Icons.code_rounded,
            label: loc.githubProfile,
            value: 'github.com/iamaymo',
            trailingIcon: Icons.open_in_new_rounded,
            onTap: () => _openGitHub(context),
          ),
          const SizedBox(height: 10),
          InfoCard(
            icon: Icons.description_outlined,
            label: loc.license,
            value: 'MIT License',
            trailingIcon: Icons.chevron_right_rounded,
            onTap: () => LicenseDialog.show(context),
          ),
        ],
      ),
    );
  }
}

