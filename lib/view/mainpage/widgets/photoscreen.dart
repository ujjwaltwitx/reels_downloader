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

class PhotoScreen extends StatelessWidget {
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
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.2), //color of shadow
                            spreadRadius: 3, //spread radius
                            blurRadius: 7, // blur radius
                            offset: const Offset(
                                0, 2), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    child: Image.file(
                                      File(
                                        photoListReversed
                                            .elementAt(index)
                                            .photoPath,
                                      ),
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
                                        onPressed: () async {
                                          final file = File(photoListReversed
                                              .elementAt(index)
                                              .photoPath);

                                          box.deleteAt(
                                              box.values.length - index - 1);
                                          await file.delete();
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black54,
                                        ),
                                      ),
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
                                          color: Colors.black54,
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
                                          color: Colors.black54,
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
