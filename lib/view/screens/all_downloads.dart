import 'package:flutter/material.dart';
import 'package:reels_downloader/view/widgets/downloaded_widget.dart';

class DownloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8).copyWith(bottom: 0),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 9.0 / 16.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget(),
            DownloadedWidget()
          ],
        ),
      ),
    );
  }
}
