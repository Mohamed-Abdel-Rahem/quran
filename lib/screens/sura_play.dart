import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';

class SuraPlay extends StatefulWidget {
  final String surahName;

  const SuraPlay({super.key, required this.surahName});

  @override
  _SuraPlayState createState() => _SuraPlayState();
}

class _SuraPlayState extends State<SuraPlay> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _audioUrl;
  bool _isLoading = true;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _getAudioUrl();

    // Listen to duration and position changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Handle state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        // Optional: Handle playback-specific state changes here
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Future<void> _getAudioUrl() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final audioRef = storageRef.child('${widget.surahName}.mp3');
      final audioUrl = await audioRef.getDownloadURL();

      if (mounted) {
        setState(() {
          _audioUrl = audioUrl;
          _isLoading = false;
        });
        _playAudio();
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _playAudio() {
    if (_audioUrl != null) {
      _audioPlayer.play(UrlSource(_audioUrl!));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  void _pauseAudio() {
    _audioPlayer.pause();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    }
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/backgroundsura.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.55,
                  height: screenWidth * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/suraicon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  widget.surahName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.023),
                Text(
                  'Surah in English',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.22),
                if (!_isLoading)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_audioDuration),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Slider(
                              value: _audioDuration.inMilliseconds > 0
                                  ? (_currentPosition.inMilliseconds /
                                          _audioDuration.inMilliseconds)
                                      .clamp(0.0, 1.0)
                                  : 0.0,
                              onChanged: (value) {
                                final newPosition = Duration(
                                  milliseconds:
                                      (value * _audioDuration.inMilliseconds)
                                          .toInt(),
                                );
                                _seekAudio(newPosition);
                              },
                              min: 0,
                              max: 1,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (_isLoading) CircularProgressIndicator(),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                        Icons.replay_10, screenWidth, _stopAudio),
                    _buildControlButton(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      screenWidth,
                      _isPlaying ? _pauseAudio : _playAudio,
                    ),
                    _buildControlButton(Icons.forward_10, screenWidth, () {}),
                    _buildControlButton(Icons.repeat, screenWidth, () {}),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -screenSize.width * 0.25,
            right: -screenSize.width * 0.25,
            child: Image.asset(
              'assets/ellipse/Ellipse 10.png',
              width: screenSize.width * 1.1,
              height: screenSize.width * 1.1,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: const Color(0xff4A5759),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              title: Text(
                widget.surahName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Tajawal',
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildControlButton(
      IconData icon, double screenWidth, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      iconSize: screenWidth * 0.08,
      padding: EdgeInsets.all(screenWidth * 0.02),
      onPressed: onPressed,
    );
  }
}
