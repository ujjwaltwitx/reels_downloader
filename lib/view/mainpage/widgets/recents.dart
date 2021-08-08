import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reels_downloader/controller/download_controller/download_services.dart';

class Recents extends ConsumerWidget {
  const Recents(this.constraints);
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final linksProvider = watch(downloadServicesProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.015,
          ),
          const Text("Recents"),
          SizedBox(
            height: constraints.maxHeight * 0.08,
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
                      child: ListView.builder(
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        linksProvider.thumbnailUrl),
                                    radius: constraints.maxHeight * 0.3,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Text('ujjwal'),
                              ],
                            ),
                          );
                        },
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  },
                )),
          ),
        ],
      );
    });
  }
}
