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
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final String audioPath = 'Sample Audio';
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setSource(AssetSource('sampleAudio.mp3'));

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(
        () {
          _duration = newDuration;
        },
      );
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(
        () {
          _position = newPosition;
        },
      );
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

  String _getFileName(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(FontAwesomeIcons.chevronDown, size: 20),
                  ),
                  Container(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      size: 20,
                      FontAwesomeIcons.ellipsisVertical,
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 12.5),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://images.pexels.com/photos/1389429/pexels-photo-1389429.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(height: 5),
              Divider(thickness: 0.15),
              SizedBox(height: 20),
              Text(
                _getFileName(audioPath),
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10),
              Slider(
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: (double value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position)),
                  Text(_formatDuration(_duration - _position)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await audioPlayer.seek(
                        Duration(
                          seconds: (_position.inSeconds - 10)
                              .clamp(0, _duration.inSeconds),
                        ),
                      );
                    },
                    icon: Icon(FontAwesomeIcons.backwardStep),
                  ),
                  SizedBox(width: 17),
                  IconButton(
                    onPressed: _playPauseAudio,
                    icon: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        isPlaying
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 17),
                  IconButton(
                    onPressed: () async {
                      await audioPlayer.seek(
                        Duration(
                          seconds: (_position.inSeconds + 10)
                              .clamp(0, _duration.inSeconds),
                        ),
                      );
                    },
                    icon: Icon(FontAwesomeIcons.forwardStep),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
