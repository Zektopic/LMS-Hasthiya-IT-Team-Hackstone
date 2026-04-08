import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/views/my_learning/my_learning_view.dart';

void main() {
  testWidgets('MyLearningView tabs interaction updates empty state', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: MyLearningView(),
      ),
    ));

    // Verify initial state (In Progress tab)
    expect(find.text('Start Learning'), findsOneWidget);
    expect(find.text('Your enrolled courses and progress\nwill appear here.'), findsOneWidget);
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Tap the 'Completed' tab
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    // Verify updated state for Completed tab
    expect(find.text('No Completed Courses'), findsOneWidget);
    expect(find.text('Keep learning! Your completed\ncourses will appear here.'), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);

    // Tap the 'Saved' tab
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();

    // Verify updated state for Saved tab
    expect(find.text('No Saved Courses'), findsOneWidget);
    expect(find.text('Save courses you are interested in\nto find them quickly later.'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
  });
}
