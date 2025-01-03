// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tryon_me/models/image_input_data.dart';
import 'package:tryon_me/services/api_service.dart';
import 'package:tryon_me/utils/routes.dart';
import 'package:tryon_me/widgets/image_input.dart';

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

      // Check if modelImageData is a file or URL
      final modelImageUrl = modelImageData!.file != null
          ? await ApiService().getImageUrl(modelImageData!)
          : modelImageData!.url;

      // Check if garmentImageData is a file or URL
      final garmentImageUrl = garmentImageData!.file != null
          ? await ApiService().getImageUrl(garmentImageData!)
          : garmentImageData!.url;

      // Ensure both URLs are valid
      if (modelImageUrl == null || garmentImageUrl == null) {
        throw Exception('Invalid image data: URLs are missing.');
      }

      // Prepare the request body
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

      // Send the request to the API
      final outputUrl = await ApiService().sendTryOnRequestToAPI(requestBody);

      setState(() {
        isProcessing = false;
      });

      // Navigate to the results screen
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
            Text('Basic Options'),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Restore Background'),
                    value: true,
                    groupValue: backgroundRestore,
                    onChanged: (value) {
                      setState(() {
                        backgroundRestore = value as bool;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('Do Not Restore Background'),
                    value: false,
                    groupValue: backgroundRestore,
                    onChanged: (value) {
                      setState(() {
                        backgroundRestore = value as bool;
                      });
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Long Garment'),
              value: longGarment,
              onChanged: (value) {
                setState(() {
                  longGarment = value as bool;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Garment Details
            Text('Garment Details'),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: category,
                    items:
                        ['tops', 'bottoms', 'one-pieces'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: garmentPhotoType,
                    items: ['auto', 'model', 'flat-lay'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        garmentPhotoType = value!;
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Garment Photo Type'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Advanced Options
            ExpansionTile(
              title: Text('Advanced Options'),
              children: [
                CheckboxListTile(
                  title: Text('Cover Feet'),
                  value: coverFeet,
                  onChanged: (value) {
                    setState(() {
                      coverFeet = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Adjust Hands'),
                  value: adjustHands,
                  onChanged: (value) {
                    setState(() {
                      adjustHands = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Restore Clothes'),
                  value: restoreClothes,
                  onChanged: (value) {
                    setState(() {
                      restoreClothes = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Guidance Scale'),
                  initialValue: guidanceScale.toString(),
                  onChanged: (value) {
                    setState(() {
                      guidanceScale = double.tryParse(value) ?? 2.0;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Timesteps'),
                  initialValue: timesteps.toString(),
                  onChanged: (value) {
                    setState(() {
                      timesteps = int.tryParse(value) ?? 50;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Seed'),
                  initialValue: seed != null ? seed.toString() : '',
                  onChanged: (value) {
                    setState(() {
                      seed = int.tryParse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of Samples'),
                  initialValue: numSamples.toString(),
                  onChanged: (value) {
                    setState(() {
                      numSamples = int.tryParse(value) ?? 1;
                    });
                  },
                ),
              ],
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
