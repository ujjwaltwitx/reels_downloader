import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:open_file/open_file.dart';
// import '../../../controller/download_controller/download_services.dart';
// import '../../../main.dart';
// import '../../../model/useraccounts/user_model.dart';
// import '../../../model/video/video_model.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'video_player_widget.dart';

class ReelCardWidget extends ConsumerWidget {
  final String? imageUrl;
  final String? views;
  ReelCardWidget({this.imageUrl, this.views});
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
              'https://images.unsplash.com/photo-1645771845014-7077d5d0f058?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
              width: width,
              height: (width / 9) * 16,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: Text('1.4m'),
            bottom: 5,
            left: 8,
          ),
          Center(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerWidget(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
