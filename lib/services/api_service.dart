// import 'package:http/http.dart' as http;
// import 'package:tryon_me/utils/constants.dart';
// import 'dart:convert';

// Future<String> sendTryOnRequestToAPI({
//   required String modelImageUrl,
//   required String garmentImageUrl,
//   bool backgroundRestore = true,
//   bool longGarment = false,
//   int samplingSteps = 20,
//   double temperature = 1.0,
//   int? seed,
// }) async {
//   final url = Uri.parse(apiUrl);
//   final headers = {
//     'Authorization': 'Bearer $apiKey',
//     'Content-Type': 'application/json',
//   };

//   final requestBody = {
//     'model_name': 'fashn/tryon',
//     'image_url': modelImageUrl,
//     'garment_url': garmentImageUrl,
//     'background_restore': backgroundRestore,
//     'long_garment': longGarment,
//     'sampling_steps': samplingSteps,
//     'temperature': temperature,
//     if (seed != null) 'seed': seed,
//   };

//   try {
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(requestBody),
//     );

//     if (response.statusCode == 200) {
//       final responseBody = jsonDecode(response.body);
//       final outputUrl = responseBody['output_url'];
//       if (outputUrl is String) {
//         return outputUrl;
//       } else {
//         throw Exception('Invalid output URL format.');
//       }
//     } else {
//       final errorResponse = jsonDecode(response.body);
//       final errorMessage =
//           errorResponse['message'] ?? 'Unknown error occurred.';
//       throw Exception(
//           'API request failed with status ${response.statusCode}: $errorMessage');
//     }
//   } catch (e) {
//     throw Exception('API request failed: $e');
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:tryon_me/utils/constants.dart';

Future<String> sendTryOnRequestToAPI({
  File? modelImageFile,
  String? modelImageUrl,
  File? garmentImageFile,
  String? garmentImageUrl,
  bool backgroundRestore = true,
  bool longGarment = false,
  int samplingSteps = 20,
  double temperature = 1.0,
  int? seed,
}) async {
  if ((modelImageFile != null && modelImageUrl != null) ||
      (garmentImageFile != null && garmentImageUrl != null)) {
    throw Exception('Only one input method should be used per image.');
  }

  if ((modelImageFile == null && modelImageUrl == null) ||
      (garmentImageFile == null && garmentImageUrl == null)) {
    throw Exception('Both model and garment images are required.');
  }

  final url = Uri.parse(apiUrl);
  final headers = {
    'Authorization': 'Bearer $apiKey',
  };

  final request = http.MultipartRequest('POST', url)..headers.addAll(headers);

  // Model image
  if (modelImageFile != null) {
    request.files.add(
        await http.MultipartFile.fromPath('model_image', modelImageFile.path));
  } else if (modelImageUrl != null) {
    request.fields['model_image_url'] = modelImageUrl;
  }

  // Garment image
  if (garmentImageFile != null) {
    request.files.add(await http.MultipartFile.fromPath(
        'garment_image', garmentImageFile.path));
  } else if (garmentImageUrl != null) {
    request.fields['garment_image_url'] = garmentImageUrl;
  }

  // Additional parameters
  request.fields['background_restore'] = backgroundRestore.toString();
  request.fields['long_garment'] = longGarment.toString();
  request.fields['sampling_steps'] = samplingSteps.toString();
  request.fields['temperature'] = temperature.toString();
  if (seed != null) {
    request.fields['seed'] = seed.toString();
  }

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      final outputUrl = jsonResponse['output_url'];
      if (outputUrl is String) {
        return outputUrl;
      } else {
        throw Exception('Invalid output URL format.');
      }
    } else {
      final errorResponse = jsonDecode(responseBody);
      final errorMessage =
          errorResponse['message'] ?? 'Unknown error occurred.';
      throw Exception(
          'API request failed with status ${response.statusCode}: $errorMessage');
    }
  } catch (e) {
    throw Exception('API request failed: $e');
  }
}
