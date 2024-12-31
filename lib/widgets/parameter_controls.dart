import 'package:flutter/material.dart';

class ParameterControls extends StatefulWidget {
  final int samplingSteps;
  final double temperature;
  final int? seed;
  final Function(int) onSamplingStepsChanged;
  final Function(double) onTemperatureChanged;
  final Function(int?) onSeedChanged;

  ParameterControls({
    required this.samplingSteps,
    required this.temperature,
    required this.seed,
    required this.onSamplingStepsChanged,
    required this.onTemperatureChanged,
    required this.onSeedChanged,
  });

  @override
  _ParameterControlsState createState() => _ParameterControlsState();
}

class _ParameterControlsState extends State<ParameterControls> {
  final TextEditingController seedController = TextEditingController();

  @override
  void initState() {
    if (widget.seed != null) {
      seedController.text = widget.seed.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    seedController.dispose();
    super.dispose();
  }

  void updateSamplingSteps(double value) {
    widget.onSamplingStepsChanged(value.toInt());
  }

  void updateTemperature(double value) {
    widget.onTemperatureChanged(value);
  }

  void updateSeed(String value) {
    if (value.isEmpty) {
      widget.onSeedChanged(null);
    } else {
      int? seed = int.tryParse(value);
      if (seed != null) {
        widget.onSeedChanged(seed);
      } else {
        // Show error or ignore invalid input
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sampling Steps
        Text('Sampling Steps'),
        Slider(
          value: widget.samplingSteps.toDouble(),
          min: 10.0,
          max: 50.0,
          divisions: 40,
          label: '${widget.samplingSteps}',
          onChanged: (value) {
            setState(() {
              updateSamplingSteps(value);
            });
          },
        ),
        // Temperature
        Text('Temperature'),
        Slider(
          value: widget.temperature,
          min: 0.1,
          max: 2.0,
          divisions: 20,
          label: '${widget.temperature.toStringAsFixed(1)}',
          onChanged: (value) {
            setState(() {
              updateTemperature(value);
            });
          },
        ),
        // Seed
        Text('Seed (optional)'),
        TextField(
          controller: seedController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            updateSeed(value);
          },
          decoration: InputDecoration(
            hintText: 'Enter seed value',
          ),
        ),
      ],
    );
  }
}
