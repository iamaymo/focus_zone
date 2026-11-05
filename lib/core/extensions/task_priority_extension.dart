import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/task_item.dart';

/// Presentation extension for [TaskPriority] to consolidate colors and localization.
extension TaskPriorityX on TaskPriority {
  /// Associated color for this priority level.
  Color get color {
    switch (this) {
      case TaskPriority.high:
        return const Color(0xffe53935);
      case TaskPriority.medium:
        return const Color(0xfff57c00);
      case TaskPriority.low:
        return const Color(0xff43a047);
    }
  }

  /// Localized string for this priority level.
  String label(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case TaskPriority.high:
        return loc.high;
      case TaskPriority.medium:
        return loc.medium;
      case TaskPriority.low:
        return loc.low;
    }
  }
}

