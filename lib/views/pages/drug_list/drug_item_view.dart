import 'dart:io';
import 'package:drugstore/database/models/Drug.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

import '../../../controllers/drug_list_controller.dart';
import '../../../database/media_manager.dart';

// ignore: must_be_immutable
class DrugItem extends StatefulWidget {
  // create id with random string, do not use get package
  final int id;
  final String image;
  final String title;
  final String description;

  late Function(int) onClick;

  DrugItem({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  void setOnClick(Function(int) onClick) {
    this.onClick = onClick;
  }

  img.Image? _imageView;

  factory DrugItem.createWith(Drug drug) {
    return DrugItem(
      id: drug.id ?? 0,
      image: drug.image,
      title: drug.name,
      description: drug.description,
    );
  }

  @override
  State<DrugItem> createState() => _DrugItemState();

  DrugItem copyWith({required bool isSelected}) {
    return DrugItem(
      id: id,
      image: image,
      title: title,
      description: description,
    );
  }
}

class _DrugItemState extends State<DrugItem> {
  @override
  Widget build(BuildContext context) {
    // add on hover method
    // highlight on hover
    return InkWell(
        onTap: () {
          widget.onClick(widget.id);
        },
        child: body());
  }

  bool _isAlive = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _isAlive = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isAlive = false;
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
          width: 0.1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageView2(),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  // set max lines to 4
                  maxLines: 4,
                  // set text overflow to ellipsis
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // add clickable select box widget and if is selected put a check icon if not leave it empty.

          InkWell(
            onTap: () {
              // use key to get the state of the widget and change the state of the widget
              final controller = Get.find<DrugListController>();
              setState(() {
                if (controller.isSelected(widget.id)) {
                  controller.deselectItem(widget.id);
                } else {
                  controller.selectItem(widget.id);
                }
              });
            },
            child: selectBox(),
          ),
        ],
      ),
    );
  }

  Widget imageView() {
    File image = File(widget.image);
    if (image.existsSync()) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        width: 100,
      );
    } else {
      return Image.asset(
        widget.image,
        fit: BoxFit.cover,
        width: 100,
      );
    }
  }

  Widget _imageView2() {
    if (widget._imageView != null) {
      //with fit cover and with 100
      return Image.memory(
        img.encodePng(widget._imageView!),
        fit: BoxFit.cover,
        width: 100,
        height: 70,
      );
    } else {
      return Image.asset(
        'bin/media/placeholder.png',
        fit: BoxFit.cover,
        width: 100,
        height: 70,
      );
    }
  }

  void _loadImage() {
    String imageKey = widget.image;

    MediaManager.instance.get(imageKey).then((value) {
      if (!_isAlive) {
        return;
      }

      setState(() {
        if (value == null) {
          widget._imageView = null;
          return;
        }
        final image = img.decodeImage(value);
        widget._imageView = image;
      });
    });
  }

  Widget selectBox() {
    final controller = Get.find<DrugListController>();
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
          width: 0.1,
        ),
      ),
      child: controller.isSelected(widget.id) ? const Icon(Icons.check) : null,
    );
  }
}
