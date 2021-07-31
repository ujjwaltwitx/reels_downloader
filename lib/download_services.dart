import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadServices extends ChangeNotifier {
  String downVar = 'Download';
  String copyValue = '';
  DownloadServices._instantiate();
  static final instance = DownloadServices._instantiate();
  factory DownloadServices() {
    instance.getClipData();

    return instance;
  }
  int percentage = 0;

  void getClipData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value == null) {
      } else {
        copyValue = value.text;
      }
    });
  }

  void gettingData() {
    getClipData();
  }

  void downloadReels(String link) async {
    if (await Permission.storage.isGranted) {
    } else {
      await Permission.storage.request();
    }
    try {
      Dio dio = Dio();

      var linkEdit = link.replaceAll(" ", "").split("/");
      var downloadURL = await dio.get(
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
              "/?__a=1");

      var videoUrl =
          downloadURL.data['graphql']["shortcode_media"]['video_url'];
      var id = downloadURL.data['graphql']["shortcode_media"]['id'];
      print(downloadURL.data);

      String downloadPath = '';

      var directory = await getExternalStorageDirectory();

      List<String> pathParts = directory.path.split('/');
      for (int i = 1; i < pathParts.length; i++) {
        if (pathParts[i] != 'Android') {
          downloadPath += '/' + pathParts[i];
        } else {
          break;
        }
      }

      downloadPath += '/Download';

      directory = Directory(downloadPath);

      await dio.download(videoUrl, directory.path + '/${id.toString()}.mp4',
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
      print('Some Error Occured');
    }
  }
}
