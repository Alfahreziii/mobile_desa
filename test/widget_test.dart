import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kedai/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app with isLoggedIn set to false.
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verifikasi bahwa counter dimulai dari 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap ikon '+' dan trigger frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter sudah bertambah.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
