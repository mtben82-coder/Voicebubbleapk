import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voicebubble/main.dart';

void main() {
  testWidgets('VoiceBubble app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const VoiceBubbleApp());

    // Verify that app starts
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
