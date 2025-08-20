import 'package:flutter/material.dart';
import 'package:gallery/studies/lms/data_service.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late Future<List<Video>> _videosFuture;
  final LmsDataService _dataService = LmsDataService();

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  void _fetchVideos() {
    setState(() {
      _videosFuture = _dataService.fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LMS Courses'),
      ),
      body: FutureBuilder<List<Video>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchVideos,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found.'));
          } else {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(video.title),
                    subtitle: Text(video.description),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/lms/player',
                        arguments: video,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
