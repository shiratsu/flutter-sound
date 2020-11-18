import 'package:flutter/material.dart';

class SoundDurationProvider with ChangeNotifier {
  double value = 0;

  void setValue(double newValue) {
    value = newValue;
    notifyListeners();
  }

  double getValue() {
    return value;
  }
}
