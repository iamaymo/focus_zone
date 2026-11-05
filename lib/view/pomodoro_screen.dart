import 'dart:async';
import 'package:flutter/material.dart';
import '../core/widgets/duration_adjuster_tile.dart';
import '../l10n/app_localizations.dart';
import '../models/task_item.dart';
import '../services/task_service.dart';
import '../services/timer_settings_service.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

class PomodoroScreen extends StatefulWidget {
  final TaskItem? task;

  const PomodoroScreen({super.key, this.task});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // Timer settings (in minutes) — initialized from defaults
  late int _focusMinutes;
  late int _shortBreakMinutes;
  late int _longBreakMinutes;

  PomodoroMode _currentMode = PomodoroMode.focus;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;

  TaskItem? _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    // Read default durations from the global settings service
    final defaults = TimerSettingsService.instance;
    _focusMinutes = defaults.focusMinutes;
    _shortBreakMinutes = defaults.shortBreakMinutes;
    _longBreakMinutes = defaults.longBreakMinutes;
    _remainingSeconds = _focusMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _totalSecondsForCurrentMode {
    switch (_currentMode) {
      case PomodoroMode.focus:
        return _focusMinutes * 60;
      case PomodoroMode.shortBreak:
        return _shortBreakMinutes * 60;
      case PomodoroMode.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  void _switchMode(PomodoroMode mode) {
    if (_currentMode == mode) return;
    _timer?.cancel();
    setState(() {
      _currentMode = mode;
      _isRunning = false;
      _remainingSeconds = _totalSecondsForCurrentMode;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
          });
          _onSessionComplete();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSecondsForCurrentMode;
    });
  }

  void _skipSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_currentMode == PomodoroMode.focus) {
        _currentMode = PomodoroMode.shortBreak;
      } else {
        _currentMode = PomodoroMode.focus;
      }
      _remainingSeconds = _totalSecondsForCurrentMode;
    });
  }

  void _onSessionComplete() {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: Colors.amber, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(loc.sessionCompleted)),
          ],
        ),
        content: Text(
          _currentMode == PomodoroMode.focus
              ? loc.breakTimeMessage
              : loc.focusTimeMessage,
        ),
        actions: [
          if (_currentTask != null && !_currentTask!.isCompleted)
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await TaskService.instance.toggleTaskCompleted(_currentTask!);
                setState(() {});
              },
              child: Text(loc.markTaskAsDone),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _skipSession();
            },
            child: Text(loc.nextSession),
          ),
        ],
      ),
    );
  }

  void _showCustomizeTimersDialog() {
    final loc = AppLocalizations.of(context);
    int tempFocus = _focusMinutes;
    int tempShort = _shortBreakMinutes;
    int tempLong = _longBreakMinutes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                    value: tempFocus,
                    min: 1,
                    max: 90,
                    color: colors.primary,
                    onChanged: (val) => setSheetState(() => tempFocus = val),
                  ),

                  const SizedBox(height: 12),

                  // Short Break Slider
                  DurationAdjusterTile(
                    title: loc.shortBreakMinutes,
                    value: tempShort,
                    min: 1,
                    max: 30,
                    color: const Color(0xff43a047),
                    onChanged: (val) => setSheetState(() => tempShort = val),
                  ),

                  const SizedBox(height: 12),

                  // Long Break Slider
                  DurationAdjusterTile(
                    title: loc.longBreakMinutes,
                    value: tempLong,
                    min: 1,
                    max: 45,
                    color: const Color(0xfff57c00),
                    onChanged: (val) => setSheetState(() => tempLong = val),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _focusMinutes = tempFocus;
                        _shortBreakMinutes = tempShort;
                        _longBreakMinutes = tempLong;
                        if (!_isRunning) {
                          _remainingSeconds = _totalSecondsForCurrentMode;
                        }
                      });
                      Navigator.pop(ctx);
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
          },
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  Color _getModeColor(ColorScheme colors) {
    switch (_currentMode) {
      case PomodoroMode.focus:
        return colors.primary;
      case PomodoroMode.shortBreak:
        return const Color(0xff43a047);
      case PomodoroMode.longBreak:
        return const Color(0xfff57c00);
    }
  }

  String _getModeLabel(AppLocalizations loc, PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.focus:
        return loc.focusSession;
      case PomodoroMode.shortBreak:
        return loc.shortBreak;
      case PomodoroMode.longBreak:
        return loc.longBreak;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final modeColor = _getModeColor(colors);

    final progress = _totalSecondsForCurrentMode > 0
        ? _remainingSeconds / _totalSecondsForCurrentMode
        : 0.0;

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
            onPressed: _showCustomizeTimersDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Task details header card
              if (_currentTask != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment_rounded,
                        color: colors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.workingOn,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentTask!.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: _currentTask!.isCompleted,
                        activeColor: colors.primary,
                        onChanged: (val) async {
                          await TaskService.instance
                              .toggleTaskCompleted(_currentTask!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt_rounded, color: colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        loc.generalFocus,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Mode Tabs: Focus | Short Break | Long Break
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: PomodoroMode.values.map((mode) {
                    final isSelected = _currentMode == mode;
                    return Expanded(
                      child: InkWell(
                        onTap: () => _switchMode(mode),
                        borderRadius: BorderRadius.circular(26),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? modeColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Text(
                            _getModeLabel(loc, mode),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : colors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 36),

              // Circular Countdown Timer
              Stack(
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
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isRunning ? loc.runningSession : loc.paused,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: modeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Control Buttons: Reset | Play/Pause | Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset
                  IconButton.filledTonal(
                    iconSize: 28,
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.replay_rounded),
                    tooltip: loc.reset,
                  ),

                  const SizedBox(width: 20),

                  // Play / Pause Main Button
                  GestureDetector(
                    onTap: _toggleTimer,
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
                        _isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Skip
                  IconButton.filledTonal(
                    iconSize: 28,
                    onPressed: _skipSession,
                    icon: const Icon(Icons.skip_next_rounded),
                    tooltip: loc.skipSession,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
