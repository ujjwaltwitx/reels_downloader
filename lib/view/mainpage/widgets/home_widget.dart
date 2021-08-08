import 'package:flutter/material.dart';
import 'package:reels_downloader/view/mainpage/widgets/manula_widget.dart';
import 'recents.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.1,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Paste Instagram URL here....",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    color: Colors.grey[200],
                    elevation: 0,
                    child: const Text('Paste Link',
                        style: TextStyle(color: Colors.pink)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    color: Colors.pink,
                    elevation: 0,
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: constraints.maxHeight * 0.2,
                child: Recents(constraints)),
            Expanded(child: ManualWidget())
          ],
        ),
      );
    });
  }
}
