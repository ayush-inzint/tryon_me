import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final String outputImageUrl;

  ResultsScreen({required this.outputImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              outputImageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return Text('Failed to load image.');
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement save functionality
                  },
                  child: Text('Save Image'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement share functionality
                  },
                  child: Text('Share Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
