import 'dart:io';

import 'package:drugstore/controllers/add_drug_controller.dart';
import 'package:drugstore/database/media_manager.dart';
import 'package:drugstore/database/models/Drug.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

// ignore: must_be_immutable
class AddNewItem extends StatefulWidget {
  AddDrugController controller = Get.put(AddDrugController());
  late Drug? drug;
  AddNewItem({super.key, this.drug}) {
    initState();
  }

  @override
  _AddNewItemState createState() => _AddNewItemState();

  void initState() {
    if (drug != null) {
      controller.titleController.text = drug!.name;
      controller.descriptionController.text = drug!.description;
      controller.id = drug?.id;
    } else {
      controller.titleController.clear();
      controller.descriptionController.clear();
      controller.imagePath = null;
      controller.imageValue = null;
      controller.id = null;
    }
  }
}

class _AddNewItemState extends State<AddNewItem> {
  bool _isAlive = false;
  @override
  void initState() {
    super.initState();
    _isAlive = true;
    _loadImageFromDb();
  }

  @override
  void dispose() {
    _isAlive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageView(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        onClickSelectImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Suratni tanlang',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.controller.titleController,
                decoration: const InputDecoration(
                  hintText: 'Nomini kiriting',
                  labelText: 'O\'simlik nomi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.controller.descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'O\'simlik haqida ma\'lumot kiriting',
                  labelText: 'O\'simlik haqida ma\'lumot',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    // a: if image path is null, show placeholder image
    if (widget.drug?.image.isEmpty ??
        true && widget.controller.imagePath == null) {
      return Image.asset('bin/media/placeholder.png', fit: BoxFit.cover);
    } else {
      // b: if image path is not null, show image from path
      if (widget.controller.imagePath != null) {
        if (File(widget.controller.imagePath!).existsSync()) {
          return Image.file(
            File(widget.controller.imagePath!),
            fit: BoxFit.cover,
          );
        } else {
          return Image.memory(
            img.encodePng(widget.controller.imageValue!),
            fit: BoxFit.cover,
          );
        }
      } else {
        // c: if image path is not null, but file not exists, show placeholder image
        if (widget.controller.imageValue == null) {
          return Image.asset('bin/media/placeholder.png', fit: BoxFit.cover);
        }
        return Image.memory(
          img.encodePng(widget.controller.imageValue!),
          fit: BoxFit.cover,
        );
      }
    }
  }

  void _loadImageFromDb() {
    if (widget.drug != null && widget.drug!.image.isNotEmpty) {
      MediaManager.instance.get(widget.drug!.image).then((value) {
        setState(() {
          if (value == null) {
            widget.controller.imagePath = null;
            widget.controller.imageValue = null;
            return;
          }

          img.Image? image = img.decodeImage(value);
          widget.controller.imageValue = image;
        });
      });
    }
  }

  //q: need to implement this method to pick a image from folder in windows or mac machines
  void onClickSelectImage() {
    // a: use file_picker package
    // https://pub.dev/packages/file_picker
    FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowCompression: true,
    )
        .then((value) {
      if (value != null) {
        final path = value.files.single.path;
        setState(() {
          widget.controller.imagePath = path;
        });
      }
    });
  }
}

class EditableRichText extends StatefulWidget {
  const EditableRichText({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditableRichTextState createState() => _EditableRichTextState();
}

class _EditableRichTextState extends State<EditableRichText> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditableText(
          controller: _controller,
          backgroundCursorColor: Colors.redAccent,
          cursorColor: Colors.red,
          selectionColor: Colors.blue,
          style: const TextStyle(fontSize: 20, color: Colors.black),
          cursorRadius: const Radius.circular(5),
          maxLines: null,
          selectionControls: MaterialTextSelectionControls(),
          strutStyle: const StrutStyle(
            fontSize: 10,
            height: 2,
          ),
          focusNode: FocusNode(
            canRequestFocus: true,
            skipTraversal: true,
            debugLabel: 'EditableText',
          ),
        ),
        RichText(
          text: TextSpan(
            text: '',
            style: const TextStyle(color: Colors.black, fontSize: 20),
            children: <TextSpan>[
              TextSpan(text: _controller.text),
            ],
          ),
        ),
      ],
    );
  }
}
