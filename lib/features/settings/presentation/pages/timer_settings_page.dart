import 'package:flutter/material.dart';

import '../../../../core/widgets/duration_adjuster_tile.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/timer_settings_service.dart';

/// Settings page for configuring default Pomodoro focus and break durations.
class TimerSettingsPage extends StatefulWidget {
  const TimerSettingsPage({super.key});

  @override
  State<TimerSettingsPage> createState() => _TimerSettingsPageState();
}

class _TimerSettingsPageState extends State<TimerSettingsPage> {
  late int _focus;
  late int _shortBreak;
  late int _longBreak;

  @override
  void initState() {
    super.initState();
    final service = TimerSettingsService.instance;
    _focus = service.focusMinutes;
    _shortBreak = service.shortBreakMinutes;
    _longBreak = service.longBreakMinutes;
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
            DurationAdjusterTile(
              title: loc.focusMinutes,
              value: _focus,
              min: 1,
              max: 90,
              color: colors.primary,
              onChanged: (v) => setState(() => _focus = v),
            ),
            const SizedBox(height: 14),
            DurationAdjusterTile(
              title: loc.shortBreakMinutes,
              value: _shortBreak,
              min: 1,
              max: 30,
              color: const Color(0xff43a047),
              onChanged: (v) => setState(() => _shortBreak = v),
            ),
            const SizedBox(height: 14),
            DurationAdjusterTile(
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
}

