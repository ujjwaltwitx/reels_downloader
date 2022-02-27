import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_downloader/controller/download_services.dart';

class DownloadingWidget extends ConsumerWidget {
  const DownloadingWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadPerct = ref.watch(downloadNotifier).downloadPerct;
    final double width = 80;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, right: 10),
      height: (width / 9) * 16,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            colors: [Colors.grey, Color.fromARGB(153, 250, 239, 239)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: downloadPerct,
          backgroundColor: Colors.white,
          color: Color.fromARGB(255, 6, 165, 11),
        ),
      ),
    );
  }
}
