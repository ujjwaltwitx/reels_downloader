import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:reels_downloader/controller/download_controller/download_services.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downloadProvider = watch(downloadNotifier);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.08,
          ),
          const Text("Download Status"),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<VideoModel>(videoBox).listenable(),
                    builder: (context, Box<VideoModel> box, _) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: downloadProvider.isButtonDisabled
                                ? null
                                : () {
                                    OpenFile.open(Hive.box<VideoModel>(videoBox)
                                        .values
                                        .last
                                        .videoPath);
                                  },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 1,
                                  width: constraints.maxWidth * 0.16,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      box.values.last.thumbnailUrl,
                                      fit: BoxFit.cover,
                                      isAntiAlias: true,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launch(
                                          'https://www.instagram.com/${Hive.box<UserModel>(userBox).values.last.usrname}/');
                                    },
                                    child: CircleAvatar(
                                      radius: constraints.maxHeight * 0.32,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: constraints.maxHeight * 0.25,
                                        backgroundImage: NetworkImage(
                                          Hive.box<UserModel>(userBox)
                                              .values
                                              .last
                                              .thumbnailUrl,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    Hive.box<UserModel>(userBox)
                                        .values
                                        .last
                                        .usrname,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: constraints.maxHeight * 0.22,
                                width: constraints.maxWidth * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[300],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: downloadProvider.downloadPerct,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Colors.pink,
                                        Colors.red,
                                        Colors.orange
                                      ]),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    });
              }),
            ),
          ),
        ],
      );
    });
  }
}
