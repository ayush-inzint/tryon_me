import 'package:flutter/material.dart';
import 'package:tryon_me/models/image_input_data.dart';
import 'package:tryon_me/services/api_service.dart';
import 'package:tryon_me/utils/routes.dart';
import 'package:tryon_me/widgets/image_input.dart';
import 'package:tryon_me/widgets/parameter_controls.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ImageInputData? modelImageData;
  ImageInputData? garmentImageData;
  bool backgroundRestore = true;
  bool longGarment = false;
  int samplingSteps = 20;
  double temperature = 1.0;
  int? seed;
  bool isProcessing = false;

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

      final outputUrl = await sendTryOnRequestToAPI(
        modelImageFile: modelImageData!.file,
        modelImageUrl: modelImageData!.url,
        garmentImageFile: garmentImageData!.file,
        garmentImageUrl: garmentImageData!.url,
        backgroundRestore: backgroundRestore,
        longGarment: longGarment,
        samplingSteps: samplingSteps,
        temperature: temperature,
        seed: seed,
      );

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

            // Advanced Options
            ExpansionTile(
              title: Text('Advanced Options'),
              children: [
                ParameterControls(
                  samplingSteps: samplingSteps,
                  temperature: temperature,
                  seed: seed,
                  onSamplingStepsChanged: (value) {
                    setState(() {
                      samplingSteps = value;
                    });
                  },
                  onTemperatureChanged: (value) {
                    setState(() {
                      temperature = value;
                    });
                  },
                  onSeedChanged: (value) {
                    setState(() {
                      seed = value;
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
