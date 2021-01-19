import 'package:flutter/material.dart';

class NoValueNotifier extends ChangeNotifier {
  notify() {
    notifyListeners();
  }
}

class ProgressNotifier extends ChangeNotifier {
  bool isShowing = false;

  show(bool isShowing) {
    this.isShowing = isShowing;
    notifyListeners();
  }
}
