import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reels_downloader/model/ads/ad_model.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';
import 'package:reels_downloader/model/video/video_model.dart';

import 'controller/download_controller/download_services.dart';
import 'view/mainpage/page/mainpage.dart';

// https://www.instagram.com/reel/CRgPdtWFw7H/?utm_medium=copy_link
// https://www.instagram.com/reel/CRgjvHPCVD0/?utm_medium=share_sheet
const String videoBox = 'videomodel';
const String userBox = 'usermodel';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdServices.initialize();
  final dir = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(VideoModelAdapter());
  Hive.init(dir.path);
  await Hive.openBox<UserModel>(userBox);
  await Hive.openBox<VideoModel>(videoBox);
  await AdServices.createRewardedAd();
  runApp(ProviderScope(child: LandingPage()));
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   AdServices.createRewardedAd();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  //  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      DownloadServices.instance.intentCount = 0;
    }
  }

  Future<void> getPermission() async {
    if (await Permission.storage.isGranted) {
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    getPermission();
    DownloadServices.instance.getClipData();
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}
