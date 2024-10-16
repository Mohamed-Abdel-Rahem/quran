import 'dart:async'; // Add this import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quran/widgets/backgroun_build.dart';
import 'package:quran/widgets/custom_text_widget.dart';

class RoquiaPage extends StatefulWidget {
  const RoquiaPage({super.key});

  @override
  _RoquiaPageState createState() => _RoquiaPageState();
}

class _RoquiaPageState extends State<RoquiaPage> {
  bool _isDownloading = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  // ignore: unused_field
  bool _isStreaming = false;
  String? _filePath;
  String? _streamingUrl;
  Duration _currentPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _dialogShown = false;
  // ignore: prefer_final_fields
  bool _isConnected = true;
  double _downloadProgress = 0.0; // To store the download progress
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  @override
  void initState() {
    super.initState();

    // Check if file exists locally
    _checkFileExists('الرقية.mp3').then((fileExists) {
      if (fileExists) {
        return;
      } else {
        // Check for internet connection if the file doesn't exist.
        _checkInternetConnection().then((isConnecteddd) {
          if (isConnecteddd) {
            return; // Play stream if connected to the internet.
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
    // Connectivity listener
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Pause download if downloading
        if (_isDownloading) {
          _pauseDownload();
        }
        _pauseAudio(); // Pause audio when no internet
        if (_filePath == null) {
          _showNoInternetDialog(); // Show dialog only if file is not downloaded
        }
      } else {
        // Resume download if needed
        if (!_isConnected && _isDownloading) {
          _resumeDownload('الرقية.mp3');
        }

        if (_isPaused) {
          _resumeAudio(); // Resume audio if internet is restored
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _pauseDownload() async {
    if (_isDownloading) {
      try {
        // Pause the download and save the current progress
        setState(() {
          _isDownloading = false;
        });
      } catch (e) {
        print('Error pausing download: $e');
      }
    }
  }

  Future<void> _resumeDownload(String fileName) async {
    // Resume download from where it was paused
    await _downloadFile(
        fileName); // You can enhance this further with custom logic if needed
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

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0; // Reset download progress
    });

    final ref = FirebaseStorage.instance.ref().child(fileName);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    // Store current downloaded bytes to resume later if needed
    int downloadedBytes = 0;

    try {
      if (await file.exists()) {
        downloadedBytes =
            file.lengthSync(); // Get how much of the file is already downloaded
      }

      final task = ref.writeToFile(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Update the download progress
        if (mounted) {
          setState(() {
            _downloadProgress = snapshot.bytesTransferred /
                snapshot.totalBytes; // Calculate the progress
          });
        }
      });

      await task; // Wait for the download to complete

      if (mounted) {
        setState(() {
          _filePath = file.path;
          _isDownloading = false; // Reset downloading state
          _downloadProgress = 0.0; // Reset progress indicator
        });
      }
    } catch (e) {
      // Handle any download interruption (e.g., connection lost)
      print('Download interrupted: $e');

      if (mounted) {
        setState(() {
          _isDownloading = false; // Reset downloading state
        });
      }
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
        await _playStream('الرقية.mp3');
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const BackgrounBuild(),
          Positioned(
            top: -screenSize.width * 0.25,
            right: -screenSize.width * 0.25,
            child: Image.asset(
              'assets/ellipse/Ellipse 10.png',
              width: screenSize.width * 1.1,
              height: screenSize.width * 1.1,
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.09),
                const Row(
                  children: [
                    CustomTextWidget(
                      text: 'الرقيه الشرعيه',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.05),
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
                SizedBox(height: screenHeight * 0.07),
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
                  'الرقية الشرعية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'Tajawal',
                  ),
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildControlButton(
                        _filePath != null ? Icons.check : Icons.download,
                        screenWidth,
                        _filePath != null
                            ? () {} // Do nothing if surah is already downloaded
                            : () {
                                if (!_isDownloading) {
                                  _downloadFile('الرقية.mp3');
                                }
                              },
                        disabled: _isDownloading,
                        isDownloadButton: true),
                    buildControlButton(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        screenWidth, () {
                      if (_isPlaying) {
                        _pauseAudio();
                      } else {
                        _playAudio();
                      }
                    }, isDownloadButton: false),
                    buildControlButton(Icons.fast_forward, screenWidth, () {
                      final newPosition =
                          _currentPosition + Duration(seconds: 10);
                      _seekAudio(newPosition < _audioDuration
                          ? newPosition
                          : _audioDuration);
                    }, isDownloadButton: false),
                    buildControlButton(Icons.fast_rewind, screenWidth, () {
                      final newPosition =
                          _currentPosition - Duration(seconds: 10);
                      _seekAudio(newPosition < Duration.zero
                          ? Duration.zero
                          : newPosition);
                    }, isDownloadButton: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildControlButton(
      IconData icon, double screenWidth, Function() onPressed,
      {bool disabled = false, bool isDownloadButton = false}) {
    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              // Check internet connection before downloading
              _checkInternetConnection().then((isConnected) {
                if (isConnected) {
                  onPressed(); // Call the original onPressed function
                } else {
                  _showNoInternetDialog(); // Show no internet dialog
                }
              });
            },
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            if (isDownloadButton &&
                _isDownloading) // Show progress only on the download button
              Positioned(
                child: CircularProgressIndicator(
                  value: _downloadProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blueAccent, // Progress color
                  ),
                  backgroundColor: Colors.white.withOpacity(
                      0.2), // Background color of the progress circle
                  strokeWidth:
                      4.0, // Adjust the thickness of the progress indicator
                ),
              ),
          ],
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
