import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../controllers/pomodoro_controller.dart';
import '../models/pomodoro_mode.dart';
import 'widgets/customize_timers_sheet.dart';
import 'widgets/pomodoro_controls.dart';
import 'widgets/pomodoro_header_card.dart';
import 'widgets/pomodoro_mode_tabs.dart';
import 'widgets/pomodoro_timer_display.dart';
import 'widgets/session_complete_dialog.dart';

/// Screen managing and rendering the interactive Pomodoro timer session.
class PomodoroScreen extends StatefulWidget {
  final TaskItem? task;

  const PomodoroScreen({super.key, this.task});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  late final PomodoroController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PomodoroController(
      task: widget.task,
      onSessionComplete: _showSessionCompleteDialog,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSessionCompleteDialog() {
    if (!mounted) return;
    SessionCompleteDialog.show(
      context,
      currentMode: _controller.currentMode,
      task: _controller.currentTask,
      onNextSession: _controller.skipSession,
      onTaskMarkedDone: () => setState(() {}),
    );
  }

  void _showCustomizeTimers() {
    CustomizeTimersSheet.show(
      context,
      initialFocus: _controller.focusMinutes,
      initialShortBreak: _controller.shortBreakMinutes,
      initialLongBreak: _controller.longBreakMinutes,
      onSave: (focus, shortBreak, longBreak) {
        _controller.updateDurations(
          focus: focus,
          shortBreak: shortBreak,
          longBreak: longBreak,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final modeColor = _controller.currentMode.color(colors);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              loc.pomodoroTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: loc.customizeTimers,
                icon: const Icon(Icons.tune_rounded),
                onPressed: _showCustomizeTimers,
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Task Details Header Card
                  PomodoroHeaderCard(
                    task: _controller.currentTask,
                    onTaskStatusChanged: () => setState(() {}),
                  ),

                  // Mode Tabs: Focus | Short Break | Long Break
                  PomodoroModeTabs(
                    currentMode: _controller.currentMode,
                    modeColor: modeColor,
                    onModeSelected: _controller.switchMode,
                  ),

                  const SizedBox(height: 36),

                  // Circular Countdown Timer
                  PomodoroTimerDisplay(
                    progress: _controller.progress,
                    formattedTime: _controller.formattedTime,
                    isRunning: _controller.isRunning,
                    modeColor: modeColor,
                  ),

                  const SizedBox(height: 40),

                  // Control Buttons: Reset | Play/Pause | Skip
                  PomodoroControls(
                    isRunning: _controller.isRunning,
                    modeColor: modeColor,
                    onReset: _controller.resetTimer,
                    onToggle: _controller.toggleTimer,
                    onSkip: _controller.skipSession,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

