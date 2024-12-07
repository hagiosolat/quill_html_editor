import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WebYoutubeVideoWidget extends StatefulWidget {
  const WebYoutubeVideoWidget(
      {required this.videoUrl,
      required this.videoDuration,
      required this.currentPosition,
      required this.controller,
      this.isAlreadyAvailable = false,
      super.key});
  final String videoUrl;
  final Function(int) videoDuration;
  final Function(int) currentPosition;
  final QuillEditorController controller;
  final bool isAlreadyAvailable;
  @override
  State<WebYoutubeVideoWidget> createState() => _WebYoutubeVideoWidgetState();
}

class _WebYoutubeVideoWidgetState extends State<WebYoutubeVideoWidget> {
  late YoutubePlayerController _webVideoController;

  @override
  void initState() {
    _webVideoController = YoutubePlayerController(
        params: const YoutubePlayerParams(
      showControls: true,
      mute: false,
      showFullscreenButton: false,
      //enableKeyboard: true,
      loop: false,
    ));

    if (widget.isAlreadyAvailable) {
      _webVideoController.loadVideoByUrl(
        mediaContentUrl: widget.videoUrl,
      );
    } else {
      _webVideoController.loadVideoByUrl(
        mediaContentUrl: widget.videoUrl,
      );
    }

    //  _webVideoController.seekTo(seconds: seconds)

    _webVideoController.listen(
      (event) {
        final videoDuration = event.metaData.duration.inMilliseconds;
        if (videoDuration > 1) {
          setState(() {
            print('This is the value player duration $videoDuration');
            widget.videoDuration(videoDuration);
          });
        }
        setState(() {
          _webVideoController.videoStateStream.listen((videoState) {
            //   print('The video current Time is ${videoState.position}');
            widget.currentPosition(videoState.position.inMilliseconds);
          });
        });
      },
    );

    // print(
    //     'This is the video Duration ${_webVideoController.metadata.duration}');

    super.initState();
  }

  @override
  void dispose() {
    _webVideoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: KeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            print('Listening to the keyboard event');
            Navigator.of(context).pop();
          }
        },
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              child: YoutubePlayer(
                controller: _webVideoController,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
