import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/ads/ad_model.dart';
import 'package:reels_downloader/model/photo/photo_model.dart';
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
  final TextEditingController textController = TextEditingController();
  bool showDownloads = false;
  bool receiveIntent = true;
  double downloadPerct = 0;
  bool isButtonDisabled = false;
  final ad = AdServices.createBannerAd()..load();
  void changeTextContData(String text) {
    textController.text = text;
    notifyListeners();
  }

  void toggleIntent() {
    receiveIntent = false;
  }

  Future<void> getClipData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value.text.split('/').contains('www.instagram.com')) {
        if (textController.text.isEmpty) {
          textController.text = value.text;
          notifyListeners();
          if (value.text.split('/').contains('reel') ||
              value.text.split('/').contains('tv')) {
            downloadReels(textController.text);
          } else if (textController.text.split('/').contains('p')) {
            downloadPhotos(textController.text);
          } else {
            Fluttertoast.showToast(
                msg: "Link not supported", gravity: ToastGravity.CENTER);
          }
        }
      }
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

  Future<void> downloadReels(String link) async {
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
      link.trimRight();
      final linkEdit = link.replaceAll(" ", "").split("/");

      final String toSendLink =
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}/?__a=1';

      final jsonFetchData = await dio.get(
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
              "/?__a=1");
      final videoUrl = jsonFetchData.data['graphql']["shortcode_media"]
          ['video_url'] as String;
      final videoId =
          jsonFetchData.data['graphql']["shortcode_media"]['id'] as String;
      final videoThumbnailUrl = jsonFetchData.data['graphql']["shortcode_media"]
          ['display_url'] as String;
      final accountThumbnailUrl = jsonFetchData.data['graphql']
          ["shortcode_media"]['owner']['profile_pic_url'] as String;
      final accountName = jsonFetchData.data['graphql']["shortcode_media"]
          ['owner']['username'] as String;

      final String tempDir = await getDir();
      final directory = Directory(tempDir);

      if (File('${directory.path}/${videoId.toString()}.mp4').existsSync()) {
        isButtonDisabled = false;
        notifyListeners();
        Fluttertoast.showToast(
            msg: "Video exists in Download folder",
            gravity: ToastGravity.CENTER);
        return;
      }

      showDownloads = true;

      if (usermodelBox.values
          .contains(UserModel(accountName, accountThumbnailUrl))) {
      } else {
        usermodelBox.add(UserModel(accountName, accountThumbnailUrl));
      }

      videomodelBox.add(
        VideoModel(videoId, toSendLink, videoThumbnailUrl, accountName,
            accountThumbnailUrl, '${directory.path}/${videoId.toString()}.mp4'),
      );

      try {
        await dio
            .download(videoUrl, '${directory.path}/${videoId.toString()}.mp4',
                onReceiveProgress: (rec, total) {
          downloadPerct = rec / total;
          notifyListeners();
        });

        await ImageGallerySaver.saveFile(
            '${directory.path}/${videoId.toString()}.mp4');
      } catch (e) {
        rethrow;
      } finally {
        isButtonDisabled = false;
        notifyListeners();
      }
      Fluttertoast.showToast(
          msg: "Video Downloaded to Gallery", gravity: ToastGravity.BOTTOM);
    } catch (e) {
      rethrow;
    } finally {
      isButtonDisabled = false;
      notifyListeners();
    }
  }

  Future<void> downloadPhotos(String link) async {
    isButtonDisabled = true;
    notifyListeners();
    try {
      if (await Permission.storage.isGranted) {
      } else {
        await Permission.storage.request();
      }
      final photomodelBox = Hive.box<PhotoModel>(photoBox);
      final Dio dio = Dio();
      final linkEdit = link.replaceAll(" ", "").split("/");

      final jsonFetchData = await dio.get(
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
              "/?__a=1");

      final photoUrl = jsonFetchData.data['graphql']["shortcode_media"]
          ['display_url'] as String;
      final photoID =
          jsonFetchData.data['graphql']["shortcode_media"]['id'] as String;
      final String toSendLink =
          '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}/?__a=1';

      final String tempDir = await getDir();
      final directory = Directory(tempDir);

      if (File('${directory.path}/${photoID.toString()}.jpg').existsSync()) {
        isButtonDisabled = false;
        notifyListeners();
        return Fluttertoast.showToast(
            msg: "Photo already exists in Download folder",
            gravity: ToastGravity.BOTTOM);
      }

      photomodelBox.add(PhotoModel(photoID, photoUrl, toSendLink,
          '${directory.path}/${photoID.toString()}.jpg'));

      try {
        await dio.download(
          photoUrl,
          '${directory.path}/${photoID.toString()}.jpg',
        );

        await ImageGallerySaver.saveFile(
            '${directory.path}/${photoID.toString()}.jpg');
      } catch (e) {
        rethrow;
      } finally {
        isButtonDisabled = false;
        notifyListeners();
      }
      Fluttertoast.showToast(
          msg: "Image Downloaded to Gallery", gravity: ToastGravity.BOTTOM);
    } catch (e) {
      rethrow;
    } finally {
      isButtonDisabled = false;
      notifyListeners();
    }
  }
}
