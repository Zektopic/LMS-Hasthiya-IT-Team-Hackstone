import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/video.dart';

// Manual Fake for DocumentSnapshot
class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Video Model Tests', () {
    test('fromFirestore creates a Video correctly with all fields', () {
      final doc = FakeDocumentSnapshot('video-123', {
        'title': 'Flutter Basics',
        'description': 'Introduction to Flutter',
        'videoUrl': 'https://example.com/video.mp4',
        'thumbnailUrl': 'https://example.com/thumb.jpg',
        'duration': '10:00',
      });

      final video = Video.fromFirestore(doc);

      expect(video.id, 'video-123');
      expect(video.title, 'Flutter Basics');
      expect(video.description, 'Introduction to Flutter');
      expect(video.videoUrl, 'https://example.com/video.mp4');
      expect(video.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(video.duration, '10:00');
    });

    test('fromFirestore handles missing data gracefully', () {
      final doc = FakeDocumentSnapshot('video-456', {});

      final video = Video.fromFirestore(doc);

      expect(video.id, 'video-456');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });

    test('fromFirestore handles null document data gracefully', () {
      final doc = FakeDocumentSnapshot('video-789', null);

      final video = Video.fromFirestore(doc);

      expect(video.id, 'video-789');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });
  });
}
