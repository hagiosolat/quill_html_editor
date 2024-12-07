import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MobileYoutubeVideoWidget extends StatefulWidget {
  const MobileYoutubeVideoWidget(
      {required this.videoUrl,
      required this.videoDuration,
      required this.currentPosition,
      required this.durationRation,
      required this.positioning,
      super.key});

  final String videoUrl;
  final Function(Duration) videoDuration;
  final Function(Duration) currentPosition;
  final Function(double) durationRation;
  final Duration positioning;

  @override
  State<MobileYoutubeVideoWidget> createState() =>
      _MobileYoutubeVideoWidgetState();
}

class _MobileYoutubeVideoWidgetState extends State<MobileYoutubeVideoWidget>
    with WidgetsBindingObserver {
  late YoutubePlayerController _youtubecontroller;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _youtubecontroller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ));

    _youtubecontroller.addListener(() async {
      if (_youtubecontroller.value.isPlaying) {
        setState(() {
          widget.currentPosition(_youtubecontroller.value.position);
          widget.durationRation(
              _youtubecontroller.value.position.inMilliseconds /
                  _youtubecontroller.value.metaData.duration.inMilliseconds);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _youtubecontroller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: const [],
        onReady: () {
          // _youtubecontroller.updateValue(YoutubePlayerValue(position: positioning));
          _youtubecontroller.seekTo(widget.positioning, allowSeekAhead: true);
        },
        onEnded: (data) {},
      ),
      builder: (context, player) {
        // _youtubecontroller.addListener(positionListener);
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              color: Colors.transparent,
              child: player,
            ),
            Positioned(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      //To save the current Position where the video stopped inside the map
                      widget.videoDuration(_youtubecontroller.value.position);
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 35,
                    color: Colors.white,
                  )),
            )
          ],
        );
      },
    ));
  }

  @override
  void dispose() {
    _youtubecontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    WidgetsBinding.instance.removeObserver(this);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _youtubecontroller.value.position;
    }
    super.didChangeAppLifecycleState(state);
  }
}
