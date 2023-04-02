import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/utilities/snackbar.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../main.dart';
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

  bool pasteAndVerifyLink() {
    if (textController.text.split('/').contains('www.instagram.com')) {
      notifyListeners();
    } else {
      showSnackbar(message: "Invalid Url");
      isButtonDisabled = false;
      notifyListeners();
      return false;
    }
    return true;
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

  Future<void> grantPermission() async {
    if (await Permission.storage.isGranted) {
    } else {
      await Permission.storage.request();
    }
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
    isButtonDisabled = true;
    notifyListeners();
    if (pasteAndVerifyLink() == false) {
      return;
    }
    await grantPermission();
    downloadPerct = 0;
    try {
      final videomodelBox = Hive.box<VideoModel>(videoBox);
      final Dio dio = Dio();
      final String link = textController.text;
      final linkEdit = link.replaceAll(" ", "").split("/");
      final String mediaLink =
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}';
      final String tempDir = await getDir();
      final Directory directory = Directory(tempDir);
      final String filePath = '${directory.path}/${linkEdit[4]}.mp4';

      if (fileExistsOrNot(filePath)) {
        showSnackbar(message: "Video exists in download folder");
        return;
      }

      final data = {"url": '$link'};
      final response = await http.post(
        Uri.parse("https://savein.io/api/fetch"),
        body: json.encode(data),
        headers: {
          'content-Type': 'application/json',
          "origin": "https://savein.io",
          "referer": "https://savein.io/",
        },
      );
      final jsonData = json.decode(response.body);
      print("Downloading");
      print(jsonData);
      final videoId = jsonData['media']['data']['id'];
      final ownerId = jsonData['media']['data']['user']['username'];
      final ownerThumbnailUrl =
          jsonData['media']['data']['user']['profile']['pic']['normal'];
      final viewCount = jsonData['media']['data']['metrics']['views'];
      final videoUrl =
          jsonData['media']['data']['mediaList'][0]['videos'][0]['url'];
      final videoThumbnailUrl =
          jsonData['media']['data']['mediaList'][0]['images'][2]['url'];
      final appDir = await getApplicationDocumentsDirectory();
      final thumbnailDir = '${appDir.path}/${linkEdit[4]}.jpg';

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
            ownerId: ownerId,
            ownerThumbnailUrl: ownerThumbnailUrl,
            viewCount: viewCount,
            videoUrl: mediaLink,
            thumbnailUrl: videoThumbnailUrl,
            videoPath: filePath,
            thumbnailPath: thumbnailDir,
          ),
        );
        await ImageGallerySaver.saveFile(filePath);
      } catch (e) {
        rethrow;
      }
      showSnackbar(message: "Video Downloaded to Gallery");
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isButtonDisabled = false;
      notifyListeners();
    }
  }
}
