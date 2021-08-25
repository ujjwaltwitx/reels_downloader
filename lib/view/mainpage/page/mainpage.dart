import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_downloader/view/mainpage/widgets/down_history_widget.dart';
import 'package:reels_downloader/view/mainpage/widgets/policy_dialog.dart';
import 'package:share/share.dart';
import '../../../controller/mainpage/main_page_controller.dart';
import '../widgets/home_widget.dart';

final mainControllerProvider =
    ChangeNotifierProvider<MainPageController>((ref) {
  return MainPageController();
});

class MainPage extends ConsumerWidget {
  final widgetList = [HomeWidget(), DownloadWidget()];
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final statusHeight = MediaQuery.of(context).padding.top;
    final mainPageController = watch(mainControllerProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return WillPopScope(
        onWillPop: () async {
          if (mainPageController.selectIndex == 0) {
            return true;
          }
          mainPageController.changeIndex(0);
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Center(
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset(
                        'assets/appIcon.png',
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 25,
                  thickness: 4,
                ),
                ListTile(
                  title: const Text('Share with friends'),
                  leading: const Icon(
                    Icons.share,
                    color: Colors.pink,
                  ),
                  onTap: () {
                    Share.share(
                        'Download this light weight and ultra fast Instagram Reels Downloader and enjoy watching your favourite reels offline. Click the link to download now https://play.google.com/store/apps/details?id=com.alphax.reels');
                  },
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  leading: const Icon(
                    Icons.policy,
                    color: Colors.pink,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return const PolicyDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('Terms and Conditions'),
                  leading: const Icon(
                    Icons.privacy_tip,
                    color: Colors.pink,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return const PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: (constraints.maxHeight - statusHeight) * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (context) {
                          return IconButton(
                            splashRadius: 25,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          );
                        }),
                        const Text("Insta Reels Downloader"),
                        IconButton(
                          onPressed: () {
                            Share.share(
                                'Download this light weight and ultra fast Instagram Reels Downloader and enjoy watching your favourite reels offline. Click the link to download now https://play.google.com/store/apps/details?id=com.alphax.reels');
                          },
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (constraints.maxHeight - statusHeight) * 0.84,
                    child: IndexedStack(
                      index: mainPageController.selectIndex,
                      children: widgetList,
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: (constraints.maxHeight - statusHeight) * 0.08,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.download),
                  label: "Downloads",
                ),
              ],
              currentIndex: mainPageController.selectIndex,
              fixedColor: Colors.pink,
              onTap: (int index) {
                mainPageController.changeIndex(index);
              },
            ),
          ),
        ),
      );
    });
  }
}
