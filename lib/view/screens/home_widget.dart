import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:reels_downloader/controller/download_services.dart';
import 'package:reels_downloader/main.dart';
// import 'package:reels_downloader/model/ads/ad_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'package:reels_downloader/view/widgets/downloading_widget.dart';
import 'package:reels_downloader/view/widgets/textfield_widget.dart';

import '../widgets/button_widget.dart';
import '../widgets/outline_button_widget.dart';
import '../widgets/reel_card_widget.dart';
// import 'package:reels_downloader/view/mainpage/widgets/recents_user_widget.dart';

class HomeWidget extends ConsumerWidget {
  final focusnode = FocusNode();
  final Shader linearGradient = LinearGradient(colors: <Color>[
    Color.fromARGB(255, 240, 167, 33),
    Color.fromARGB(255, 180, 0, 156),
    Color.fromARGB(255, 228, 59, 101)
  ], stops: [
    0.1,
    0.5,
    0.9,
  ]).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 400));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downProvider = ref.watch(downloadNotifier);
    // if (downProvider.receiveIntent == true) {
    //   downProvider.toggleIntent();
    //   ReceiveSharingIntent.getInitialText().then((String value) {
    //     if (value != null) {
    //       downProvider.changeTextContData(value);
    //       downProvider.mediaToDownload();
    //     }
    //   });
    //   downProvider.getClipData();
    // }
    return GestureDetector(
      onTap: () => focusnode.unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Reels',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          foreground: Paint()..shader = linearGradient,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFieldWidget(
                    controller: downProvider.textController,
                  ),
                ),
                Row(
                  children: [
                    // Expanded(
                    //   child: MaterialButton(
                    //     splashColor: Colors.transparent,
                    //     onPressed: () async {
                    //       downProvider.textController.text = '';
                    //       downProvider.getClipData();
                    //     },
                    //     color: Colors.grey[200],
                    //     elevation: 0,
                    //     child: const Text(
                    //       'Paste Link',
                    //       style: TextStyle(color: Colors.pink),
                    //     ),
                    //   ),
                    // ),
                    Expanded(child: OutlineButtonWidget(
                      onTap: () {
                        downProvider.getClipData();
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ButtonWidget(
                        onTap: downProvider.isButtonDisabled
                            ? () {}
                            : () async {
                                await downProvider.downloadReels();
                              },
                        title: downProvider.isButtonDisabled
                            ? 'Downloading'
                            : 'Download',
                      ),
                    )
                    // Expanded(
                    //   child: MaterialButton(
                    //     disabledColor: Colors.pinkAccent,
                    //     splashColor: Colors.transparent,
                    //     onPressed: downProvider.isButtonDisabled
                    //         ? null
                    //         : () async {
                    //             await downProvider.mediaToDownload();
                    //             AdServices.showRewardedAd();
                    //           },
                    //     color: Colors.pink,
                    //     elevation: 0,
                    //     child: Text(
                    //       !downProvider.isButtonDisabled
                    //           ? 'Download'
                    //           : 'Downloading',
                    //       style: const TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    'Recent Downloads',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Color.fromARGB(255, 53, 52, 52)),
                  ),
                ),
                SizedBox(
                  height: 80 / 9 * 16,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ReelCardWidget(),
                    itemCount: 5,
                  ),
                ),
                DownloadingWidget()
                // ValueListenableBuilder(
                //   valueListenable: Hive.box<VideoModel>(videoBox).listenable(),
                //   builder: (context, Box<VideoModel> box, _) {
                //     return Expanded(
                //       child: Column(
                //         children: [
                //           // if (downProvider.showDownloads)
                //           ReelCardWidget()

                //           // if (downProvider.showDownloads)
                //           //   SizedBox(
                //           //     height: constraints.maxHeight * 0.2,
                //           //     child: RecentUserWidget(constraints),
                //           //   ),
                //           // StatefulBuilder(
                //           //   builder: (context, setState) => Container(
                //           //     width: double.infinity,
                //           //     height: 100.0,
                //           //     alignment: Alignment.center,
                //           //     child: AdWidget(
                //           //       ad: AdServices.createBannerAd()..load(),
                //           //     ),
                //           //   ),
                //           // ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
