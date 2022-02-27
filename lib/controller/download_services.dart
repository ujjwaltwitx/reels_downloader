// import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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
  String? imgUrl = '';

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
        'Cookie':
            r'mid=Yg4QiwAEAAH3cIr9z5n5voYsts22; ig_did=2C90B61F-2361-4440-8B0D-773C645D74AA; ig_nrcb=1; rur="PRN\05426458373780\0541677436471:01f70cf206d360ab8465804d831fb98e5fc9e313074c530dcc67f5455b37f5bf495f73ed"; csrftoken=ctDdqtPxRMO9A6sX5zBKnglGQ5oPyluu; ds_user_id=26458373780, mid=YhnVogAEAAHJFF5Dor27XMdZc9KJ; ig_did=44209912-5CBB-42B9-9E68-841691D79190; ig_nrcb=1; shbid="19750\05426458373780\0541677406389:01f7edc61531bc31479873635279c00d96c397127758efd82cdcba2fd1338328bc075f1e"; shbts="1645870389\05426458373780\0541677406389:01f7c40323ddccb83ad6f25e075f7a6c6e1b2920b7ea5765489e265ead6896189438b6bd"; ds_user_id=26458373780; csrftoken=ctDdqtPxRMO9A6sX5zBKnglGQ5oPyluu; sessionid=26458373780%3AjKmsOB1GFNPjuk%3A8; rur="PRN\05426458373780\0541677436337:01f799e3b3a3bb9aa097469dcdb8bcf8e5a85696acf282dce9ce1abd6a742b921a210c5b"',
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
      imgUrl = videoThumbnailUrl;
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
