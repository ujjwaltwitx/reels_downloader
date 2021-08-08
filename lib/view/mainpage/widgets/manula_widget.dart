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
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
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
