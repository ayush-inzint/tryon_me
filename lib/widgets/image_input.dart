import 'package:flutter/material.dart';
import 'package:tryon_me/models/image_input_data.dart';
import 'package:tryon_me/utils/image_utils.dart';
import 'dart:io';
 
class ImageInput extends StatefulWidget {
  final ImageInputType type;
  final Function(ImageInputData) onImageSelected;
 
  ImageInput({required this.type, required this.onImageSelected});
 
  @override
  _ImageInputState createState() => _ImageInputState();
}
 
class _ImageInputState extends State<ImageInput> {
  String _selectedMethod = 'file';
  File? _selectedFile;
  String? _selectedUrl;
  final urlController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    // Set default method based on the type
    if (widget.type == ImageInputType.garment) {
      _selectedMethod = 'url';
    }
  }
 
  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
      _selectedFile = null;
      _selectedUrl = null;
    });
  }
 
  Future<void> _pickFile() async {
    final file = await pickImage(context);
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
      widget.onImageSelected(ImageInputData(file: file));
    }
  }
 
  void _setUrl(String url) {
    setState(() {
      _selectedUrl = url;
    });
    widget.onImageSelected(ImageInputData(url: url));
  }
 
  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ToggleButtons(
            constraints: const BoxConstraints(
              minWidth: 140,
              minHeight: 30,
            ),
            borderRadius: BorderRadius.circular(16.0),
            isSelected: [_selectedMethod == 'file', _selectedMethod == 'url'],
            onPressed: (index) {
              _selectMethod(index == 0 ? 'file' : 'url');
            },
            selectedColor: Colors.white,
            fillColor: const Color.fromARGB(255, 219, 80, 210),
            color: Colors.black,
            borderColor: const Color.fromARGB(255, 224, 43, 221),
            selectedBorderColor: const Color.fromARGB(255, 235, 45, 212),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Upload File',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Paste URL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_selectedMethod == 'file')
          Column(
            children: [
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(
                    Icons.upload_file,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Select File',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blueAccent.withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedFile != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      _selectedFile!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          )
        else
          Column(
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: _setUrl,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  _setUrl(urlController.text);
                },
                icon: const Icon(Icons.link),
                label: const Text('Set URL'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              if (_selectedUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _selectedUrl!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
