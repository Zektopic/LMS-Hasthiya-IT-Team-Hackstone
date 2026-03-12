import 'package:flutter/material.dart';
import 'package:hasthiya_lms/studies/lms/data_service.dart';
import 'package:hasthiya_lms/studies/lms/routes.dart' as routes;
import 'package:hasthiya_lms/studies/lms/video_list_screen.dart';
import 'package:hasthiya_lms/studies/lms/video_player_screen.dart';
import 'package:hasthiya_lms/studies/lms/login_screen.dart';

class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS Study',
      debugShowCheckedModeBanner: false,
      initialRoute: '/lms/login',
      onGenerateRoute: (settings) {
        if (settings.name == routes.videoPlayerRoute) {
          final video = settings.arguments as Video;
          return MaterialPageRoute(
            builder: (context) {
              return VideoPlayerScreen(video: video);
            },
          );
        } else if (settings.name == '/lms/login') {
          return MaterialPageRoute(
            builder: (context) {
              return const LmsLoginScreen();
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
