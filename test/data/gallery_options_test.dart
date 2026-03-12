// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/data/gallery_options.dart';

void main() {
  group('GalleryOptions', () {
    test('equality and hashCode', () {
      const GalleryOptions options1 = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: Locale('en', 'US'),
        timeDilation: 1.0,
        platform: TargetPlatform.android,
        isTestMode: false,
      );

      const GalleryOptions options2 = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: Locale('en', 'US'),
        timeDilation: 1.0,
        platform: TargetPlatform.android,
        isTestMode: false,
      );

      const GalleryOptions options3 = GalleryOptions(
        themeMode: ThemeMode.dark,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: Locale('en', 'US'),
        timeDilation: 1.0,
        platform: TargetPlatform.android,
        isTestMode: false,
      );

      expect(options1, equals(options2));
      expect(options1.hashCode, equals(options2.hashCode));
      expect(options1, isNot(equals(options3)));
      expect(options1.hashCode, isNot(equals(options3.hashCode)));
    });

    test('copyWith updates fields correctly', () {
      const GalleryOptions original = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: Locale('en', 'US'),
        timeDilation: 1.0,
        platform: TargetPlatform.android,
        isTestMode: false,
      );

      final GalleryOptions updated = original.copyWith(
        themeMode: ThemeMode.dark,
        textScaleFactor: 2.0,
        customTextDirection: CustomTextDirection.rtl,
        locale: const Locale('ar', 'AE'),
        timeDilation: 2.0,
        platform: TargetPlatform.iOS,
        isTestMode: true,
      );

      expect(updated.themeMode, equals(ThemeMode.dark));
      // cannot test textScaleFactor directly, testing via textScaleFactor(context) is done separately
      expect(updated.customTextDirection, equals(CustomTextDirection.rtl));
      expect(updated.locale, equals(const Locale('ar', 'AE')));
      expect(updated.timeDilation, equals(2.0));
      expect(updated.platform, equals(TargetPlatform.iOS));
      expect(updated.isTestMode, isTrue);

      final GalleryOptions unchanged = original.copyWith();
      expect(unchanged, equals(original));
    });

    testWidgets('textScaleFactor returns correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
      final BuildContext context = tester.element(find.byType(SizedBox));

      const GalleryOptions defaultOptions = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 2.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );

      expect(defaultOptions.textScaleFactor(context), equals(2.0));

      const GalleryOptions systemOptions = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.ltr,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );

      expect(systemOptions.textScaleFactor(context, useSentinel: true), equals(systemTextScaleFactorOption));
      // ignore: deprecated_member_use
      expect(systemOptions.textScaleFactor(context, useSentinel: false), equals(MediaQuery.of(context).textScaleFactor));
    });

    test('resolvedTextDirection parses correctly', () {
      const GalleryOptions ltrOptions = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(ltrOptions.resolvedTextDirection(), equals(TextDirection.ltr));

      const GalleryOptions rtlOptions = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.rtl,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(rtlOptions.resolvedTextDirection(), equals(TextDirection.rtl));

      const GalleryOptions localeBasedLtr = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.localeBased,
        locale: Locale('en', 'US'),
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(localeBasedLtr.resolvedTextDirection(), equals(TextDirection.ltr));

      const GalleryOptions localeBasedRtl = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.localeBased,
        locale: Locale('ar', 'AE'),
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(localeBasedRtl.resolvedTextDirection(), equals(TextDirection.rtl));

      const GalleryOptions localeBasedNull = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      // With no locale set and no device locale set, it should return null
      deviceLocale = null;
      expect(localeBasedNull.resolvedTextDirection(), isNull);
    });

    test('resolvedSystemUiOverlayStyle returns correctly', () {
      const GalleryOptions lightMode = GalleryOptions(
        themeMode: ThemeMode.light,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(lightMode.resolvedSystemUiOverlayStyle(), equals(SystemUiOverlayStyle.dark));

      const GalleryOptions darkMode = GalleryOptions(
        themeMode: ThemeMode.dark,
        textScaleFactor: 1.0,
        customTextDirection: CustomTextDirection.ltr,
        locale: null,
        timeDilation: 1.0,
        platform: null,
        isTestMode: false,
      );
      expect(darkMode.resolvedSystemUiOverlayStyle(), equals(SystemUiOverlayStyle.light));
    });
  });
}
