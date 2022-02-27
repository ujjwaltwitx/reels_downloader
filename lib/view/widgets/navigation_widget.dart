import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/main_page_controller.dart';

class NavigationWidget extends StatefulWidget {
  final String firstItem;
  final String secondItem;

  const NavigationWidget(this.firstItem, this.secondItem, {Key? key})
      : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  bool first = true;
  bool second = false;

  void changeIndex({bool val = true}) {
    if (val) {
      return;
    }
    setState(() {
      first = !first;
      second = !second;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final pageIndexController = ref.watch(mainControllerProvider);
        return Container(
          padding: const EdgeInsets.all(8),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 218, 218, 218),
                spreadRadius: 5,
                blurRadius: 20,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    changeIndex(
                      val: first,
                    );
                    pageIndexController.changeIndex(0);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: first ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        if (first)
                          const BoxShadow(
                            color: Colors.blue,
                            blurRadius: 8,
                          ),
                        const BoxShadow(color: Colors.transparent)
                      ],
                    ),
                    child: Text(
                      widget.firstItem,
                      style: TextStyle(
                        color: first
                            ? const Color.fromARGB(246, 242, 242, 253)
                            : const Color.fromARGB(255, 105, 99, 99),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    changeIndex(val: second);
                    pageIndexController.changeIndex(1);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: second ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        if (second)
                          const BoxShadow(
                            color: Colors.blue,
                            blurRadius: 8,
                          ),
                        const BoxShadow(color: Colors.transparent)
                      ],
                    ),
                    child: Text(
                      widget.secondItem,
                      style: TextStyle(
                        color: second
                            ? const Color.fromARGB(246, 242, 242, 253)
                            : const Color.fromARGB(255, 105, 99, 99),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
