import 'package:flutter_test/flutter_test.dart';
import 'package:focus_zone/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(hasSeenGateway: false));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
