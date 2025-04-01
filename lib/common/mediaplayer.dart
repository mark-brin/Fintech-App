import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediaPlayer extends StatefulWidget {
  final VoidCallback onPressed;
  const MediaPlayer({super.key, required this.onPressed});
  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final String audioPath = 'Sample Audio';
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setSource(AssetSource('drums.mp3'));
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String getFileName(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.grey[850]!, Colors.grey[800]!],
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: widget.onPressed,
                        icon: Icon(
                          size: 20,
                          color: Colors.white,
                          FontAwesomeIcons.chevronDown,
                        ),
                      ),
                      Text(
                        "NOW PLAYING",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 20,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 16),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 2.35,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    getFileName(audioPath),
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Artist Name",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbColor: Colors.white,
                      activeTrackColor: Colors.blue[400],
                      inactiveTrackColor: Colors.grey[700],
                      overlayColor: Colors.blue.withOpacity(0.2),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (double value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                        await audioPlayer.resume();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(position),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatDuration(duration - position),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 32,
                        onPressed: () async {
                          await audioPlayer.seek(Duration(
                            seconds: (position.inSeconds - 10)
                                .clamp(0, duration.inSeconds),
                          ));
                        },
                        icon: Icon(
                          FontAwesomeIcons.backward,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: _playPauseAudio,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[700]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isPlaying
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      IconButton(
                        iconSize: 32,
                        onPressed: () async {
                          await audioPlayer.seek(Duration(
                            seconds: (position.inSeconds + 10)
                                .clamp(0, duration.inSeconds),
                          ));
                        },
                        icon: Icon(
                          FontAwesomeIcons.forward,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.repeat,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 30),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 30),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.share,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MiniMediaplayer extends StatefulWidget {
  const MiniMediaplayer({super.key});
  @override
  State<MiniMediaplayer> createState() => _MiniMediaplayerState();
}

class _MiniMediaplayerState extends State<MiniMediaplayer> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final String audioPath = 'Sample Audio';
  final AudioPlayer audioPlayer = AudioPlayer();

  void playPauseAudio() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String getFileName(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFileName(audioPath),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Artist Name",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbColor: Colors.white,
                    activeTrackColor: Colors.blue[400],
                    inactiveTrackColor: Colors.grey[700],
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (double value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
              color: Colors.white,
              size: 20,
            ),
            onPressed: playPauseAudio,
          ),
        ],
      ),
    );
  }
}
