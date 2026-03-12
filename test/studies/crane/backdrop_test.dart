import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/studies/crane/backdrop.dart';
import 'package:gallery/studies/crane/backlayer.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/gallery_localizations.dart';

class TestBackLayerItem extends StatefulWidget implements BackLayerItem {
  const TestBackLayerItem({super.key, required this.index});

  @override
  final int index;

  @override
  State<TestBackLayerItem> createState() => _TestBackLayerItemState();
}

class _TestBackLayerItemState extends State<TestBackLayerItem> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  testWidgets('Crane Backdrop handles tabs correctly', (WidgetTester tester) async {
    final GlobalKey backdropKey = GlobalKey();

    await tester.pumpWidget(
      ModelBinding(
        initialModel: const GalleryOptions(
          themeMode: ThemeMode.system,
          textScaleFactor: 1.0,
          customTextDirection: CustomTextDirection.localeBased,
          locale: Locale('en', 'US'),
          timeDilation: 1.0,
          platform: TargetPlatform.android,
          isTestMode: true,
        ),
        child: MaterialApp(
          localizationsDelegates: GalleryLocalizations.localizationsDelegates,
          supportedLocales: GalleryLocalizations.supportedLocales,
          home: Scaffold(
            body: Backdrop(
              key: backdropKey,
              frontLayer: const SizedBox(),
              backLayerItems: const <BackLayerItem>[
                 TestBackLayerItem(index: 0),
                 TestBackLayerItem(index: 1),
                 TestBackLayerItem(index: 2),
              ],
              frontTitle: const Text('Front'),
              backTitle: const Text('Back'),
            ),
          ),
        ),
      ),
    );

    // Let the animations finish
    await tester.pumpAndSettle();

    // Find the state
    final dynamic state = tester.state(find.byKey(backdropKey));
    expect(state.tabIndex.value, 0);

    // Get the tabs. Crane App bar has 3 tabs.
    final Finder tabs = find.byType(Tab);
    expect(tabs, findsNWidgets(3));

    // Tap second tab (index 1)
    await tester.tap(tabs.at(1));
    await tester.pumpAndSettle();

    // Verify index updated
    expect(state.tabIndex.value, 1);

    // Tap third tab (index 2)
    await tester.tap(tabs.at(2));
    await tester.pumpAndSettle();

    // Verify index updated
    expect(state.tabIndex.value, 2);
  });
}
