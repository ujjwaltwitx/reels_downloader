import 'package:flutter/material.dart';
import 'package:reels_downloader/view/mainpage/widgets/photoscreen.dart';
import 'package:reels_downloader/view/mainpage/widgets/videoscreen.dart';

class DownloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                  child: const TabBar(
                    indicatorColor: Colors.pink,
                    tabs: [
                      Text("Videos", style: TextStyle(color: Colors.pink)),
                      Text("Photos", style: TextStyle(color: Colors.pink)),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.95,
                  child: TabBarView(
                    children: [
                      VideoScreen(),
                      PhotoScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
