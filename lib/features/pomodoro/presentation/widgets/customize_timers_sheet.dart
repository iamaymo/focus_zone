import 'package:flutter/material.dart';

import '../../../../core/widgets/duration_adjuster_tile.dart';
import '../../../../l10n/app_localizations.dart';

/// Modal bottom sheet allowing temporary customization of Pomodoro durations.
class CustomizeTimersSheet extends StatefulWidget {
  final int initialFocus;
  final int initialShortBreak;
  final int initialLongBreak;
  final void Function(int focus, int shortBreak, int longBreak) onSave;

  const CustomizeTimersSheet({
    super.key,
    required this.initialFocus,
    required this.initialShortBreak,
    required this.initialLongBreak,
    required this.onSave,
  });

  /// Helper method to display this sheet.
  static Future<void> show(
    BuildContext context, {
    required int initialFocus,
    required int initialShortBreak,
    required int initialLongBreak,
    required void Function(int focus, int shortBreak, int longBreak) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomizeTimersSheet(
        initialFocus: initialFocus,
        initialShortBreak: initialShortBreak,
        initialLongBreak: initialLongBreak,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CustomizeTimersSheet> createState() => _CustomizeTimersSheetState();
}

class _CustomizeTimersSheetState extends State<CustomizeTimersSheet> {
  late int _tempFocus;
  late int _tempShort;
  late int _tempLong;

  @override
  void initState() {
    super.initState();
    _tempFocus = widget.initialFocus;
    _tempShort = widget.initialShortBreak;
    _tempLong = widget.initialLongBreak;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            loc.customizeTimers,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Focus Slider
          DurationAdjusterTile(
            title: loc.focusMinutes,
            value: _tempFocus,
            min: 1,
            max: 90,
            color: colors.primary,
            onChanged: (val) => setState(() => _tempFocus = val),
          ),

          const SizedBox(height: 12),

          // Short Break Slider
          DurationAdjusterTile(
            title: loc.shortBreakMinutes,
            value: _tempShort,
            min: 1,
            max: 30,
            color: const Color(0xff43a047),
            onChanged: (val) => setState(() => _tempShort = val),
          ),

          const SizedBox(height: 12),

          // Long Break Slider
          DurationAdjusterTile(
            title: loc.longBreakMinutes,
            value: _tempLong,
            min: 1,
            max: 45,
            color: const Color(0xfff57c00),
            onChanged: (val) => setState(() => _tempLong = val),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              widget.onSave(_tempFocus, _tempShort, _tempLong);
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
        ],
      ),
    );
  }
}

