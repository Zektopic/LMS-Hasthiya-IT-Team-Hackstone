import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/studies/crane/model/destination.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/gallery_localizations.dart';

void main() {
  testWidgets('FlyDestination test', (WidgetTester tester) async {
    final dest = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Semantic Label',
      stops: 1,
      duration: Duration(hours: 5),
    );

    expect(dest.id, 1);
    expect(dest.destination, 'Test Destination');
    expect(dest.assetSemanticLabel, 'Test Semantic Label');
    expect(dest.stops, 1);
    expect(dest.duration, Duration(hours: 5));
    expect(dest.assetName, 'crane/destinations/fly_1.jpg');
    expect(dest.toString(), 'Test Destination (id=1)');
    expect(dest.imageAspectRatio, 1);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: ModelBinding(
          initialModel: GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.ltr,
            locale: Locale('en', 'US'),
            timeDilation: 1.0,
            platform: TargetPlatform.android,
            isTestMode: true,
          ),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Text(dest.subtitle(context)),
                  Text(dest.subtitleSemantics(context), key: Key('semantics')),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('1 stop · 5h 0m'), findsOneWidget);
    expect(find.text('1 stop, 5h 0m'), findsOneWidget);
  });

  testWidgets('FlyDestination subtitle with null duration', (WidgetTester tester) async {
    final dest = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Semantic Label',
      stops: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: ModelBinding(
          initialModel: GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.ltr,
            locale: Locale('en', 'US'),
            timeDilation: 1.0,
            platform: TargetPlatform.android,
            isTestMode: true,
          ),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Text(dest.subtitle(context)),
                  Text(dest.subtitleSemantics(context), key: Key('semantics')),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Nonstop'), findsNWidgets(2)); // Both subtitle and subtitleSemantics should return this
  });

  testWidgets('FlyDestination subtitle RTL test', (WidgetTester tester) async {
    final dest = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Semantic Label',
      stops: 1,
      duration: Duration(hours: 5),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: ModelBinding(
          initialModel: GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.rtl, // RTL testing
            locale: Locale('ar', 'AE'), // Arabic
            timeDilation: 1.0,
            platform: TargetPlatform.android,
            isTestMode: true,
          ),
          child: Builder(
            builder: (context) {
              return Text(dest.subtitle(context));
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final textWidget = tester.firstWidget(find.byType(Text)) as Text;
    expect(textWidget.data, contains('·'));
  });


  testWidgets('SleepDestination test', (WidgetTester tester) async {
    final dest = SleepDestination(
      id: 2,
      destination: 'Test Sleep Destination',
      assetSemanticLabel: 'Test Semantic Label 2',
      total: 3,
    );

    expect(dest.id, 2);
    expect(dest.destination, 'Test Sleep Destination');
    expect(dest.assetSemanticLabel, 'Test Semantic Label 2');
    expect(dest.total, 3);
    expect(dest.assetName, 'crane/destinations/sleep_2.jpg');
    expect(dest.toString(), 'Test Sleep Destination (id=2)');
    expect(dest.imageAspectRatio, 1);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Column(
              children: [
                Text(dest.subtitle(context)),
                Text(dest.subtitleSemantics(context), key: Key('semantics')),
              ],
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('3 Available Properties'), findsNWidgets(2)); // Both subtitle and subtitleSemantics
  });

  testWidgets('EatDestination test', (WidgetTester tester) async {
    final dest = EatDestination(
      id: 3,
      destination: 'Test Eat Destination',
      assetSemanticLabel: 'Test Semantic Label 3',
      total: 5,
    );

    expect(dest.id, 3);
    expect(dest.destination, 'Test Eat Destination');
    expect(dest.assetSemanticLabel, 'Test Semantic Label 3');
    expect(dest.total, 5);
    expect(dest.assetName, 'crane/destinations/eat_3.jpg');
    expect(dest.toString(), 'Test Eat Destination (id=3)');
    expect(dest.imageAspectRatio, 1);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Column(
              children: [
                Text(dest.subtitle(context)),
                Text(dest.subtitleSemantics(context), key: Key('semantics')),
              ],
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('5 Restaurants'), findsNWidgets(2)); // Both subtitle and subtitleSemantics
  });
}
