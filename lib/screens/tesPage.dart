import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String surahName;

  AudioPlayerScreen({Key? key, required this.surahName}) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDownloading = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isStreaming = false;
  String? _filePath;
  String? _streamingUrl;
  Duration _currentPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _dialogShown = false;
  bool _isConnected = true; // Track internet connectivity

  @override
  void initState() {
    super.initState();
    _checkFileExists('${widget.surahName}.mp3');
    _checkConnectivity(); // Check connectivity on initialization

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isStreaming = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkFileExists(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    if (await file.exists()) {
      setState(() {
        _filePath = file.path;
      });
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _downloadFile(String fileName) async {
    setState(() {
      _isDownloading = true;
    });

    final ref = FirebaseStorage.instance.ref().child(fileName);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    try {
      await ref.writeToFile(file);
      setState(() {
        _filePath = file.path;
        _isDownloading = false;
      });
    } catch (e) {
      print('Failed to download: $e');
      setState(() {
        _isDownloading = false;
      });
      _showNoInternetDialog();
    }
  }

  Future<void> _playAudio() async {
    if (_filePath != null) {
      // Play offline
      await _audioPlayer.play(DeviceFileSource(_filePath!));
      setState(() {
        _isPlaying = true;
        _isPaused = false;
        _isStreaming = false;
      });
    } else if (_isConnected) {
      // Try streaming online
      _playStream('${widget.surahName}.mp3');
    } else {
      _showNoInternetDialog();
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPaused = true;
      _isPlaying = false;
    });
  }

  Future<void> _resumeAudio() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });
  }

  Future<void> _playStream(String fileName) async {
    final ref = FirebaseStorage.instance.ref().child(fileName);
    try {
      final url = await ref.getDownloadURL();
      setState(() {
        _streamingUrl = url;
        _isStreaming = true;
      });
      if (_streamingUrl != null) {
        await _audioPlayer.play(UrlSource(_streamingUrl!));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error streaming file: $e');
      _showNoInternetDialog();
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _isStreaming = false;
      _isPaused = false;
    });
  }

  Future<void> _seekAudio(Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
  }

  void _showNoInternetDialog() {
    if (!_dialogShown) {
      _dialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _dialogShown = false;
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
                  'The People',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                if (_isDownloading)
                  CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        _filePath != null ? Icons.check : Icons.download,
                        screenWidth,
                        () => _downloadFile('${widget.surahName}.mp3'),
                        disabled: _isDownloading,
                      ),
                      _buildControlButton(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          screenWidth, () {
                        if (_isPlaying) {
                          _pauseAudio();
                        } else {
                          _playAudio();
                        }
                      }),
                      _buildControlButton(
                          Icons.stop, screenWidth, () => _stopAudio()),
                      _buildControlButton(Icons.fast_rewind, screenWidth, () {
                        final newPosition =
                            _currentPosition - Duration(seconds: 10);
                        _seekAudio(newPosition < Duration.zero
                            ? Duration.zero
                            : newPosition);
                      }),
                      _buildControlButton(Icons.fast_forward, screenWidth, () {
                        final newPosition =
                            _currentPosition + Duration(seconds: 10);
                        if (newPosition <= _audioDuration) {
                          _seekAudio(newPosition);
                        }
                      }),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    double screenWidth,
    VoidCallback onPressed, {
    bool disabled = false,
  }) {
    return IconButton(
      icon: Icon(icon, size: screenWidth * 0.1, color: Colors.white),
      onPressed: disabled ? null : onPressed,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
