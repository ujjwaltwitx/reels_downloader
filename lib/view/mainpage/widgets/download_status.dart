import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/controller/download_controller/download_services.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/video/video_model.dart';

class DownloadStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downloadProvider = watch(downloadNotifier);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.015,
          ),
          const Text("Download Status"),
          SizedBox(
            height: constraints.maxHeight * 0.08,
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
                          SizedBox(
                            width: constraints.maxWidth * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Download Status"),
                              const SizedBox(
                                height: 5,
                              ),
                              Stack(alignment: Alignment.centerLeft, children: [
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
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.22,
                                  width: constraints.maxWidth * 0.8,
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: downloadProvider.downloadPerct,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ])
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
