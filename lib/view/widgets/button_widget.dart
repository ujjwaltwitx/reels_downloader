import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  ButtonWidget({Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 8, 121),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(255, 235, 8, 121),
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
            child: Text(title),
            color: Colors.transparent,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
