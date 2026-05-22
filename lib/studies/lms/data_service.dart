import 'dart:convert';
import 'package:http/http.dart' as http;

class Video {
  final String id;
  final String title;
  final String description;
  final String videoUrl;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
    );
  }
}

class LmsDataService {
  static const String baseUrl = String.fromEnvironment(
    'LMS_API_BASE_URL',
    defaultValue: 'https://api.hackston-lms.com',
  );

  final http.Client _client;
  static String? _authToken;

  LmsDataService({http.Client? client}) : _client = client ?? http.Client();

  /// Authenticates the user and retrieves a JWT token.
  Future<void> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _authToken = responseData['token'];
    } else {
      throw Exception('Login failed. Status code: ${response.statusCode}');
    }
  }

  /// Fetches the list of videos. Requires [login] to be called first to generate the auth token.
  Future<List<Video>> fetchVideos() async {
    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception('Not authenticated. Please login first.');
    }

    final response = await _client.get(
      Uri.parse('$baseUrl/api/videos'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': _authToken!,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> videoJson = json.decode(response.body);
      return videoJson.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load videos. Status code: ${response.statusCode}',
      );
    }
  }
}
