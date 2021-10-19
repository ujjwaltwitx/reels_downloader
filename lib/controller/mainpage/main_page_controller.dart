import 'package:flutter/foundation.dart';

class MainPageController extends ChangeNotifier {
  int selectIndex = 0;
  void changeIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
