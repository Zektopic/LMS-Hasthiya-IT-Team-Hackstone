import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'test_goldens/testing/font_loader.dart';

void main() {
  testWidgets('Performance test', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();
    await loadFonts();
    print('Execution time: \${stopwatch.elapsedMilliseconds}ms');
  });
}
