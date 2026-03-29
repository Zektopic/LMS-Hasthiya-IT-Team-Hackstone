import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/core/glass_widgets.dart';

void main() {
  testWidgets('GlassButton shows CircularProgressIndicator when isLoading is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassButton(
            onPressed: () {},
            isLoading: true,
            child: const Text('Sign In'),
          ),
        ),
      ),
    );

    // Verify loading indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify Semantics label 'Loading' is present
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);

    // Verify child text is NOT present
    expect(find.text('Sign In'), findsNothing);
  });

  testWidgets('GlassButton shows child when isLoading is false', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassButton(
            onPressed: () {},
            isLoading: false,
            child: const Text('Sign In'),
          ),
        ),
      ),
    );

    // Verify loading indicator is NOT present
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify child text is present
    expect(find.text('Sign In'), findsOneWidget);
  });
}
