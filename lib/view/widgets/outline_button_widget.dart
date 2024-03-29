import 'package:flutter/material.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({Key? key, required this.onTap}) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 235, 8, 121), width: 2),
      ),
      child: Material(
        child: InkWell(
          splashColor: Color.fromARGB(131, 235, 8, 122),
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap();
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(12),
            child: Text(
              "Paste",
              style: TextStyle(color: Color.fromARGB(255, 235, 8, 121)),
            ),
            color: Colors.transparent,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
