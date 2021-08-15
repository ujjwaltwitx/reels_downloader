import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reels_downloader/main.dart';
import 'package:reels_downloader/model/useraccounts/user_model.dart';

class Recents extends ConsumerWidget {
  const Recents(this.constraints);
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
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromRGBO(240, 20, 140, 1),
                                    radius: constraints.maxHeight * 0.35,
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
                            },
                            itemCount: usermodel.length,
                            scrollDirection: Axis.horizontal,
                          );
                        }),
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
