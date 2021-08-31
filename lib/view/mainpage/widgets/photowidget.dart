import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:reels_downloader/model/photo/photo_model.dart';
import 'package:share/share.dart';

import '../../../main.dart';

class PhotoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<PhotoModel>(photoBox).listenable(),
        builder: (context, Box<PhotoModel> box, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (box.isEmpty) {
                return Center(
                  child: SvgPicture.asset(
                    'assets/empty.svg',
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final photoListReversed = box.values.toList().reversed;
                  if (photoListReversed.elementAt(index) == null) {
                    return null;
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      height: constraints.maxHeight * 0.9,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     Container(
                                //       margin: const EdgeInsets.all(8),
                                //       padding: const EdgeInsets.all(5),
                                //       height: constraints.maxHeight * 0.08,
                                //       decoration: const BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         color: Colors.white,
                                //       ),
                                //       child: GestureDetector(
                                //         onTap: () {
                                //           launch(
                                //             "https://www.instagram.com/${photoListReversed.elementAt(index).ownerId}",
                                //           );
                                //         },
                                //         child: CircleAvatar(
                                //           backgroundImage: NetworkImage(
                                //             photoListReversed
                                //                 .elementAt(index)
                                //                 .ownerThumbnailUrl,
                                //           ),
                                //           radius: constraints.maxHeight * 0.03,
                                //         ),
                                //       ),
                                //     ),
                                //     Text(
                                //       photoListReversed.elementAt(index).ownerId,
                                //       style: const TextStyle(color: Colors.white),
                                //     )
                                //   ],
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    OpenFile.open(
                                      photoListReversed
                                          .elementAt(index)
                                          .photoPath,
                                    );
                                  },
                                  child: SizedBox(
                                    height: constraints.maxHeight * 0.92,
                                    width: double.infinity,
                                    child: Image.network(
                                      photoListReversed
                                          .elementAt(index)
                                          .photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.05,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        splashRadius: 2,
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: photoListReversed
                                                  .elementAt(index)
                                                  .toSendLink,
                                            ),
                                          );
                                          Fluttertoast.showToast(
                                            msg: "Copied To Clipboard",
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.white,
                                            textColor: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        splashRadius: 2,
                                        onPressed: () {
                                          Share.shareFiles([
                                            photoListReversed
                                                .elementAt(index)
                                                .photoPath
                                          ]);
                                        },
                                        icon: const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        splashRadius: 2,
                                        onPressed: () async {
                                          final file = File(photoListReversed
                                              .elementAt(index)
                                              .photoPath);

                                          box.deleteAt(
                                              box.values.length - index - 1);
                                          await file.delete();
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
                itemCount: Hive.box<PhotoModel>(photoBox).values.length,
              );
            },
          );
        },
      ),
    );
  }
}
