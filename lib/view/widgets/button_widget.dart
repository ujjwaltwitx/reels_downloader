import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Function onTap;
  ButtonWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.blue,
            blurRadius: 8,
            spreadRadius: -2,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap();
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(14),
            child: Text("Download"),
            color: Colors.transparent,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
