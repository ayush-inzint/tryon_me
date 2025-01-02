import 'package:flutter/material.dart';

class GarmentDetails extends StatelessWidget {
  final String category;
  final String garmentPhotoType;
  final Function(String) onCategoryChanged;
  final Function(String) onGarmentPhotoTypeChanged;

  GarmentDetails({
    required this.category,
    required this.garmentPhotoType,
    required this.onCategoryChanged,
    required this.onGarmentPhotoTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Garment Details'),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: category,
                items: ['tops', 'bottoms', 'one-pieces'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => onCategoryChanged(value!),
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
                onChanged: (value) => onGarmentPhotoTypeChanged(value!),
                decoration: InputDecoration(labelText: 'Garment Photo Type'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
