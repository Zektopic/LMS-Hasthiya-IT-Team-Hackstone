// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:google_fonts/src/google_fonts_family_with_variant.dart';
import 'package:google_fonts/src/google_fonts_variant.dart';
import 'package:path/path.dart' as path;

/// Load fonts to make sure they show up in golden tests.
Future<void> loadFonts() async {
  final fontData = await Future.wait([
    loadFontsFromManifest(),
    loadGoogleFonts(),
    loadFontsFromTestingDir(),
  ]);

  await _load(fontData[0]
    ..addAll(fontData[1])
    ..addAll(fontData[2]));
}

Future<Map<String?, List<Future<ByteData>>>> loadFontsFromManifest() async {
  final List<dynamic> fontManifest =
      await (rootBundle.loadStructuredData<List<dynamic>>(
    'FontManifest.json',
    (data) async => json.decode(data) as List<dynamic>,
  ));

  final fontFamilyToData = <String?, List<Future<ByteData>>>{};
  for (final fontData in fontManifest) {
    final fontFamily = fontData['family'] as String?;
    final fonts = fontData['fonts'] as List<dynamic>;
    for (final font in fonts) {
      (fontFamilyToData[fontFamily] ??= [])
          .add(rootBundle.load(font['asset'] as String));
    }
  }
  return fontFamilyToData;
}

Future<Map<String, List<Future<ByteData>>>> loadFontsFromTestingDir() async {
  final fontFamilyToData = <String, List<Future<ByteData>>>{};
  final currentDir = path.dirname(Platform.script.path);
  final fontsDirectory = path.join(
    currentDir,
    'test_goldens',
    'testing',
    'fonts',
  );
  await for (final file in Directory(fontsDirectory).list()) {
    if (file is File) {
      final fontFamily =
          path.basenameWithoutExtension(file.path).split('-').first;
      (fontFamilyToData[fontFamily] ??= [])
          .add(file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)));
    }
  }
  return fontFamilyToData;
}

Future<Map<String, List<Future<ByteData>>>> loadGoogleFonts() async {
  final currentDir = path.dirname(Platform.script.path);
  final googleFontsDirectory = path.join(currentDir, 'fonts', 'google_fonts');
  final fontFamilyToData = <String, List<Future<ByteData>>>{};
  await for (final file in Directory(googleFontsDirectory).list()) {
    if (file is File) {
      final fileName = path.basenameWithoutExtension(file.path);
      final googleFontName = GoogleFontsFamilyWithVariant(
        family: fileName.split('-').first,
        googleFontsVariant: GoogleFontsVariant.fromApiFilenamePart(fileName),
      ).toString();
      fontFamilyToData[googleFontName] = [
        file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer))
      ];
    }
  }
  return fontFamilyToData;
}

Future<void> _load(
    Map<String?, List<Future<ByteData>>> fontFamilyToData) async {
  final waitList = <Future<void>>[];
  for (final entry in fontFamilyToData.entries) {
    final loader = FontLoader(entry.key!);
    for (final data in entry.value) {
      loader.addFont(data);
    }
    waitList.add(loader.load());
  }
  await Future.wait(waitList);
}
