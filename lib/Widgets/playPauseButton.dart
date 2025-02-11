import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class playPauseButton extends StatelessWidget {
  const playPauseButton({
    super.key,
    required this.audioPlayer,
    required this.playerState,
  });

  final AudioPlayer audioPlayer;
  final PlayerState playerState;

  @override
  Widget build(BuildContext context) {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: EdgeInsets.all(8.0),
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(),
      );
    } else if (audioPlayer.playing != true) {
      return IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 30.0,
        onPressed: audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: Icon(Icons.pause),
        iconSize: 30.0,
        onPressed: audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.replay),
        iconSize: 30.0,
        onPressed: () => audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices?.first),
      );
    }
  }
}