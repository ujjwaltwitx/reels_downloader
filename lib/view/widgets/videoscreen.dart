import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import '../../../main.dart';
import '../../../model/video/video_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final videoListReversed = box.values.toList().reversed;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  height: constraints.maxHeight * 0.9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(5),
                                height: constraints.maxHeight * 0.08,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    launch(
                                      "https://www.instagram.com/${videoListReversed.elementAt(index).ownerId}",
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      videoListReversed
                                          .elementAt(index)
                                          .ownerThumbnailUrl,
                                    ),
                                    radius: constraints.maxHeight * 0.03,
                                  ),
                                ),
                              ),
                              Text(
                                videoListReversed.elementAt(index).ownerId,
                                style: const TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: constraints.maxHeight * 0.8,
                                width: double.infinity,
                                child: Image.file(
                                  File(
                                    videoListReversed
                                        .elementAt(index)
                                        .thumbnailPath,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: constraints.maxHeight * 0.8,
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.08,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  splashRadius: 2,
                                  onPressed: () async {
                                    final file = File(
                                      videoListReversed
                                          .elementAt(index)
                                          .videoPath,
                                    );
                                    box.deleteAt(box.values.length - index - 1);
                                    await file.delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  ),
                                ),
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
                                      msg: "Video Link Copied To Clipboard",
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.white,
                                      textColor:
                                          const Color.fromRGBO(0, 0, 0, 1),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.black54,
                                  ),
                                ),
                                IconButton(
                                  splashRadius: 2,
                                  onPressed: () {
                                    Share.shareFiles(
                                      [
                                        videoListReversed
                                            .elementAt(index)
                                            .videoPath
                                      ],
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
              itemCount: Hive.box<VideoModel>(videoBox).values.length,
            );
          },
        );
      },
    );
  }
}
