import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadServices extends ChangeNotifier {
  factory DownloadServices() {
    return instance;
  }

  DownloadServices._instantiate();
  static final instance = DownloadServices._instantiate();

  String downVar = 'Download';
  String copyValue = '';
  int coin = 0;

  int percentage = 0;

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

  void gotBackground() {
    downVar = 'Download';
    percentage = 0;
    notifyListeners();
  }

  Future<void> downloadReels(String link, BuildContext context) async {
    if (await Permission.storage.isGranted) {
    } else {
      await Permission.storage.request();
    }

    try {
      final Dio dio = Dio();

      final linkEdit = link.replaceAll(" ", "").split("/");
      final downloadURL = await dio.get(
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
              "/?__a=1");

      final String videoUrl =
          downloadURL.data['graphql']["shortcode_media"]['video_url'] as String;
      final id = downloadURL.data['graphql']["shortcode_media"]['id'];

      String downloadPath = '';

      var directory = await getExternalStorageDirectory();

      final List<String> pathParts = directory.path.split('/');
      for (int i = 1; i < pathParts.length; i++) {
        if (pathParts[i] != 'Android') {
          downloadPath += '/${pathParts[i]}';
        } else {
          break;
        }
      }

      downloadPath += '/Download';

      directory = Directory(downloadPath);

      if (File('${directory.path}/${id.toString()}.mp4').existsSync()) {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Video already exists in Download folder"),
          ),
        );
      }

      await dio.download(videoUrl, '${directory.path}/${id.toString()}.mp4',
          onReceiveProgress: (rec, total) {
        percentage = (rec * 100) ~/ total;
        if (percentage != 100) {
          downVar = 'Downloading';
        } else {
          downVar = 'Downloaded';
        }
        notifyListeners();
      });
      copyValue = '';
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void icrementCoin() {
    coin++;
    notifyListeners();
  }
}
