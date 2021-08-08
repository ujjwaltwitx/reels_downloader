import 'package:flutter/material.dart';

class Recents extends StatelessWidget {
  const Recents(this.constraints);
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ],
      );
    });
  }
}
