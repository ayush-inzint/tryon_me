// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tryon_me/models/image_input_data.dart';
import 'package:tryon_me/services/api_service.dart';
import 'package:tryon_me/utils/routes.dart';
import 'package:tryon_me/widgets/image_input.dart';
import 'package:tryon_me/widgets/garment_details.dart';
import 'package:tryon_me/widgets/basic_options.dart';
import 'package:tryon_me/widgets/advanced_options.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ImageInputData? modelImageData;
  ImageInputData? garmentImageData;
  bool backgroundRestore = true;
  bool longGarment = false;
  double guidanceScale = 2.0;
  int timesteps = 50;
  int? seed;
  int numSamples = 1;
  bool isProcessing = false;

  String category = 'tops';
  String garmentPhotoType = 'auto';
  bool coverFeet = false;
  bool adjustHands = false;
  bool restoreClothes = false;

  void _onModelImageSelected(ImageInputData data) {
    setState(() {
      modelImageData = data;
    });
  }

  void _onGarmentImageSelected(ImageInputData data) {
    setState(() {
      garmentImageData = data;
    });
  }

  Future<void> sendTryOnRequest() async {
    if (modelImageData == null || garmentImageData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please provide both model and garment images.')),
      );
      return;
    }

    try {
      setState(() {
        isProcessing = true;
      });

      final modelImageUrl = await ApiService().getImageUrl(modelImageData!);
      final garmentImageUrl = await ApiService().getImageUrl(garmentImageData!);

      final requestBody = {
        "model_image": modelImageUrl,
        "garment_image": garmentImageUrl,
        "category": category,
        "garment_photo_type": garmentPhotoType,
        "nsfw_filter": true,
        "cover_feet": coverFeet,
        "adjust_hands": adjustHands,
        "restore_background": backgroundRestore,
        "restore_clothes": restoreClothes,
        "long_top": longGarment,
        "guidance_scale": guidanceScale,
        "timesteps": timesteps,
        "seed": seed,
        "num_samples": numSamples,
      };

      final outputUrl = await ApiService().sendTryOnRequestToAPI(requestBody);

      setState(() {
        isProcessing = false;
      });

      Navigator.pushNamed(
        context,
        Routes.resultsScreen,
        arguments: outputUrl,
      );
    } catch (e) {
      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API request failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Try-On Me')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model Image Input
            Text('Model Image'),
            SizedBox(height: 8.0),
            ImageInput(
              type: ImageInputType.model,
              onImageSelected: _onModelImageSelected,
            ),
            SizedBox(height: 16.0),

            // Garment Image Input
            Text('Garment Image'),
            SizedBox(height: 8.0),
            ImageInput(
              type: ImageInputType.garment,
              onImageSelected: _onGarmentImageSelected,
            ),
            SizedBox(height: 16.0),

            // Basic Options
            BasicOptions(
              backgroundRestore: backgroundRestore,
              longGarment: longGarment,
              onBackgroundRestoreChanged: (value) {
                setState(() {
                  backgroundRestore = value;
                });
              },
              onLongGarmentChanged: (value) {
                setState(() {
                  longGarment = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Garment Details
            GarmentDetails(
              category: category,
              garmentPhotoType: garmentPhotoType,
              onCategoryChanged: (value) {
                setState(() {
                  category = value;
                });
              },
              onGarmentPhotoTypeChanged: (value) {
                setState(() {
                  garmentPhotoType = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Advanced Options
            AdvancedOptions(
              coverFeet: coverFeet,
              adjustHands: adjustHands,
              restoreClothes: restoreClothes,
              guidanceScale: guidanceScale,
              timesteps: timesteps,
              seed: seed,
              numSamples: numSamples,
              onCoverFeetChanged: (value) {
                setState(() {
                  coverFeet = value;
                });
              },
              onAdjustHandsChanged: (value) {
                setState(() {
                  adjustHands = value;
                });
              },
              onRestoreClothesChanged: (value) {
                setState(() {
                  restoreClothes = value;
                });
              },
              onGuidanceScaleChanged: (value) {
                setState(() {
                  guidanceScale = value;
                });
              },
              onTimestepsChanged: (value) {
                setState(() {
                  timesteps = value;
                });
              },
              onSeedChanged: (value) {
                setState(() {
                  seed = value;
                });
              },
              onNumSamplesChanged: (value) {
                setState(() {
                  numSamples = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Try On Button
            ElevatedButton(
              onPressed: isProcessing ? null : sendTryOnRequest,
              child:
                  isProcessing ? CircularProgressIndicator() : Text('Try On'),
            ),
          ],
        ),
      ),
    );
  }
}
