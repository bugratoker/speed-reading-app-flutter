import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier{

  double _currentSliderValue = 260;
  //there will be also some another settings value
  double get getCurrentSliderValue => _currentSliderValue;

  SettingsModel();

  void changeSliderValue(double newValue){
    _currentSliderValue = newValue;
    print("currentSliderValue From Model : ${_currentSliderValue}");
    notifyListeners();
  }
}