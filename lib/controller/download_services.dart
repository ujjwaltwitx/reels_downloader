// import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/utilities/snackbar.dart';

import '../main.dart';
// import '../model/ads/ad_model.dart';
// import '../model/photo/photo_model.dart';
// import '../model/useraccounts/user_model.dart';
import '../model/video/video_model.dart';

final downloadNotifier = ChangeNotifierProvider<DownloadServices>((ref) {
  return DownloadServices();
});

//singleton class
class DownloadServices extends ChangeNotifier {
  factory DownloadServices() => instance;
  DownloadServices._instantiate();
  static final instance = DownloadServices._instantiate();
  final TextEditingController textController = TextEditingController();
  bool showDownloads = false;
  bool receiveIntent = true;
  double downloadPerct = 0;
  bool isButtonDisabled = false;
  String cookie = '';

  Future<void> getCookie() async {
    final data = await FirebaseDatabase.instance.ref('/').once();
    cookie = (data.snapshot.value as Map)['cookie'];
  }

  // final ad = AdServices.createBannerAd()..load();

  void pasteAndVerifyLink() {
    if (textController.text.split('/').contains('www.instagram.com'))
      notifyListeners();
    else {
      showSnackbar(message: "Invalid Url");
      return;
    }
  }

  void toggleIntent() {
    receiveIntent = false;
  }

  Future<void> getClipData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value!.text!.split('/').contains('www.instagram.com')) {
        textController.text = (value.text)!;
      } else {
        showSnackbar(message: "Not a valid instagram link");
      }
    });
  }

  Future<String> getDir() async {
    String downloadPath = '';
    final directory = await getExternalStorageDirectory();
    final List<String> pathParts = directory!.path.split('/');
    for (int i = 1; i < pathParts.length; i++) {
      if (pathParts[i] != 'Android') {
        downloadPath += '/${pathParts[i]}';
      } else {
        break;
      }
    }
    return downloadPath += '/Download';
  }

  bool fileExistsOrNot(String path) {
    return File(path).existsSync();
  }

  Future<void> downloadReels() async {
    if (cookie == '') {
      await getCookie();
    }
    downloadPerct = 0;
    pasteAndVerifyLink();
    notifyListeners();
    try {
      if (await Permission.storage.isGranted) {
      } else {
        await Permission.storage.request();
      }
      final videomodelBox = Hive.box<VideoModel>(videoBox);
      final Dio dio = Dio();
      final String link = textController.text;
      final linkEdit = link.replaceAll(" ", "").split("/");
      final String mediaLink =
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}/?__a=1';
      print(mediaLink);
      final String tempDir = await getDir();
      final Directory directory = Directory(tempDir);
      final String filePath = '${directory.path}/${linkEdit[4]}.mp4';

      if (fileExistsOrNot(filePath)) {
        showSnackbar(message: "Video exists in download folder");
        return;
      }

      Map<String, String> headers = {
        'Host': 'www.instagram.com',
        'User-Agent': 'Mozilla',
        'Accept': 'text/html,application/xhtml+xml,application/xml',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate, br',
        'Alt-Used': 'www.instagram.com',
        'Connection': 'keep-alive',
        'Cookie': cookie,
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'cross-site',
        'Cache-Control': 'max-age=0',
        'TE': 'trailers'
      };
      final jsonFetchData =
          await dio.get(mediaLink, options: Options(headers: headers));
      final shotcodeMedia = jsonFetchData.data['items'][0];
      final videoUrl = shotcodeMedia['video_versions'][0]['url'];
      final videoId = shotcodeMedia['code'];
      final videoThumbnailUrl =
          shotcodeMedia['image_versions2']['candidates'][0]['url'];
      print(videoThumbnailUrl);
      final accountThumbnailUrl = shotcodeMedia['user']['profile_pic_url'];
      final accountName = shotcodeMedia['user']['username'];
      final viewCount = shotcodeMedia['view_count'];
      print(videoUrl);
      final appDir = await getApplicationDocumentsDirectory();
      final thumbnailDir = '${appDir.path}/${linkEdit[4]}.jpg';

      isButtonDisabled = true;
      notifyListeners();
      // showDownloads = true;

      if (fileExistsOrNot(thumbnailDir)) {
      } else {
        try {
          await dio.download(
            videoThumbnailUrl,
            thumbnailDir,
          );
        } catch (e) {
          rethrow;
        }
      }

      try {
        await dio.download(videoUrl, filePath, onReceiveProgress: (rec, total) {
          downloadPerct = rec / total;
          notifyListeners();
        });

        videomodelBox.add(
          VideoModel(
            videoId: videoId,
            videoUrl: mediaLink,
            thumbnailUrl: videoThumbnailUrl,
            ownerId: accountName,
            ownerThumbnailUrl: accountThumbnailUrl,
            videoPath: filePath,
            thumbnailPath: thumbnailDir,
            viewCount: viewCount,
          ),
        );
        await ImageGallerySaver.saveFile(filePath);
      } catch (e) {
        rethrow;
      } finally {
        isButtonDisabled = false;
        notifyListeners();
      }

      Fluttertoast.showToast(
        msg: "Video Downloaded to Gallery",
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      rethrow;
    } finally {
      isButtonDisabled = false;
      notifyListeners();
    }
  }
}
