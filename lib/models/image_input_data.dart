import 'dart:io';

class ImageInputData {
  final String? url;
  final File? file;

  ImageInputData({this.url, this.file});
}

enum ImageInputType { model, garment }
