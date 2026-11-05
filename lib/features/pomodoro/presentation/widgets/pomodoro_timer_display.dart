import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Circular progress countdown timer display with large digits and running/paused status.
class PomodoroTimerDisplay extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final bool isRunning;
  final Color modeColor;

  const PomodoroTimerDisplay({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.isRunning,
    required this.modeColor,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 12,
            backgroundColor: modeColor.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(modeColor),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isRunning ? loc.runningSession : loc.paused,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: modeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

