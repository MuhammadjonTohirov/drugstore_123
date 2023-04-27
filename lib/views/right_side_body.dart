// q: import widgets and create widget and add buttons vertically
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_page_controller.dart';

class RightBodySide extends StatefulWidget {
  // create controller
  final HomePageController controller = Get.find<HomePageController>();

  RightBodySide({super.key});

  @override
  State<RightBodySide> createState() => _RightBodySideState();
}

class _RightBodySideState extends State<RightBodySide> {
  // handle on tap add
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: widget.controller.menuItems.map((element) {
          return Button(
            text: element.title,
            icon: Icon(element.icon),
            onTap: () {
              setState(() {
                element.onTap();
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

// create button
class Button extends StatelessWidget {
  const Button(
      {super.key, required this.text, required this.icon, required this.onTap});

  final String text;
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: body(),
    );
  }

  Widget body() {
    // add an icon to the left and a text to the right
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black38,
            width: 0.1,
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16.0),
            Text(text),
          ],
        ),
      ),
    );
  }
}
