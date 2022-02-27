import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/view/widgets/reel_card_widget.dart';

import '../../main.dart';
import '../../model/video/video_model.dart';

class VideoCarousel extends StatelessWidget {
  const VideoCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
      builder: (context, Box<VideoModel> box, _) {
        final videoListReversed = box.values.toList().reversed;
        return SizedBox(
          height: 80 / 9 * 16,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ReelCardWidget(
              videoModel: videoListReversed.elementAt(index),
            ),
            itemCount:
                videoListReversed.length < 5 ? videoListReversed.length : 5,
          ),
        );
      },
    );
  }
}
