import 'package:flutter/material.dart';

class ManualWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.04,
          ),
          const Text("Manual"),
          SizedBox(
            height: constraints.maxHeight * 0.03,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        "1. Open Instagram > Go to reels > Click 'Share to'"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(child: Image.asset('assets/1.png')),
                  const SizedBox(
                    height: 20,
                  ),
                  const FittedBox(
                      fit: BoxFit.fitWidth,
                      child:
                          Text("2. Choose 'Insta Reels Saver' from the list.")),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(child: Image.asset('assets/2.png')),
                  const SizedBox(
                    height: 20,
                  ),
                  const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        "3. Click 'Download' and wait for download to finish"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(child: Image.asset('assets/3.png')),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.03,
          )
        ],
      );
    });
  }
}
