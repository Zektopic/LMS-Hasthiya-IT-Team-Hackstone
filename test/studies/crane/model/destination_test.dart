import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/studies/crane/model/destination.dart';
import 'package:gallery/gallery_localizations.dart';
import 'package:gallery/data/gallery_options.dart';

void main() {
  test('FlyDestination getters and subtitle methods', () {
    const destination = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Asset Label',
      stops: 2,
    );

    expect(destination.id, 1);
    expect(destination.destination, 'Test Destination');
    expect(destination.assetSemanticLabel, 'Test Asset Label');
    expect(destination.stops, 2);
    expect(destination.imageAspectRatio, 1);
    expect(destination.duration, isNull);
    expect(destination.assetName, 'crane/destinations/fly_1.jpg');
    expect(destination.toString(), 'Test Destination (id=1)');
  });

  testWidgets('FlyDestination subtitle and subtitleSemantics with no duration', (WidgetTester tester) async {
    const destination = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Asset Label',
      stops: 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: Builder(
          builder: (BuildContext context) {
            final subtitle = destination.subtitle(context);
            final subtitleSemantics = destination.subtitleSemantics(context);

            expect(subtitle, '2 stops');
            expect(subtitleSemantics, '2 stops');

            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('FlyDestination subtitle and subtitleSemantics with duration', (WidgetTester tester) async {
    const destination = FlyDestination(
      id: 1,
      destination: 'Test Destination',
      assetSemanticLabel: 'Test Asset Label',
      stops: 2,
      duration: Duration(hours: 10, minutes: 15),
    );

    await tester.pumpWidget(
      ModelBinding(
        initialModel: const GalleryOptions(
          themeMode: ThemeMode.system,
          textScaleFactor: 1.0,
          customTextDirection: CustomTextDirection.ltr,
          locale: Locale('en', 'US'),
          timeDilation: 1.0,
          platform: TargetPlatform.android,
          isTestMode: true,
        ),
        child: MaterialApp(
          localizationsDelegates: GalleryLocalizations.localizationsDelegates,
          supportedLocales: GalleryLocalizations.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              final subtitle = destination.subtitle(context);
              final subtitleSemantics = destination.subtitleSemantics(context);

              expect(subtitle, '2 stops · 10h 15m');
              expect(subtitleSemantics, '2 stops, 10h 15m');

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  });

  test('SleepDestination getters', () {
    const destination = SleepDestination(
      id: 2,
      destination: 'Sleep Destination',
      assetSemanticLabel: 'Sleep Asset Label',
      total: 5,
    );

    expect(destination.id, 2);
    expect(destination.destination, 'Sleep Destination');
    expect(destination.assetSemanticLabel, 'Sleep Asset Label');
    expect(destination.total, 5);
    expect(destination.imageAspectRatio, 1);
    expect(destination.assetName, 'crane/destinations/sleep_2.jpg');
    expect(destination.toString(), 'Sleep Destination (id=2)');
  });

  testWidgets('SleepDestination subtitle and subtitleSemantics', (WidgetTester tester) async {
    const destination = SleepDestination(
      id: 2,
      destination: 'Sleep Destination',
      assetSemanticLabel: 'Sleep Asset Label',
      total: 5,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: Builder(
          builder: (BuildContext context) {
            final subtitle = destination.subtitle(context);
            final subtitleSemantics = destination.subtitleSemantics(context);

            expect(subtitle, '5 Available Properties');
            expect(subtitleSemantics, '5 Available Properties');

            return const SizedBox();
          },
        ),
      ),
    );
  });

  test('EatDestination getters', () {
    const destination = EatDestination(
      id: 3,
      destination: 'Eat Destination',
      assetSemanticLabel: 'Eat Asset Label',
      total: 10,
    );

    expect(destination.id, 3);
    expect(destination.destination, 'Eat Destination');
    expect(destination.assetSemanticLabel, 'Eat Asset Label');
    expect(destination.total, 10);
    expect(destination.imageAspectRatio, 1);
    expect(destination.assetName, 'crane/destinations/eat_3.jpg');
    expect(destination.toString(), 'Eat Destination (id=3)');
  });

  testWidgets('EatDestination subtitle and subtitleSemantics', (WidgetTester tester) async {
    const destination = EatDestination(
      id: 3,
      destination: 'Eat Destination',
      assetSemanticLabel: 'Eat Asset Label',
      total: 10,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GalleryLocalizations.localizationsDelegates,
        supportedLocales: GalleryLocalizations.supportedLocales,
        home: Builder(
          builder: (BuildContext context) {
            final subtitle = destination.subtitle(context);
            final subtitleSemantics = destination.subtitleSemantics(context);

            expect(subtitle, '10 Restaurants');
            expect(subtitleSemantics, '10 Restaurants');

            return const SizedBox();
          },
        ),
      ),
    );
  });
}
