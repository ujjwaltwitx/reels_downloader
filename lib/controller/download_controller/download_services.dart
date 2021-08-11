import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';

final downloadNotifier = ChangeNotifierProvider<DownloadServices>((ref) {
  return DownloadServices();
});

//singleton class
class DownloadServices extends ChangeNotifier {
  factory DownloadServices() => instance;
  DownloadServices._instantiate();
  static final instance = DownloadServices._instantiate();

  VideoModel video;

  double downloadPerct = 0;
  bool isButtonDisabled = false;

  String copyValue = '';
  Future<void> getClipData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value == null) {
      } else {
        if (value.text.split('/').contains('www.instagram.com')) {
          copyValue = value.text;
          notifyListeners();
        }
      }
      notifyListeners();
    });
  }

  Future<String> getDir() async {
    String downloadPath = '';
    final directory = await getExternalStorageDirectory();
    final List<String> pathParts = directory.path.split('/');
    for (int i = 1; i < pathParts.length; i++) {
      if (pathParts[i] != 'Android') {
        downloadPath += '/${pathParts[i]}';
      } else {
        break;
      }
    }
    return downloadPath += '/Download';
  }

  Future<void> downloadReels(String link, BuildContext context) async {
    isButtonDisabled = true;
    notifyListeners();
    try {
      if (await Permission.storage.isGranted) {
      } else {
        await Permission.storage.request();
      }
      final usermodelBox = Hive.box<UserModel>(userBox);
      final videomodelBox = Hive.box<VideoModel>(videoBox);
      final Dio dio = Dio();
      final linkEdit = link.replaceAll(" ", "").split("/");
      final downloadURL = await dio.get(
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
              "/?__a=1");
      final videoUrl =
          downloadURL.data['graphql']["shortcode_media"]['video_url'] as String;
      final videoId =
          downloadURL.data['graphql']["shortcode_media"]['id'] as String;
      final videoThumbnailUrl = downloadURL.data['graphql']["shortcode_media"]
          ['display_url'] as String;
      final accountThumbnailUrl = downloadURL.data['graphql']["shortcode_media"]
          ['owner']['profile_pic_url'] as String;
      final accountName = downloadURL.data['graphql']["shortcode_media"]
          ['owner']['username'] as String;

      final String tempDir = await getDir();
      final directory = Directory(tempDir);

      if (File('${directory.path}/${videoId.toString()}.mp4').existsSync()) {
        isButtonDisabled = false;
        notifyListeners();
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Video already exists in Download folder"),
          ),
        );
      }

      usermodelBox.add(UserModel(accountName, accountThumbnailUrl));

      videomodelBox.add(VideoModel(videoId, videoUrl, videoThumbnailUrl,
          accountName, accountThumbnailUrl));

      try {
        await dio
            .download(videoUrl, '${directory.path}/${videoId.toString()}.mp4',
                onReceiveProgress: (rec, total) {
          downloadPerct = rec / total;
          notifyListeners();
        });
      } catch (e) {
        rethrow;
      } finally {
        isButtonDisabled = false;
        notifyListeners();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved To Download Folder"),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
