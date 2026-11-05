import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Available modes for the Pomodoro timer.
enum PomodoroMode { focus, shortBreak, longBreak }

/// UI and localization helpers for [PomodoroMode].
extension PomodoroModeX on PomodoroMode {
  /// Theme-aware accent color associated with this mode.
  Color color(ColorScheme colorScheme) {
    switch (this) {
      case PomodoroMode.focus:
        return colorScheme.primary;
      case PomodoroMode.shortBreak:
        return const Color(0xff43a047);
      case PomodoroMode.longBreak:
        return const Color(0xfff57c00);
    }
  }

  /// Localized display label for this mode.
  String label(AppLocalizations loc) {
    switch (this) {
      case PomodoroMode.focus:
        return loc.focusSession;
      case PomodoroMode.shortBreak:
        return loc.shortBreak;
      case PomodoroMode.longBreak:
        return loc.longBreak;
    }
  }
}

