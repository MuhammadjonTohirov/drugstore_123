import 'package:drugstore/controllers/home_page_controller.dart';
import 'package:drugstore/views/right_side_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});
  final HomePageController controller = Get.put(HomePageController());

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}
// replace left side to add new drug item widget

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: Obx(() {
              return widget.controller
                  .screen(args: widget.controller.routeArguments);
            }),
          ),
          Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 0.1,
                  ),
                ),
                child: RightBodySide(),
              )),
        ],
      ),
    );
  }
}
