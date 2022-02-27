import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainControllerProvider =
    ChangeNotifierProvider<MainPageController>((ref) {
  return MainPageController();
});

class MainPageController extends ChangeNotifier {
  int selectIndex = 0;
  void changeIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
