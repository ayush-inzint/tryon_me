import 'package:flutter/material.dart';

class AdvancedOptions extends StatelessWidget {
  final bool coverFeet;
  final bool adjustHands;
  final bool restoreClothes;
  final double guidanceScale;
  final int timesteps;
  final int? seed;
  final int numSamples;
  final Function(bool) onCoverFeetChanged;
  final Function(bool) onAdjustHandsChanged;
  final Function(bool) onRestoreClothesChanged;
  final Function(double) onGuidanceScaleChanged;
  final Function(int) onTimestepsChanged;
  final Function(int?) onSeedChanged;
  final Function(int) onNumSamplesChanged;

  AdvancedOptions({
    required this.coverFeet,
    required this.adjustHands,
    required this.restoreClothes,
    required this.guidanceScale,
    required this.timesteps,
    required this.seed,
    required this.numSamples,
    required this.onCoverFeetChanged,
    required this.onAdjustHandsChanged,
    required this.onRestoreClothesChanged,
    required this.onGuidanceScaleChanged,
    required this.onTimestepsChanged,
    required this.onSeedChanged,
    required this.onNumSamplesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Advanced Options'),
      children: [
        CheckboxListTile(
          title: Text('Cover Feet'),
          value: coverFeet,
          onChanged: (value) => onCoverFeetChanged(value!),
        ),
        CheckboxListTile(
          title: Text('Adjust Hands'),
          value: adjustHands,
          onChanged: (value) => onAdjustHandsChanged(value!),
        ),
        CheckboxListTile(
          title: Text('Restore Clothes'),
          value: restoreClothes,
          onChanged: (value) => onRestoreClothesChanged(value!),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Guidance Scale'),
          initialValue: guidanceScale.toString(),
          onChanged: (value) =>
              onGuidanceScaleChanged(double.tryParse(value) ?? 2.0),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Timesteps'),
          initialValue: timesteps.toString(),
          onChanged: (value) => onTimestepsChanged(int.tryParse(value) ?? 50),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Seed'),
          initialValue: seed != null ? seed.toString() : '',
          onChanged: (value) => onSeedChanged(int.tryParse(value)),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Number of Samples'),
          initialValue: numSamples.toString(),
          onChanged: (value) => onNumSamplesChanged(int.tryParse(value) ?? 1),
        ),
      ],
    );
  }
}
