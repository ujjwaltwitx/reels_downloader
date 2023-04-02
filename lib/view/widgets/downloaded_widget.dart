import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:reels_downloader/view/widgets/viewcount_widget.dart';

import 'video_player_widget.dart';

class DownloadedWidget extends StatelessWidget {
  final VideoModel videoModel;
  final Function onTap;
  const DownloadedWidget({
    Key? key,
    required this.videoModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double width = deviceWidth / 2;
    return Container(
      alignment: Alignment.center,
      height: (width / 9) * 16,
      width: width,
      color: Colors.transparent,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(videoModel.thumbnailPath),
              width: width,
              height: (width / 9) * 16,
              fit: BoxFit.cover,
            ),
          ),
          // Positioned(
          //   child: ViewCountText(
          //     fontSize: 14,
          //     viewcount: videoModel.viewCount,
          //   ),
          //   bottom: 15,
          //   left: 15,
          // ),
          Positioned(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  onTap();
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ),
            ),
            bottom: 10,
            right: 10,
          ),
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerWidget(
                      videoPath: videoModel.videoPath,
                      accountName: videoModel.ownerId,
                      viewCount: videoModel.viewCount,
                      imgPath: videoModel.ownerThumbnailUrl,
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
