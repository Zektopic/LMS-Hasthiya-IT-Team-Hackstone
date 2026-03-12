import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hasthiya_lms/pages/about.dart';

void main() {
  test('getVersionNumber returns correct version string', () async {
    // Setup mock package info
    PackageInfo.setMockInitialValues(
      appName: 'Test App',
      packageName: 'com.test.app',
      version: '1.2.3',
      buildNumber: '10',
      buildSignature: 'buildSignature',
    );

    final String version = await getVersionNumber();
    expect(version, '1.2.3');
  });
}
