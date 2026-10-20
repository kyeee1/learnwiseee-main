import 'package:flutter_test/flutter_test.dart';

import 'package:learnwise/main.dart';

void main() {
  testWidgets('shows onboarding screen and opens login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LearnWiseApp());

    expect(find.text('AI-Powered Study\nAssistant'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back! Log in to resume your learning adventure.'),
        findsOneWidget);
  });
}
