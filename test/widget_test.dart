import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_zone/core/widgets/app_button.dart';
import 'package:focus_zone/core/widgets/duration_adjuster_tile.dart';
import 'package:focus_zone/features/gateway/presentation/user_gateway_screen.dart';
import 'package:focus_zone/main.dart';

void main() {
  testWidgets('App loads gateway screen when hasSeenGateway is false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(hasSeenGateway: false));
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(UserGatewayScreen), findsOneWidget);
  });

  testWidgets('AppButton renders label and triggers callback', (
    WidgetTester tester,
  ) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Start Focusing',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Start Focusing'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(pressed, isTrue);
  });

  testWidgets('DurationAdjusterTile increments and decrements value', (
    WidgetTester tester,
  ) async {
    var currentValue = 25;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return DurationAdjusterTile(
                title: 'Focus Duration',
                value: currentValue,
                min: 1,
                max: 90,
                color: Colors.blue,
                onChanged: (val) => setState(() => currentValue = val),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('25'), findsOneWidget);
    expect(find.text('Focus Duration'), findsOneWidget);

    // Tap increase
    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pump();
    expect(currentValue, 26);

    // Tap decrease
    await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
    await tester.pump();
    expect(currentValue, 25);
  });
}
