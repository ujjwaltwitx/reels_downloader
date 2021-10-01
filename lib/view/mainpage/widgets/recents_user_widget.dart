import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class RecentUserWidget extends ConsumerWidget {
  const RecentUserWidget(this.constraints);
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.08,
          ),
          const Text("Recents"),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: LayoutBuilder(
                builder: (context, BoxConstraints constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box<UserModel>(userBox).listenable(),
                      builder: (context, Box<UserModel> usermodel, _) {
                        return ListView.builder(
                          itemBuilder: (_, index) {
                            if (index < 10) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    await url_launcher.launch(
                                        'https://www.instagram.com/${usermodel.values.toList().reversed.elementAt(index).usrname}/');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    height: constraints.maxHeight * 0.7,
                                    width: constraints.maxHeight * 0.7,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(colors: [
                                        Colors.pink,
                                        Colors.red,
                                        Colors.orange
                                      ]),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(usermodel
                                          .values
                                          .toList()
                                          .reversed
                                          .elementAt(index)
                                          .thumbnailUrl),
                                      radius: constraints.maxHeight * 0.3,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            } else {}
                            return null;
                          },
                          itemCount: usermodel.length,
                          scrollDirection: Axis.horizontal,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
