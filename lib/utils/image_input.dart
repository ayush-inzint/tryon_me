// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
// import 'package:your_project/models/image_input_data.dart'; // Replace with actual path

// class ImageInput extends StatefulWidget {
//   final ImageInputType type;
//   final Function(ImageInputData) onImageSelected;

//   ImageInput({required this.type, required this.onImageSelected});

//   @override
//   _ImageInputState createState() => _ImageInputState();
// }

// class _ImageInputState extends State<ImageInput> {
//   String _selectedMethod = 'file';
//   File? _selectedFile;
//   String? _selectedUrl;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.type == ImageInputType.garment) {
//       _selectedMethod = 'url';
//     }
//   }

//   void _selectMethod(String method) {
//     setState(() {
//       _selectedMethod = method;
//       _selectedFile = null;
//       _selectedUrl = null;
//     });
//   }

//   Future<void> _pickFile() async {
//     final file = await pickImage(context);
//     if (file != null) {
//       setState(() {
//         _selectedFile = file;
//       });
//       widget.onImageSelected(ImageInputData(file: file));
//     }
//   }

//   void _setUrl(String url) {
//     setState(() {
//       _selectedUrl = url;
//     });
//     widget.onImageSelected(ImageInputData(url: url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Radio(
//               value: 'file',
//               groupValue: _selectedMethod,
//               onChanged: (value) {
//                 _selectMethod(value as String);
//               },
//             ),
//             Text('Upload File'),
//             Radio(
//               value: 'url',
//               groupValue: _selectedMethod,
//               onChanged: (value) {
//                 _selectMethod(value as String);
//               },
//             ),
//             Text('Paste URL'),
//           ],
//         ),
//         if (_selectedMethod == 'file')
//           Column(
//             children: [
//               ElevatedButton(
//                 onPressed: _pickFile,
//                 child: Text('Select File'),
//               ),
//               if (_selectedFile != null)
//                 Image.file(
//                   _selectedFile!,
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.cover,
//                 ),
//             ],
//           )
//         else
//           Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Image URL'),
//                 onSubmitted: _setUrl,
//               ),
//               if (_selectedUrl != null)
//                 Image.network(
//                   _selectedUrl!,
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.cover,
//                 ),
//             ],
//           ),
//       ],
//     );
//   }
// }
