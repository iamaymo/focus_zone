import 'package:flutter_test/flutter_test.dart';
import 'package:focus_zone/features/pomodoro/controllers/pomodoro_controller.dart';
import 'package:focus_zone/features/pomodoro/models/pomodoro_mode.dart';

void main() {
  group('PomodoroController Tests', () {
    late PomodoroController controller;

    setUp(() {
      controller = PomodoroController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state is focus mode with 25 minutes default', () {
      expect(controller.currentMode, PomodoroMode.focus);
      expect(controller.focusMinutes, 25);
      expect(controller.remainingSeconds, 25 * 60);
      expect(controller.isRunning, isFalse);
      expect(controller.formattedTime, '25:00');
      expect(controller.progress, 1.0);
    });

    test('Mode switching updates mode and resets remaining seconds', () {
      controller.switchMode(PomodoroMode.shortBreak);
      expect(controller.currentMode, PomodoroMode.shortBreak);
      expect(controller.remainingSeconds, 5 * 60);
      expect(controller.formattedTime, '05:00');

      controller.switchMode(PomodoroMode.longBreak);
      expect(controller.currentMode, PomodoroMode.longBreak);
      expect(controller.remainingSeconds, 15 * 60);
      expect(controller.formattedTime, '15:00');
    });

    test('skipSession toggles between focus and break', () {
      controller.skipSession();
      expect(controller.currentMode, PomodoroMode.shortBreak);

      controller.skipSession();
      expect(controller.currentMode, PomodoroMode.focus);
    });

    test('updateDurations adjusts configured minutes and remaining seconds', () {
      controller.updateDurations(
        focus: 30,
        shortBreak: 10,
        longBreak: 20,
      );

      expect(controller.focusMinutes, 30);
      expect(controller.shortBreakMinutes, 10);
      expect(controller.longBreakMinutes, 20);
      expect(controller.remainingSeconds, 30 * 60);
      expect(controller.formattedTime, '30:00');
    });
  });
}

