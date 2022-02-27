import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_downloader/model/video/video_model.dart';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:open_file/open_file.dart';
// import '../../../controller/download_controller/download_services.dart';
// import '../../../main.dart';
// import '../../../model/useraccounts/user_model.dart';
// import '../../../model/video/video_model.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'video_player_widget.dart';
import 'viewcount_widget.dart';

class ReelCardWidget extends ConsumerWidget {
  final VideoModel videoModel;
  ReelCardWidget({required this.videoModel});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = 80;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, right: 10),
      height: (width / 9) * 16,
      width: width,
      color: Colors.transparent,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              videoModel.thumbnailUrl,
              width: width,
              height: (width / 9) * 16,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: ViewCountText(viewcount: videoModel.viewCount, fontSize: 10),
            bottom: 5,
            left: 8,
          ),
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerWidget(
                      videoPath: videoModel.videoPath,
                      imgPath: videoModel.ownerThumbnailUrl,
                      accountName: videoModel.ownerId,
                      viewCount: videoModel.viewCount,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
