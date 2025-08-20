import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gallery/studies/lms/data_service.dart';
import 'package:gallery/studies/lms/routes.dart' as routes;
import 'package:gallery/studies/lms/video_list_screen.dart';
import 'package:gallery/studies/lms/video_player_screen.dart';

class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS Study',
      debugShowCheckedModeBanner: false,
      initialRoute: routes.videoListRoute,
      onGenerateRoute: (settings) {
        if (settings.name == routes.videoPlayerRoute) {
          final video = settings.arguments as Video;
          return MaterialPageRoute(
            builder: (context) {
              return VideoPlayerScreen(video: video);
            },
          );
        }

        // The only other route is the list screen.
        return MaterialPageRoute(
          builder: (context) {
            return const VideoListScreen();
          },
        );
      },
    );
  }
}
