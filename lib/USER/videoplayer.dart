import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../COMMON/size_config.dart';
import 'home/Controller/get_testimonials_controller.dart';
class YoutubeVideo extends StatefulWidget {



  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool _isPlayerReady = false;
  late String videoId;
  final _get_testimonials=Get.put(get_testimonials_controller());

  @override
  void initState() {
    for (var element in _get_testimonials.yturl) {
      videoId = YoutubePlayer.convertUrlToId(element)!;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
      _controller.addListener(() {
        print('for $videoId got isPlaying state ${_controller.value.isPlaying}');
        if (cStates[videoId] != _controller.value.isPlaying) {
          if (mounted) {
            setState(() {
              cStates[videoId] = _controller.value.isPlaying;
            });
          }
        }
      });
      _idController = TextEditingController();
      _seekToController = TextEditingController();

    }
    super.initState();

  }

  Map<String, dynamic> cStates = {};

  // void listener() {
  //   if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  //     if (cStates[_id] != _ytController.value.isPlaying) {
  //       if (mounted) {
  //         setState(() {
  //           cStates[_id] = _ytController.value.isPlaying;
  //         });
  //       }
  //     }
  //     setState(() {});
  //   }
  // }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: SizeConfig.screenWidth,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount:  _get_testimonials.yturl.length,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            width: SizeConfig.screenWidth*0.6,
            color: Colors.blue,
            child: VisibilityDetector(
              key: const Key("unique key"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 0) {
                  _controller.pause();
                } else {
                  _controller.value.isPlaying
                      ? _controller.play()
                      : _controller.pause();

                }
              },
              child: YoutubePlayerBuilder(
                onExitFullScreen: () {
                  // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                },
                player: YoutubePlayer(

                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                  topActions: <Widget>[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _controller.metadata.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                  ],
                  onReady: () {
                    // _controller.addListener(listener);
                  },
                  onEnded: (data) {},
                ),
                builder: (context, player) =>
                    Scaffold(
                      key: _scaffoldKey,
                      body:
                      ListView(
                        children: [
                          player,
                        ],
                      ),
                    ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: SizeConfig.screenWidth*0.04,);
        },
      ),
    );
  }


}