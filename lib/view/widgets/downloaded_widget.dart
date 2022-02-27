import 'package:flutter/material.dart';

import 'video_player_widget.dart';

class DownloadedWidget extends StatelessWidget {
  const DownloadedWidget({Key? key}) : super(key: key);

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
            child: Image.network(
              'https://images.unsplash.com/photo-1645771845014-7077d5d0f058?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
              width: width,
              height: (width / 9) * 16,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: Text('1.4m'),
            bottom: 15,
            left: 15,
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
