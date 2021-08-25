import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/controller/download_controller/download_services.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/ads/ad_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:reels_downloader/view/mainpage/widgets/download_status.dart';
import 'package:reels_downloader/view/mainpage/widgets/recents.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'manula_widget.dart';

class HomeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downProvider = watch(downloadNotifier);

    if (downProvider.receiveIntent == true) {
      downProvider.toggleIntent();

      ReceiveSharingIntent.getInitialText().then((String value) {
        if (downProvider.textController.text.isEmpty) {
          downProvider.changeTextContData(value);
        }
      });

      downProvider.getClipData();

      // ReceiveSharingIntent.getTextStream().listen(
      //   (String value) {
      //     if (downProvider.textController.text.isEmpty) {
      //       downProvider.changeTextContData(value);
      //     }
      //   },
      //   cancelOnError: true,
      // );

    }

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.1,
              child: TextField(
                controller: downProvider.textController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  hintText: "Paste Instagram URL here....",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      downProvider.getClipData();
                    },
                    color: Colors.grey[200],
                    elevation: 0,
                    child: const Text(
                      'Paste Link',
                      style: TextStyle(color: Colors.pink),
                    ),
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
                        : () async {
                            await DownloadServices.instance.downloadReels(
                                downProvider.textController.text.toString(),
                                context);
                            AdServices.showRewardedAd();
                          },
                    color: Colors.pink,
                    elevation: 0,
                    child: Text(
                      !downProvider.isButtonDisabled
                          ? 'Download'
                          : 'Downloading',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
              builder: (context, Box<VideoModel> box, _) {
                return Hive.box<VideoModel>(videoBox).values.isEmpty
                    ? Expanded(child: ManualWidget())
                    : Expanded(
                        child: Column(
                          children: [
                            if (downProvider.showDownloads)
                              SizedBox(
                                height: constraints.maxHeight * 0.2,
                                child: DownloadStatusWidget(),
                              ),
                            SizedBox(
                              height: constraints.maxHeight * 0.2,
                              child: Recents(constraints),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.25,
                              child: AdWidget(
                                  ad: AdServices.createBannerAd()..load()),
                            )
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      );
    });
  }
}
