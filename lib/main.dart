import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controller/ad_model.dart';
import 'model/video/video_model.dart';
import 'view/screens/mainpage.dart';

const String videoBox = 'videomodel';
const String userBox = 'usermodel';
const String photoBox = 'photomodel';

//https://www.instagram.com/p/CS7AkJfqC-v/?utm_source=ig_web_copy_link
//https://www.instagram.com/reel/CS9fF8nKR_d/?utm_source=ig_web_copy_link
//https://www.instagram.com/reel/CStvM80DsDc/?utm_medium=copy_link

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Directory dir = await getApplicationDocumentsDirectory();
  await MobileAds.instance.initialize();
  Hive.registerAdapter(VideoModelAdapter());
  Hive.init(dir.path);
  await Hive.openBox<VideoModel>(videoBox);
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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    getPermission();
    AdServices.createBannerAd();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Cookie',
            fontSize: 64,
            color: Color.fromARGB(255, 240, 111, 111),
            fontWeight: FontWeight.w700,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: MainPage(),
    );
  }
}
