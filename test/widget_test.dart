// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inisa_app/config/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test('testFunction', () async {
    bool func(String words) {
      for (int i = 0; i < words.length; i++) {
        debugPrint(words.substring(i, words.length - (words.length - i)));
      }
      return true;
    }

    var result = func("words");
    expect(result, true);
  });

  test('testFunction2', () async {
    String token = "123456789012";
    int i = 0;
    String helper = "";
    for (i = 0; i < token.length; i++) {
      if (i != 0) {
        if (i % 4 == 0) {
          helper += "-${token[i]}";
        } else {
          helper += "${token[i]}";
        }
      } else {
        helper += "${token[i]}";
      }
    }
    debugPrint("result: $helper");
    // expect(result, true);
  });
}
