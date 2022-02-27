import 'package:flutter/material.dart';

class ViewCountText extends StatelessWidget {
  final int viewcount;
  final int fontSize;
  const ViewCountText({
    Key? key,
    required this.viewcount,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String suffix = 'K';
    int view = 0;
    if (viewcount >= 1000000) {
      suffix = 'M';
      view = viewcount ~/ 1000000;
    } else {
      view = viewcount ~/ 1000;
    }

    return Text(
      '$view$suffix views',
      style: TextStyle(fontSize: fontSize.toDouble()),
    );
  }
}
