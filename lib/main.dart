import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'adservices.dart';
import 'download_services.dart';
import 'homescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdServices.initialize();
  runApp(ProviderScope(child: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
      DownloadServices.instance.getClipData();
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
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
