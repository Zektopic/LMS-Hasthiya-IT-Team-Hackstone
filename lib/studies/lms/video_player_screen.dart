import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:gallery/studies/lms/data_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // The videoUrl from the backend is relative (e.g., "uploads/video-....mp4")
    // We need to prepend the base URL to make it a full, playable URL.
    final fullVideoUrl = LmsDataService()._baseUrl + '/' + widget.video.videoUrl;

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(fullVideoUrl),
    );

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      // You can customize the controller further here
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Chewie(
                controller: _chewieController,
              ),
      ),
    );
  }
}
