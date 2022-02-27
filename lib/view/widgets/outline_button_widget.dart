import 'package:flutter/material.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Material(
        child: InkWell(
          splashColor: Color.fromARGB(83, 33, 149, 243),
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.all(12),
            child: Text(
              "Paste",
              style: TextStyle(color: Colors.blue),
            ),
            color: Colors.transparent,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
