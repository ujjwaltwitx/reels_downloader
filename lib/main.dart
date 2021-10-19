import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/model/ads/ad_model.dart';
import 'package:reels_downloader/model/photo/photo_model.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';
import 'view/mainpage/page/mainpage.dart';

const String videoBox = 'videomodel';
const String userBox = 'usermodel';
const String photoBox = 'photomodel';

//https://www.instagram.com/p/CS7AkJfqC-v/?utm_source=ig_web_copy_link
//https://www.instagram.com/reel/CS9fF8nKR_d/?utm_source=ig_web_copy_link
//https://www.instagram.com/reel/CStvM80DsDc/?utm_medium=copy_link

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  final dir = await getApplicationDocumentsDirectory();
  AdServices.initialize();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(VideoModelAdapter());
  Hive.registerAdapter(PhotoModelAdapter());
  Hive.init(dir.path);
  await Hive.openBox<UserModel>(userBox);
  await Hive.openBox<VideoModel>(videoBox);
  await Hive.openBox<PhotoModel>(photoBox);
  await AdServices.createRewardedAd();
  runApp(ProviderScope(child: LandingPage()));
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<void> getPermission() async {
    if (await Permission.storage.isGranted) {
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    getPermission();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
