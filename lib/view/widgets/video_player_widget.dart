import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reels_downloader/view/widgets/viewcount_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final String accountName;
  final int viewCount;
  final String imgPath;
  const VideoPlayerWidget({
    Key? key,
    required this.videoPath,
    required this.accountName,
    required this.viewCount,
    required this.imgPath,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  void play() async {
    await _controller.play();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // If the video is playing, pause it.
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          // If the video is paused, play it.
                          _controller.play();
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Center(child: VideoPlayer(_controller)),
                          Positioned(
                            child: Text('Reels'),
                            top: 15,
                            right: 15,
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ViewCountText(
                                  viewcount: widget.viewCount,
                                  fontSize: 14,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.imgPath,
                                      ),
                                      radius: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(widget.accountName)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 40,
          ),
        ),
      ),
    );
  }
}
