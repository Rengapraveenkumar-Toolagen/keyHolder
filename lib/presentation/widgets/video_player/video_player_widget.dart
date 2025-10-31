import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/colors/colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final File? video;
  const VideoPlayerWidget({super.key, this.videoUrl, this.video});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    } else if (widget.video != null && widget.video!.path.isNotEmpty) {
      videoPlayerController = VideoPlayerController.file(widget.video!);
    }
    videoPlayerController!.initialize().then((value) => setState(
          () {
            chewieController = ChewieController(
                videoPlayerController: videoPlayerController!,
                aspectRatio: videoPlayerController!.value.aspectRatio);
          },
        ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController!.value.isInitialized
        ? AspectRatio(
            aspectRatio: widget.videoUrl != null && widget.videoUrl!.isNotEmpty
                ? 16 / 9
                : 16 / 9,
            child: Chewie(
                controller: chewieController = ChewieController(
              videoPlayerController: videoPlayerController!,
              autoInitialize: true,
              allowFullScreen: true,
              showOptions: false,
              autoPlay: false,
              allowMuting: false,
              looping: false,
              showControls: true,
              errorBuilder: (context, errorMessage) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 24),
                  ],
                );
              },
            )),
          )
        : const Center(child: CircularProgressIndicator(color: primaryColor));
  }
}
