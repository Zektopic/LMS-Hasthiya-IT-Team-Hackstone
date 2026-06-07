import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:hackston_lms/studies/lms/data_service.dart';

class MockClient extends http.BaseClient {
  http.Response? response;
  Uri? lastUrl;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastUrl = request.url;
    final res = response ?? http.Response('', 200);
    return http.StreamedResponse(
      Stream.value(res.bodyBytes),
      res.statusCode,
      headers: res.headers,
    );
  }
}

void main() {
  group('LmsDataService Tests', () {
    test('baseUrl defaults to https://api.hackston-lms.com', () {
      expect(LmsDataService.baseUrl, 'https://api.hackston-lms.com');
    });

    test('login sends request to the correct URL', () async {
      final mockClient = MockClient();
      mockClient.response = http.Response(
        jsonEncode({'token': 'fake_token'}),
        200,
      );
      final dataService = LmsDataService(client: mockClient);

      await dataService.login('test@example.com', 'password');

      expect(
        mockClient.lastUrl.toString(),
        '${LmsDataService.baseUrl}/api/auth/login',
      );
    });

    test('fetchVideos sends request to the correct URL', () async {
      final mockClient = MockClient();
      // First login to set token
      mockClient.response = http.Response(
        jsonEncode({'token': 'fake_token'}),
        200,
      );
      final dataService = LmsDataService(client: mockClient);
      await dataService.login('test@example.com', 'password');

      mockClient.response = http.Response(jsonEncode([]), 200);
      await dataService.fetchVideos();

      expect(
        mockClient.lastUrl.toString(),
        '${LmsDataService.baseUrl}/api/videos',
      );
    });
  });
}
