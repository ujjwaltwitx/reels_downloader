import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/main_page_controller.dart';
import 'all_downloads.dart';
import 'home_widget.dart';
import '../widgets/navigation_widget.dart';

class MainPage extends ConsumerWidget {
  final widgetList = [HomeWidget(), DownloadWidget()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndexController = ref.watch(mainControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: widgetList[pageIndexController.selectIndex],
      ),
      bottomNavigationBar: NavigationWidget('Home', 'Downloads'),
    );
  }
}
