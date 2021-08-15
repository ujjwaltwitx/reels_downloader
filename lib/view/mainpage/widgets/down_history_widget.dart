import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:share/share.dart';

class DownloadWidget extends StatelessWidget {
  void onShare(String path) {
    Share.share(path);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
      builder: (context, Box<VideoModel> box, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (box.isEmpty) {
              return Center(
                child: SvgPicture.asset(
                  'assets/empty.svg',
                ),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final videoListReversed = box.values.toList().reversed;
                if (videoListReversed.elementAt(index) == null) {
                  return null;
                } else {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    height: constraints.maxHeight * 0.9,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: constraints.maxHeight * 0.12,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        videoListReversed
                                            .elementAt(index)
                                            .ownerThumbnailUrl,
                                      ),
                                      radius: constraints.maxHeight * 0.04,
                                    ),
                                  ),
                                  Text(videoListReversed
                                      .elementAt(index)
                                      .ownerId)
                                ],
                              ),
                              Stack(alignment: Alignment.center, children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.78,
                                  width: double.infinity,
                                  child: Image.network(
                                    videoListReversed
                                        .elementAt(index)
                                        .thumbnailUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: constraints.maxHeight * 0.78,
                                  child: IconButton(
                                    onPressed: () {
                                      OpenFile.open(videoListReversed
                                          .elementAt(index)
                                          .videoPath);
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                )
                              ]),
                              SizedBox(
                                height: constraints.maxHeight * 0.1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      splashRadius: 2,
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: videoListReversed
                                                .elementAt(index)
                                                .videoUrl,
                                          ),
                                        );
                                        Fluttertoast.showToast(
                                          msg: "Copied To Clipboard",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.white,
                                          textColor:
                                              const Color.fromRGBO(0, 0, 0, 1),
                                        );
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                    IconButton(
                                      splashRadius: 2,
                                      onPressed: () {
                                        Share.shareFiles([
                                          videoListReversed
                                              .elementAt(index)
                                              .videoPath
                                        ]);
                                      },
                                      icon: const Icon(Icons.share),
                                    ),
                                    IconButton(
                                      splashRadius: 2,
                                      onPressed: () async {
                                        final file = File(videoListReversed
                                            .elementAt(index)
                                            .videoPath);

                                        box.deleteAt(
                                            box.values.length - index - 1);
                                        await file.delete();
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
              itemCount: Hive.box<VideoModel>(videoBox).values.length,
            );
          },
        );
      },
    );
  }
}
