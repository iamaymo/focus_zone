import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Control buttons row: Reset, Play/Pause toggle, and Skip session.
class PomodoroControls extends StatelessWidget {
  final bool isRunning;
  final Color modeColor;
  final VoidCallback onReset;
  final VoidCallback onToggle;
  final VoidCallback onSkip;

  const PomodoroControls({
    super.key,
    required this.isRunning,
    required this.modeColor,
    required this.onReset,
    required this.onToggle,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset
        IconButton.filledTonal(
          iconSize: 28,
          onPressed: onReset,
          icon: const Icon(Icons.replay_rounded),
          tooltip: loc.reset,
        ),

        const SizedBox(width: 20),

        // Play / Pause Main Button
        Semantics(
          button: true,
          label: isRunning ? loc.pause : loc.start,
          child: GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: modeColor,
                boxShadow: [
                  BoxShadow(
                    color: modeColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                isRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Skip
        IconButton.filledTonal(
          iconSize: 28,
          onPressed: onSkip,
          icon: const Icon(Icons.skip_next_rounded),
          tooltip: loc.skipSession,
        ),
      ],
    );
  }
}

