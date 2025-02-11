import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:phone_rings/Controllers/ringtoneController.dart';
import 'package:phone_rings/Models/ringtoneModel.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:phone_rings/Widgets/playPauseButton.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

import '../Controllers/wishlistController.dart';

class RingtonePlayer extends StatefulWidget {
  final Ringtone ringtone;
  const RingtonePlayer({
    Key? key,
    required this.ringtone,
  }) : super(key: key);

  @override
  _RingtonePlayerState createState() => _RingtonePlayerState();
}

class _RingtonePlayerState extends State<RingtonePlayer> {
  // Controller from your state management (GetX)
  RingtoneController ringtoneController = Get.put(RingtoneController());
  final WishlistController wishlistController = Get.find<WishlistController>();

  // AudioPlayer instance for playback.
  late AudioPlayer audioPlayer;
  // PlayerController for waveform visualization.

  bool isFavourite = false;
  bool isPlaying = false;
  bool isAudioLoading = true;     // For the AudioPlayer
  // For waveform extraction

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();


    // Load audio for playback.
    loadAudio();
    // Download and prepare the audio file for waveform extraction.
  }

  /// Loads the audio URL into the AudioPlayer.
  Future<void> loadAudio() async {
    try {
      await audioPlayer.setUrl(widget.ringtone.previews['preview-hq-mp3']!);
      setState(() {
        isAudioLoading = false;
      });
    } catch (e) {
      setState(() {
        isAudioLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load audio: ${widget.ringtone.name}')),
      );
    }
  }
  Future<List<double>> _loadProcessedSamples() async {
    print('loading samples function started');
    try {
      final response = await http.get(Uri.parse(widget.ringtone.analysisFrames));
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        if (jsonData.containsKey("lowlevel") && jsonData["lowlevel"].containsKey("spectral_rms")){
          final List<dynamic> rawSamples = jsonData["lowlevel"]["spectral_rms"];
          // Convert each value to double (and consider scaling/normalization if needed)
          List<double> samples = rawSamples.map((e) => (e as num).toDouble()).toList();
          return samples;
        }
        else {
          throw Exception("Failed to load analysis frames data");
        }
        // Adjust the key here if your JSON structure is different.

      } else {
        throw Exception("spectral_rms not found in analysis data");
      }
    } catch (e) {
      throw Exception("Error processing analysis frames: $e");
    }
  }



  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Combine loading status for a simple check.
    final isLoading = isAudioLoading;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Play/Pause Button
          GestureDetector(
            onTap: () async {
              if (!isPlaying) {
                await audioPlayer.play();
              } else {
                await audioPlayer.pause();
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey : Colors.green,
                borderRadius: BorderRadius.circular(25),
              ),
              child: StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    );
                  }
                  final playerState = snapshot.data!;
                  return playPauseButton(
                      audioPlayer: audioPlayer, playerState: playerState);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details & Waveform Display
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ringtone.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Uploaded by: ${widget.ringtone.username}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                // Waveform display or a loading indicator if not ready.
                isLoading
                    ? const CircularProgressIndicator()
                    : FutureBuilder<List<double>>(
                  future: _loadProcessedSamples(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    // Get the raw samples from your analysis JSON.
                    final rawSamples = snapshot.data!;

                    // Normalize the samples.
                    // For example, if the values are very small (e.g., 1e-7), multiply by a factor.
                    // You might need to experiment with the factor (here, we use 1e7 as an example).
                    const double normalizationFactor = 1e50;
                    final normalizedSamples =
                    rawSamples.map((sample) => sample * normalizationFactor).toList();

                    // Use a StreamBuilder to update the elapsedDuration from the audio player.
                    return StreamBuilder<Duration>(
                      stream: audioPlayer.positionStream,
                      builder: (context, posSnapshot) {
                        Duration elapsed = posSnapshot.data ?? Duration.zero;
                        // In a real scenario, you might obtain the true duration.
                        // For this example, we assume a fixed maxDuration.
                        Duration maxDuration = Duration( seconds:  widget.ringtone.duration.toInt());
                        return CurvedPolygonWaveform(

                          activeColor: Color(0xFF572177),
                          maxDuration: maxDuration,
                          elapsedDuration: elapsed,
                          samples: normalizedSamples,
                          height: 60,
                          width: MediaQuery.of(context).size.width - 100,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),
                // Download Button
                Row(
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.install_mobile_sharp,
                        size: 28,
                        color: Color(0xFF521f64),
                      ),
                      onTap: () async {
                        await ringtoneController.downloadRingtone(
                          widget.ringtone.downloadUrl,
                          widget.ringtone.name,
                          widget.ringtone.id,
                        );
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      child: wishlistController.isInWishlist(widget.ringtone) ?  const Icon(
                        Ionicons.heart,
                        size: 28,
                        color: Color(0xFF521f64),
                        ) :  const Icon(
                        Ionicons.heart_outline,
                        size: 28,
                        color: Color(0xFF521f64),
                      ),
                      onTap: () async {
                        setState(() {
                          isFavourite = !isFavourite;
                          wishlistController.toggleWishlist(widget.ringtone);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
