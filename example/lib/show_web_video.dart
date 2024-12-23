import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget(
      {required this.videoUrl,
      required this.videoDuration,
      required this.currentPosition,
      required this.videoRatio,
      required this.positioning,
      super.key});

  final String videoUrl;
  final Function(Duration) videoDuration;
  final Function(double) videoRatio;
  final Function(Duration) currentPosition;
  final Duration positioning;

  @override
  State<VideoWidget> createState() => _WebVideoWidgetState();
}

class _WebVideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  Future<void> initializeController() async {
    try {
      await _videoController.initialize().then((_) {
        setState(() {
          _videoController.seekTo(widget.positioning);
        });
      });

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoInitialize: true,
        autoPlay: true,
        showOptions: false,
        showControls: true,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    initializeController();

    // widget.videoDuration(_videoDuration);
    //  _videoController.play();

    _videoController.addListener(() {
      if (_videoController.value.isPlaying) {
        setState(() {
          // print(
          //     'The current position of the video is ${_videoController.value.position}');
          widget.currentPosition(_videoController.value.position);
          widget.videoRatio(_videoController.value.position.inMilliseconds /
              _videoController.value.duration.inMilliseconds);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO: To attach a close button so that I can keep track of the video Current Position
      child: _videoController.value.isInitialized
          ? Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.videoDuration(_videoController.value.position);
                      },
                      icon: const Icon(Icons.cancel)),
                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController)),
                  // AspectRatio(
                  //   aspectRatio: _videoController.value.aspectRatio,
                  //   child: VideoPlayer(_videoController),
                  // ),
                  // Text(
                  //     'Video Duration: ${_videoController.value.position.inMinutes}: ${_videoController.value.position.inSeconds.remainder(60)}'),
                  // IconButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _videoController.value.isPlaying
                  //             ? _videoController.pause()
                  //             : _videoController.play();
                  //       });
                  //     },
                  //     icon: Icon(_videoController.value.isPlaying
                  //         ? Icons.pause
                  //         : Icons.play_arrow))
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
