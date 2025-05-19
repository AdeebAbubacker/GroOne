import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:video_player/video_player.dart';

import '../../routing/app_route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(AppImage.png.splash)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration &&
          _controller.value.isInitialized) {
        context.push(AppRouteName.chooseLanguage);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
