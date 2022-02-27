import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/view/widgets/downloaded_widget.dart';

import '../../main.dart';
import '../../model/video/video_model.dart';

class DownloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Downloads",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
          builder: (context, Box<VideoModel> box, _) {
            final List videoList = box.values.toList();
            final videoListReversed = box.values.toList().reversed;
            int index = 0;
            return Container(
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
                children: videoListReversed.map((e) {
                  index += 1;
                  return DownloadedWidget(
                    videoModel: e,
                    onTap: () {
                      File(e.videoPath).delete();
                      Hive.box<VideoModel>(videoBox).deleteAt(
                        videoList.indexOf(e),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ));
  }
}
