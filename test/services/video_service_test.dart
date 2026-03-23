import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/video.dart';
import 'package:hackston_lms/services/video_service.dart';

// Manual Fakes
class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {
  final Map<String, FakeCollectionReference> collections = {};

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    if (!collections.containsKey(collectionPath)) {
      collections[collectionPath] = FakeCollectionReference();
    }
    return collections[collectionPath]!
        as CollectionReference<Map<String, dynamic>>;
  }
}

class FakeCollectionReference extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  List<FakeDocumentSnapshot> documents = [];
  bool shouldThrowError = false;

  @override
  Query<Map<String, dynamic>> limit(int limit) {
    return FakeQuery(
        documents: documents,
        shouldThrowError: shouldThrowError,
        appliedLimit: limit);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    if (shouldThrowError) {
      throw Exception('Simulated network error');
    }
    return FakeQuerySnapshot(documents: documents);
  }
}

class FakeQuery extends Fake implements Query<Map<String, dynamic>> {
  final List<FakeDocumentSnapshot> documents;
  final bool shouldThrowError;
  final int appliedLimit;

  FakeQuery(
      {required this.documents,
      required this.shouldThrowError,
      required this.appliedLimit});

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    if (shouldThrowError) {
      throw Exception('Simulated network error');
    }
    return FakeQuerySnapshot(documents: documents.take(appliedLimit).toList());
  }
}

class FakeQuerySnapshot extends Fake
    implements QuerySnapshot<Map<String, dynamic>> {
  final List<FakeDocumentSnapshot> documents;

  FakeQuerySnapshot({required this.documents});

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => documents;
}

class FakeDocumentSnapshot extends Fake
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic> data() => _data ?? {};
}

void main() {
  group('VideoService Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late VideoService videoService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      videoService = VideoService(db: fakeFirestore);
    });

    test('getVideos successfully fetches videos without limit', () async {
      final collection =
          fakeFirestore.collection('videos') as FakeCollectionReference;
      collection.documents = [
        FakeDocumentSnapshot('video1', {
          'title': 'Test Video 1',
          'description': 'Description 1',
          'videoUrl': 'url1',
        }),
        FakeDocumentSnapshot('video2', {
          'title': 'Test Video 2',
          'description': 'Description 2',
          'videoUrl': 'url2',
          'thumbnailUrl': 'thumb2',
          'duration': '10:00',
        }),
      ];

      final videos = await videoService.getVideos();

      expect(videos.length, 2);
      expect(videos[0].id, 'video1');
      expect(videos[0].title, 'Test Video 1');
      expect(videos[0].description, 'Description 1');
      expect(videos[0].videoUrl, 'url1');
      expect(videos[0].thumbnailUrl, isNull);
      expect(videos[0].duration, isNull);

      expect(videos[1].id, 'video2');
      expect(videos[1].title, 'Test Video 2');
      expect(videos[1].description, 'Description 2');
      expect(videos[1].videoUrl, 'url2');
      expect(videos[1].thumbnailUrl, 'thumb2');
      expect(videos[1].duration, '10:00');
    });

    test('getVideos handles errors and returns an empty list', () async {
      final collection =
          fakeFirestore.collection('videos') as FakeCollectionReference;
      collection.shouldThrowError = true;

      final videos = await videoService.getVideos();

      expect(videos, isEmpty);
    });
  });
}
