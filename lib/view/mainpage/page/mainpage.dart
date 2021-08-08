import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_downloader/view/mainpage/widgets/download_widget.dart';
import '../../../controller/mainpage/main_page_controller.dart';
import '../widgets/home_widget.dart';

final mainControllerProvider =
    ChangeNotifierProvider<MainPageController>((ref) {
  return MainPageController();
});

class MainPage extends ConsumerWidget {
  final widgetList = [HomeWidget(), DownloadWidget()];
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final statusHeight = MediaQuery.of(context).padding.top;
    final mainPageController = watch(mainControllerProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: (constraints.maxHeight - statusHeight) * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.menu)),
                      const Text("Insta Reels"),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.settings)),
                    ],
                  ),
                ),
                SizedBox(
                    height: (constraints.maxHeight - statusHeight) * 0.83,
                    child: widgetList.elementAt(mainPageController.selectIndex))
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: (constraints.maxHeight - statusHeight) * 0.09,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.download),
                label: "Downloads",
              ),
            ],
            currentIndex: mainPageController.selectIndex,
            fixedColor: Colors.pink,
            onTap: (int index) {
              mainPageController.changeIndex(index);
            },
          ),
        ),
      );
    });
  }
}
