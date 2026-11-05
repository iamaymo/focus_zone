import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../models/pomodoro_mode.dart';

/// Tab bar allowing user to switch between Focus, Short Break, and Long Break.
class PomodoroModeTabs extends StatelessWidget {
  final PomodoroMode currentMode;
  final Color modeColor;
  final ValueChanged<PomodoroMode> onModeSelected;

  const PomodoroModeTabs({
    super.key,
    required this.currentMode,
    required this.modeColor,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: PomodoroMode.values.map((mode) {
          final isSelected = currentMode == mode;
          return Expanded(
            child: InkWell(
              onTap: () => onModeSelected(mode),
              borderRadius: BorderRadius.circular(26),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? modeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Text(
                  mode.label(loc),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : colors.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

