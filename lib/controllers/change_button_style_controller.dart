import 'package:flutter/cupertino.dart';

class ChangeButtonStyleController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  setCurrentIndexVal(int newVal) {
    _currentIndex = newVal;
    notifyListeners();
  }
}
