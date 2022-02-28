import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:reels_downloader/controller/ad_model.dart';
import 'package:reels_downloader/controller/download_services.dart';
import 'package:reels_downloader/view/widgets/downloading_widget.dart';
import 'package:reels_downloader/view/widgets/textfield_widget.dart';
import 'package:reels_downloader/view/widgets/video_carousel.dart';

import '../widgets/button_widget.dart';
import '../widgets/outline_button_widget.dart';

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

    ReceiveSharingIntent.getTextStream().listen((String value) {
      downProvider.textController.text = value;
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      downProvider.textController.text = value!;
    });

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
                    Expanded(
                      child: OutlineButtonWidget(
                        onTap: () {
                          downProvider.getClipData();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                  child: Row(
                    children: [
                      if (downProvider.isButtonDisabled)
                        DownloadingWidget(
                          imgUrl: downProvider.imgUrl!,
                        ),
                      Expanded(child: VideoCarousel()),
                    ],
                  ),
                ),
                SizedBox(
                  height: AdServices.ad!.size.height.toDouble(),
                  width: double.infinity,
                  child: AdWidget(ad: AdServices.ad!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
