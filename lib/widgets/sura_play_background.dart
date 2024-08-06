import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'سورة الاخلاص',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/backgroundsura.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),
          // Content overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enlarged circular icon with border and shadow
                Container(
                  width: screenWidth * 0.55, // Responsive width
                  height: screenWidth *
                      0.55, // Responsive height (maintains square aspect ratio)
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color of the circle
                    border: Border.all(
                        color: Colors.blueAccent,
                        width: 4), // Border color and width
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/suraicon.png', // Replace with your icon
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03), // Responsive spacing

                // Text elements
                Text(
                  'سورة الاخلاص',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.023),
                Text(
                  'Surah Al-Ikhlas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04, // Responsive font size
                  ),
                ),

                SizedBox(height: screenHeight * 0.22), // Responsive spacing

                // Progress bar with custom height
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05), // Responsive margins
                  child: LinearProgressIndicator(
                    value: 0.5, // Replace with actual progress value
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: screenHeight * 0.01, // Responsive height
                  ),
                ),

                SizedBox(height: screenHeight * 0.03), // Responsive spacing

                // Control buttons with consistent size and padding
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(Icons.replay_10, screenWidth),
                    _buildControlButton(Icons.play_arrow, screenWidth),
                    _buildControlButton(Icons.pause, screenWidth),
                    _buildControlButton(Icons.forward_10, screenWidth),
                    _buildControlButton(Icons.repeat, screenWidth),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, double screenWidth) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      iconSize: screenWidth * 0.08, // Responsive icon size
      padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
      onPressed: () {},
    );
  }
}
