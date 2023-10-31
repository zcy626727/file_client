import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CommonMediaPlayer extends StatefulWidget {
  const CommonMediaPlayer({Key? key, required this.videoUrl, this.play = true}) : super(key: key);

  final String videoUrl;
  final bool play;

  @override
  State<CommonMediaPlayer> createState() => _CommonMediaPlayerState();
}

class _CommonMediaPlayerState extends State<CommonMediaPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.videoUrl), play: widget.play);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return MaterialDesktopVideoControlsTheme(
      normal: MaterialDesktopVideoControlsThemeData(
        buttonBarButtonSize: 24.0,
        buttonBarButtonColor: Colors.white,
        bottomButtonBar: [
          MaterialDesktopSkipPreviousButton(),
          MaterialDesktopPlayOrPauseButton(),
          MaterialDesktopSkipNextButton(),
          MaterialDesktopVolumeButton(),
          MaterialDesktopPositionIndicator(),
          Spacer(),
          // MaterialDesktopCustomButton(
          //   onPressed: () {
          //     debugPrint('Custom "Settings" button pressed.');
          //   },
          //   icon: const Icon(Icons.settings),
          // ),
          MaterialDesktopFullscreenButton(),
        ],
      ),
      fullscreen: const MaterialDesktopVideoControlsThemeData(
        // Modify theme options:
        displaySeekBar: false,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
      ),
      child: Video(
        controller: controller,
      ),
    );
  }
}
