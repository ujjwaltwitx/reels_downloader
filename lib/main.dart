import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controller/download_controller/download_services.dart';
import 'model/ads/ad_model.dart';
import 'view/mainpage/page/mainpage.dart';

// https://www.instagram.com/reel/CRgPdtWFw7H/?utm_medium=copy_link
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdServices.initialize();
  runApp(ProviderScope(child: LandingPage()));
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    AdServices.createRewardedAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      AdServices.createRewardedAd();
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
