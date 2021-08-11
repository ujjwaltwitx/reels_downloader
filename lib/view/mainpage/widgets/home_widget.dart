import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/controller/download_controller/download_services.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:reels_downloader/view/mainpage/widgets/download_status.dart';
import 'package:reels_downloader/view/mainpage/widgets/recents.dart';
import 'manula_widget.dart';

class HomeWidget extends ConsumerWidget {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downProvider = watch(downloadNotifier);
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.1,
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Paste Instagram URL here....",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    color: Colors.grey[200],
                    elevation: 0,
                    child: const Text('Paste Link',
                        style: TextStyle(color: Colors.pink)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    disabledColor: Colors.pinkAccent,
                    splashColor: Colors.transparent,
                    onPressed: downProvider.isButtonDisabled
                        ? null
                        : () {
                            DownloadServices.instance.downloadReels(
                                textController.text.toString(), context);
                          },
                    color: Colors.pink,
                    elevation: 0,
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: constraints.maxHeight * 0.2,
                child: Hive.box<VideoModel>(videoBox).values.isEmpty
                    ? Recents(constraints)
                    : DownloadStatusWidget()),
            Expanded(child: ManualWidget())
          ],
        ),
      );
    });
  }
}
