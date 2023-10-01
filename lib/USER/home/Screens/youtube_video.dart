import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class youtube_video extends StatefulWidget {

  YoutubePlayerController? controller_y;

  youtube_video({required this.controller_y});

  @override
  State<youtube_video> createState() => _youtube_videoState(controller_y: controller_y);
}

class _youtube_videoState extends State<youtube_video> {

  YoutubePlayerController? controller_y;
  _youtube_videoState({required this.controller_y});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          // color: Colors.red,
          // height: SizeConfig.screenHeight,
          // width: SizeConfig.screenWidth,
          child:YoutubePlayer(
            aspectRatio: 16/9,
            controller:controller_y!,
            showVideoProgressIndicator: true,
            onReady: ()=>debugPrint('done'),
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amber
                ),
              ),
              FullScreenButton()
            ],

          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,

    ]);
    super.initState();

  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
