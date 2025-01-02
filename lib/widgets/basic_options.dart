import 'package:flutter/material.dart';

class BasicOptions extends StatelessWidget {
  final bool backgroundRestore;
  final bool longGarment;
  final Function(bool) onBackgroundRestoreChanged;
  final Function(bool) onLongGarmentChanged;

  BasicOptions({
    required this.backgroundRestore,
    required this.longGarment,
    required this.onBackgroundRestoreChanged,
    required this.onLongGarmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Options'),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text('Restore Background'),
                value: true,
                groupValue: backgroundRestore,
                onChanged: (value) => onBackgroundRestoreChanged(value as bool),
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text('Do Not Restore Background'),
                value: false,
                groupValue: backgroundRestore,
                onChanged: (value) => onBackgroundRestoreChanged(value as bool),
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: Text('Long Garment'),
          value: longGarment,
          onChanged: (value) => onLongGarmentChanged(value as bool),
        ),
      ],
    );
  }
}
