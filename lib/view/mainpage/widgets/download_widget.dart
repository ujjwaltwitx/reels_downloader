import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/video/video_model.dart';

class DownloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
            builder: (context, Box<VideoModel> box, _) {
              return Container(
                margin: const EdgeInsets.all(5),
                height: constraints.maxHeight * 0.9,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
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
                                height: constraints.maxHeight * 0.15,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    box.values
                                        .elementAt(index)
                                        .ownerThumbnailUrl,
                                  ),
                                  radius: constraints.maxHeight * 0.04,
                                ),
                              ),
                              Text(box.values.elementAt(index).ownerId)
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                box.values.elementAt(index).thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.1,
                            child: Row(
                              children: [
                                IconButton(
                                    splashRadius: 2,
                                    onPressed: () {},
                                    icon: const Icon(Icons.share)),
                                IconButton(
                                  splashRadius: 2,
                                  onPressed: () {},
                                  icon: const Icon(Icons.copy),
                                ),
                                IconButton(
                                  splashRadius: 2,
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        itemCount: Hive.box<VideoModel>(videoBox).values.length,
      );
    });
  }
}
