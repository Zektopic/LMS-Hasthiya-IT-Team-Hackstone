import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/video.dart';

class FakeDocumentSnapshot extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Video.fromJson', () {
    test('parses fully populated JSON correctly', () {
      final json = {
        '_id': 'vid123',
        'title': 'Test Video',
        'description': 'A comprehensive test video',
        'videoUrl': 'https://example.com/video.mp4',
        'thumbnailUrl': 'https://example.com/thumb.jpg',
        'duration': '10:00',
      };

      final video = Video.fromJson(json);

      expect(video.id, 'vid123');
      expect(video.title, 'Test Video');
      expect(video.description, 'A comprehensive test video');
      expect(video.videoUrl, 'https://example.com/video.mp4');
      expect(video.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(video.duration, '10:00');
    });

    test('uses id when _id is missing', () {
      final json = {
        'id': 'vid456',
        'title': 'Test Video 2',
        'description': 'Another test video',
        'videoUrl': 'https://example.com/video2.mp4',
      };

      final video = Video.fromJson(json);

      expect(video.id, 'vid456');
    });

    test('prioritizes _id over id', () {
      final json = {
        '_id': 'vid_primary',
        'id': 'vid_secondary',
        'title': 'Test Video 3',
        'description': 'Yet another test video',
        'videoUrl': 'https://example.com/video3.mp4',
      };

      final video = Video.fromJson(json);

      expect(video.id, 'vid_primary');
    });

    test('handles missing optional fields and provides defaults', () {
      final json = <String, dynamic>{};

      final video = Video.fromJson(json);

      expect(video.id, '');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });

    test('handles null values for optional fields and provides defaults', () {
      final json = {
        '_id': null,
        'id': null,
        'title': null,
        'description': null,
        'videoUrl': null,
        'thumbnailUrl': null,
        'duration': null,
      };

      final video = Video.fromJson(json);

      expect(video.id, '');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });
  });

  group('Video.fromFirestore', () {
    test('parses fully populated DocumentSnapshot correctly', () {
      final doc = FakeDocumentSnapshot('vid123', {
        'title': 'Test Video',
        'description': 'A comprehensive test video',
        'videoUrl': 'https://example.com/video.mp4',
        'thumbnailUrl': 'https://example.com/thumb.jpg',
        'duration': '10:00',
      });

      final video = Video.fromFirestore(doc);

      expect(video.id, 'vid123');
      expect(video.title, 'Test Video');
      expect(video.description, 'A comprehensive test video');
      expect(video.videoUrl, 'https://example.com/video.mp4');
      expect(video.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(video.duration, '10:00');
    });

    test('handles missing optional fields and provides defaults', () {
      final doc = FakeDocumentSnapshot('vid456', <String, dynamic>{});

      final video = Video.fromFirestore(doc);

      expect(video.id, 'vid456');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });

    test('handles null values for optional fields and provides defaults', () {
      final doc = FakeDocumentSnapshot('vid789', {
        'title': null,
        'description': null,
        'videoUrl': null,
        'thumbnailUrl': null,
        'duration': null,
      });

      final video = Video.fromFirestore(doc);

      expect(video.id, 'vid789');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });

    test('handles null data() by providing defaults', () {
      final doc = FakeDocumentSnapshot('vid000', null);

      final video = Video.fromFirestore(doc);

      expect(video.id, 'vid000');
      expect(video.title, 'Untitled');
      expect(video.description, '');
      expect(video.videoUrl, '');
      expect(video.thumbnailUrl, isNull);
      expect(video.duration, isNull);
    });
  });
}
