import 'dart:async';
import 'package:flutter/material.dart';

import '../../../models/task_item.dart';
import '../../../services/timer_settings_service.dart';
import '../models/pomodoro_mode.dart';

/// Controller encapsulating the Pomodoro countdown ticker, state, and mode transitions.
class PomodoroController extends ChangeNotifier {
  int _focusMinutes;
  int _shortBreakMinutes;
  int _longBreakMinutes;

  PomodoroMode _currentMode = PomodoroMode.focus;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;
  TaskItem? _currentTask;

  /// Callback fired when the timer reaches 00:00.
  VoidCallback? onSessionComplete;

  PomodoroController({
    TaskItem? task,
    TimerSettingsService? settingsService,
    this.onSessionComplete,
  })  : _currentTask = task,
        _focusMinutes = (settingsService ?? TimerSettingsService.instance).focusMinutes,
        _shortBreakMinutes = (settingsService ?? TimerSettingsService.instance).shortBreakMinutes,
        _longBreakMinutes = (settingsService ?? TimerSettingsService.instance).longBreakMinutes {
    _remainingSeconds = _focusMinutes * 60;
  }

  int get focusMinutes => _focusMinutes;
  int get shortBreakMinutes => _shortBreakMinutes;
  int get longBreakMinutes => _longBreakMinutes;
  PomodoroMode get currentMode => _currentMode;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  TaskItem? get currentTask => _currentTask;

  int get totalSecondsForCurrentMode {
    switch (_currentMode) {
      case PomodoroMode.focus:
        return _focusMinutes * 60;
      case PomodoroMode.shortBreak:
        return _shortBreakMinutes * 60;
      case PomodoroMode.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  double get progress {
    if (totalSecondsForCurrentMode <= 0) return 0.0;
    return _remainingSeconds / totalSecondsForCurrentMode;
  }

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  void switchMode(PomodoroMode mode) {
    if (_currentMode == mode) return;
    _timer?.cancel();
    _currentMode = mode;
    _isRunning = false;
    _remainingSeconds = totalSecondsForCurrentMode;
    notifyListeners();
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    } else {
      _isRunning = true;
      notifyListeners();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          notifyListeners();
          onSessionComplete?.call();
        }
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = totalSecondsForCurrentMode;
    notifyListeners();
  }

  void skipSession() {
    _timer?.cancel();
    _isRunning = false;
    if (_currentMode == PomodoroMode.focus) {
      _currentMode = PomodoroMode.shortBreak;
    } else {
      _currentMode = PomodoroMode.focus;
    }
    _remainingSeconds = totalSecondsForCurrentMode;
    notifyListeners();
  }

  void updateDurations({
    required int focus,
    required int shortBreak,
    required int longBreak,
  }) {
    _focusMinutes = focus;
    _shortBreakMinutes = shortBreak;
    _longBreakMinutes = longBreak;
    if (!_isRunning) {
      _remainingSeconds = totalSecondsForCurrentMode;
    }
    notifyListeners();
  }

  void updateTask(TaskItem? task) {
    _currentTask = task;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

