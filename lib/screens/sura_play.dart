import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SuraPlay extends StatefulWidget {
  final String surahName;
  final String surahNameEnglish;

  const SuraPlay({
    super.key,
    required this.surahName,
    required this.surahNameEnglish,
  });

  @override
  _SuraPlayState createState() => _SuraPlayState();
}

class _SuraPlayState extends State<SuraPlay> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isRepeating = false;
  String? _audioUrl;
  bool _isLoading = true;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isConnected = true;
  bool _dialogShown = false;
  StreamSubscription<InternetConnectionStatus>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity(); // Check the initial connectivity status

    _connectivitySubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final isConnected = status == InternetConnectionStatus.connected;
      if (!isConnected) {
        _showNoInternetDialog();
      } else {
        if (mounted) {
          _resumeAudioIfNeeded();
        }
      }
      setState(() {
        _isConnected = isConnected;
      });
    });

    _getAudioUrl();

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

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed && _isRepeating) {
        _playAudio(); // Repeat the audio
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      _isConnected = isConnected;
      if (!_isConnected) {
        _showNoInternetDialog();
      }
    });
  }

  Future<void> _getAudioUrl() async {
    if (!_isConnected) return;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final audioRef = storageRef.child('${widget.surahName}.mp3');

      final audioUrl = await audioRef
          .getDownloadURL()
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, please try again later.');
      });

      if (mounted) {
        setState(() {
          _audioUrl = audioUrl;
          _isLoading = false;
        });
        _playAudio();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (e is TimeoutException || e is SocketException) {
        _showNoInternetDialog();
      } else {
        _showErrorDialog('An unexpected error occurred. Please try again.');
      }
      print('Error fetching URL: $e');
    }
  }

  void _playAudio({int retryCount = 0}) async {
    if (_isConnected) {
      if (_audioUrl != null) {
        try {
          await _audioPlayer.stop(); // Ensure player is stopped before playing
          await _audioPlayer.play(UrlSource(_audioUrl!));
          if (mounted) {
            setState(() {
              _isPlaying = true;
            });
          }
        } catch (e) {
          if (retryCount < 3) {
            print('Error playing audio: $e. Retrying...');
            await Future.delayed(
                Duration(seconds: 2 << retryCount)); // Exponential backoff
            _playAudio(retryCount: retryCount + 1);
          } else {
            print('Failed to play audio after multiple attempts.');
            _showErrorDialog('Failed to play audio. Please try again later.');
          }
        }
      } else {
        _showErrorDialog('Audio URL is not available.');
      }
    } else {
      _showNoInternetDialog();
    }
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
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

  void _forward10Seconds() {
    if (mounted) {
      final newPosition = _currentPosition + Duration(seconds: 10);
      if (newPosition < _audioDuration) {
        _seekAudio(newPosition);
      } else {
        _seekAudio(_audioDuration);
      }
    }
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeating = !_isRepeating;
    });
  }

  void _showNoInternetDialog() {
    if (mounted && !_dialogShown) {
      _dialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.signal_wifi_off,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'لا يوجد إتصال بالإنترنت',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'يرجى التأكد من اتصال جهازك بالإنترنت وإعادة المحاولة.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Divider(color: Colors.grey),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.red,
                              ),
                              child: Text(
                                'إغلاق',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0), // Added space between buttons
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();
                              _checkConnectivity(); // Retry checking connectivity
                            },
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.green,
                              ),
                              child: Text(
                                'إعادة المحاولة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() {
            _dialogShown = false;
          });
        }
      });
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(message),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _resumeAudioIfNeeded() {
    if (_audioUrl != null && !_isPlaying) {
      _playAudio();
    }
  }

  void _handlePlayPauseButtonPressed() async {
    if (_isLoading) return; // Prevent multiple requests

    setState(() {
      _isLoading = true; // Start loading
    });

    if (_isPlaying) {
      _pauseAudio();
    } else {
      final isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
        _playAudio();
      } else {
        _showNoInternetDialog();
      }
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
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
                  widget.surahNameEnglish,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                        Icons.replay_10, screenWidth, _forward10Seconds),
                    _buildControlButton(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      screenWidth,
                      _handlePlayPauseButtonPressed,
                    ),
                    _buildControlButton(Icons.stop, screenWidth, _stopAudio),
                    _buildControlButton(
                      _isRepeating ? Icons.repeat_on : Icons.repeat,
                      screenWidth,
                      _toggleRepeat,
                    ),
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
      icon: _isLoading && icon == Icons.play_arrow
          ? CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.0,
            )
          : Icon(icon),
      color: Colors.white,
      iconSize: screenWidth * 0.08,
      padding: EdgeInsets.all(screenWidth * 0.02),
      onPressed: onPressed,
    );
  }
}
