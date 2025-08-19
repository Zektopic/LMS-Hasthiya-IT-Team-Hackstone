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
  // TODO: Make this configurable for different environments (dev, prod)
  final String _baseUrl = 'http://localhost:5000';

  // TODO: This should be retrieved from secure storage after a login flow.
  // This is a placeholder token and will not work unless you generate a valid one
  // from the backend's /api/auth/login endpoint.
  final String _authToken = 'your_superadmin_jwt_token_here';

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/videos'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': _authToken,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> videoJson = json.decode(response.body);
      return videoJson.map((json) => Video.fromJson(json)).toList();
    } else {
      // Throws an exception which can be caught in the UI layer
      // to show a retry mechanism.
      throw Exception('Failed to load videos. Status code: ${response.statusCode}');
    }
  }
}
