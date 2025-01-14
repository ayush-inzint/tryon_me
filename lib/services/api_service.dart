import 'package:cross_file/cross_file.dart';
import 'package:fal_client/fal_client.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tryon_me/models/image_input_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Initialize FalClient with your API key
  final fal = FalClient.withCredentials('');
  
  final falImg = FalClient.withCredentials(
      '');

  /// Uploads a file to Fal's storage and returns the URL.
  Future<String> getImageUrl(ImageInputData data) async {
    try {
      if (data.file != null) {
        // Convert File to XFile
        final xFile = XFile(data.file!.path);

        // Upload the file to Fal's storage
        final url = await falImg.storage.upload(xFile);
        return url;
      } else if (data.url != null) {
        // If the image is already a URL, return it directly
        return data.url!;
      } else {
        throw Exception('No image provided');
      }
    } catch (e) {
      print('Failed to get image URL: $e');
      throw Exception('Failed to get image URL: $e');
    }
  }

  /// Sends a try-on request to the Fal AI API and returns the output URL.
  Future<String> sendTryOnRequestToAPI(Map<String, dynamic> requestBody) async {
    debugPrint('Sending try-on request to API... $requestBody');
    try {
      // Step 1: Submit the request to the queue
      final submitResponse = await fal.queue.submit("fashn/tryon", input: requestBody);

      // Extract the request ID
      final requestId = submitResponse.requestId;
      debugPrint('Request submitted. Request ID: $requestId');

      // Step 2: Poll the queue to check the status of the request
      var statusResponse =
          await fal.queue.status("fashn/tryon", requestId: requestId);
      debugPrint('Polling status... Current status: ${statusResponse.status}');

      while (statusResponse.status != 'COMPLETED' &&
          statusResponse.status != 'failed') {
        await Future.delayed(Duration(seconds: 2)); // Poll every 2 seconds
        statusResponse =
            await fal.queue.status("fashn/tryon", requestId: requestId);
        debugPrint(
            'Polling status... Current status: ${statusResponse.status}');
      }

      // Handle failed status
      if (statusResponse.status == 'failed') {
        throw Exception('Request failed: ${statusResponse.status}');
      }

      // Step 3: Retrieve the result once the request is completed
      final resultResponse =
          await fal.queue.result("fashn/tryon", requestId: requestId);

      // Validate the result response
      if (resultResponse.data['images'] == null ||
          resultResponse.data['images'].isEmpty) {
        throw Exception('Invalid result format: No images found');
      }

      // Extract the output URL from the result
      final outputUrl = resultResponse.data['images'][0]['url'];
      debugPrint('Request completed. Output URL: $outputUrl');

      return outputUrl;
    } catch (e) {
      debugPrint('API request failed: $e');
      throw Exception('API request failed: $e');
    }
  }
}
