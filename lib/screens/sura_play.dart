import 'dart:async'; // Add this import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String surahNameArabic;

  AudioPlayerScreen({Key? key, required this.surahNameArabic})
      : super(key: key);

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
  bool _isConnected = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  @override
  void initState() {
    super.initState();

    // Check if file exists locally
    _checkFileExists('${widget.surahNameArabic}.mp3').then((fileExists) {
      if (fileExists) {
        _playAudio(); // If file exists, play it.
      } else {
        // Check for internet connection if the file doesn't exist.
        _checkInternetConnection().then((isConnectedd) {
          if (isConnectedd) {
            _playStream(
                '${widget.surahNameArabic}.mp3'); // Play stream if connected to the internet.
          } else {
            _showNoInternetDialog(); // Show dialog if no internet and file not downloaded.
          }
        });
      }
    }).catchError((error) {
      print("Error checking file existence: $error");
    });

    // Audio player event listeners
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

    // Connectivity listener
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _pauseAudio(); // Pause audio when no internet
        if (_filePath == null) {
          _showNoInternetDialog(); // Show dialog only if file is not downloaded
        }
      } else if (_isPaused) {
        _resumeAudio(); // Resume audio if internet is restored
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<bool> _checkFileExists(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    if (await file.exists()) {
      setState(() {
        _filePath = file.path;
      });
      return true; // File exists
    }
    return false; // File does not exist
  }

  Future<bool> _checkInternetConnection() async {
    // Skip the internet check if the surah file is already downloaded
    if (_filePath != null) {
      return true; // Surah is downloaded, treat as connected
    }

    // Otherwise, perform the internet check
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet is available
      }
    } on SocketException catch (_) {
      return false; // No internet connection
    }

    return false; // Default to no internet if something fails
  }

  Future<void> _showNoInternetDialog() async {
    if (!_dialogShown && mounted) {
      setState(() {
        _dialogShown = true; // Prevent multiple dialog displays
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            elevation: 10,
            backgroundColor:
                Color(0xff404E50), // Harmonious deep teal background
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.signal_wifi_off,
                    color:
                        Colors.orangeAccent, // Softer, eye-catching icon color
                    size: 60,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'لا يوجد اتصال بالإنترنت',
                    style: TextStyle(
                      color: Colors.white, // Title in white for good contrast
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'يرجى العلم بأن هذه الخاصيه بحاجه الي للإِتصال بالإِنترنت.',
                    style: TextStyle(
                      color: Colors
                          .blue[100], // Softer light blue text for content
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Colors.teal[700], // Button background matches dialog
                      backgroundColor: Colors
                          .lightBlue[100], // Softer light blue for the button
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded button
                      ),
                    ),
                    child: Text(
                      'حسناً',
                      style: TextStyle(
                        fontSize: 18, // Button text size
                        color:
                            Color(0xff264864), // Dark teal text on the button
                      ),
                    ),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _dialogShown = false; // Reset dialog flag
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _downloadFile(String fileName) async {
    await _checkInternetConnection(); // Ensure internet connectivity

    if (!_isConnected) {
      _showNoInternetDialog();
      return;
    }

    if (mounted) {
      setState(() {
        _isDownloading = true;
      });
    }

    final ref = FirebaseStorage.instance.ref().child(fileName);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    try {
      await ref.writeToFile(file);
      if (mounted) {
        setState(() {
          _filePath = file.path;
          _isDownloading = false;
        });
      }
    } catch (e) {
      print('Failed to download: $e');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
      _showNoInternetDialog(); // Show error dialog if download fails
    }
  }

  Future<void> _playAudio() async {
    // If the file is already downloaded, skip any internet checks and play it
    if (_filePath != null) {
      await _audioPlayer.play(DeviceFileSource(_filePath!));
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isPaused = false;
          _isStreaming = false;
        });
      }
    } else {
      // File is not downloaded, check internet connection and stream if possible
      await _checkInternetConnection();

      if (_isConnected) {
        await _playStream('${widget.surahNameArabic}.mp3');
      } else {
        // No internet and file is not downloaded, show dialog
        _showNoInternetDialog();
      }
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      if (mounted) {
        setState(() {
          _isPaused = true;
          _isPlaying = false;
        });
      }
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> _resumeAudio() async {
    try {
      await _audioPlayer.resume();
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isPaused = false;
        });
      }
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  Future<void> _playStream(String fileName) async {
    // First, ensure internet connection before fetching the URL
    await _checkInternetConnection();

    if (!_isConnected) {
      _showNoInternetDialog();
      return;
    }

    final ref = FirebaseStorage.instance.ref().child(fileName);
    try {
      final url = await ref.getDownloadURL();
      if (mounted) {
        setState(() {
          _streamingUrl = url;
          _isStreaming = true;
        });
      }

      // Check connectivity again before playing
      if (!_isConnected) {
        _showNoInternetDialog();
        return;
      }

      await _audioPlayer.play(UrlSource(_streamingUrl!));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error streaming file: $e');
      _showNoInternetDialog(); // Show the dialog for streaming errors
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isStreaming = false;
          _isPaused = false;
        });
      }
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> _seekAudio(Duration newPosition) async {
    try {
      await _audioPlayer.seek(newPosition);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإستماع للقرأن الكريم',
          style: TextStyle(
            color: Colors.white, // Text color matching the screen theme
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff425052), // Deep teal color
        elevation: 5, // Add some shadow
      ),
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
                  'القارئ محمد السمرجي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: screenHeight * 0.023),
                Text(
                  'سورة ${widget.surahNameArabic}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Tajawal',
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
                        _filePath != null
                            ? () {} // Do nothing if surah is already downloaded
                            : () =>
                                _downloadFile('${widget.surahNameArabic}.mp3'),
                        disabled: _isDownloading,
                      ),
                      _buildControlButton(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        screenWidth,
                        () {
                          if (_isPlaying) {
                            _pauseAudio();
                          } else {
                            _playAudio();
                          }
                        },
                      ),
                      _buildControlButton(Icons.fast_forward, screenWidth, () {
                        final newPosition =
                            _currentPosition + Duration(seconds: 10);
                        _seekAudio(newPosition < _audioDuration
                            ? newPosition
                            : _audioDuration);
                      }),
                      _buildControlButton(Icons.fast_rewind, screenWidth, () {
                        final newPosition =
                            _currentPosition - Duration(seconds: 10);
                        _seekAudio(newPosition < Duration.zero
                            ? Duration.zero
                            : newPosition);
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
      IconData icon, double screenWidth, Function() onPressed,
      {bool disabled = false}) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        width: screenWidth * 0.15, // Make buttons responsive
        height: screenWidth * 0.15,
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey
              : Color(0xff264864), // Gray out button if disabled
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
