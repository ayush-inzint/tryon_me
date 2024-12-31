import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

/// Shows a snackbar with the given message and color.
void showSnackBar(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: color,
      ),
    );
}

/// Picks an image from the gallery or file system.
/// Handles permissions for Android 13+ and older versions.
Future<File?> pickImage(BuildContext context) async {
  try {
    PermissionStatus status;

    // Check Android version
    if (Platform.isAndroid &&
        await DeviceInfoPlugin()
                .androidInfo
                .then((info) => info.version.sdkInt) >=
            33) {
      // Android 13+ requires READ_MEDIA_IMAGES for accessing images
      status = await Permission.photos.request();
    } else {
      // For older Android versions, use storage permission
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Permission granted, proceed to pick image
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (filePickerResult != null) {
        return File(filePickerResult.files.first.path!);
      }
    } else if (status.isDenied) {
      // Permission denied, show a message or handle accordingly
      showSnackBar(
        context,
        'Permission denied to access photos',
        Colors.red,
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, guide the user to app settings
      showSnackBar(
        context,
        'Please grant permission to access photos from app settings',
        Colors.red,
      );
      openAppSettings();
    }
    return null;
  } catch (e) {
    print('Error picking image: $e');
    return null;
  }
}

/// Validates if the provided image URL is accessible.
Future<bool> validateImageUrl(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    print('Error validating image URL: $e');
    return false;
  }
}
