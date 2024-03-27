import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/settings_model.dart';
import 'package:provider/provider.dart';

class SimpleSlider extends StatefulWidget {
  final Color? thumbColor, activeColor, inactiveColor;
  final int? divisions;

  const SimpleSlider(
      {Key? key,
      this.thumbColor,
      this.activeColor,
      this.inactiveColor,
      this.divisions})
      : super(key: key);

  @override
  SimpleSliderState createState() => SimpleSliderState();
}

class SimpleSliderState extends State<SimpleSlider> {
  
  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return Slider(
      value: settingsModel.getCurrentSliderValue,
      min: 100,
      max: 360, 
      label: settingsModel.getCurrentSliderValue.toInt().toString(),
      thumbColor: widget.thumbColor,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,  
      divisions: widget.divisions,
      onChanged: (double value) {
        setState(() {
          settingsModel.changeSliderValue(value);
        });
      },
    );
  }
}
