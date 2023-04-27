import 'dart:io';
import 'dart:typed_data';

import 'package:drugstore/database/drug_manager.dart';
import 'package:drugstore/database/media_manager.dart';
import 'package:drugstore/database/models/Drug.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class AddDrugController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? imagePath;
  img.Image? imageValue;
  int? id;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<Drug?> saveDrug() async {
    // a: create a drug object
    if (titleController.text.isEmpty) {
      return null;
    }

    if (descriptionController.text.isEmpty) {
      return null;
    }

    if (imagePath == null) {
      return null;
    }

    File imageFile = File(imagePath!);

    String imageKey = imageFile.absolute.path.replaceAll("\\", "_");

    final drug = Drug(
      name: titleController.text,
      description: descriptionController.text,
      image: imageKey,
    );

    await MediaManager.instance.addFromFile(imageFile);
    return await DrugManager.instance.add(drug);
  }

  Future<Drug?> updateDrug() async {
    if (titleController.text.isEmpty) {
      return null;
    }

    if (descriptionController.text.isEmpty) {
      return null;
    }

    if (imagePath == null) {
      return null;
    }

    File imageFile = File(imagePath!);
    String imageKey = imageFile.absolute.path.replaceAll("\\", "_");

    final drug = Drug(
      name: titleController.text,
      description: descriptionController.text,
      image: imageKey,
    );

    if (drug.id == null && id != null) {
      drug.id = id;
    }

    await MediaManager.instance.updateWithFile(imageKey, imageFile);

    return await DrugManager.instance.update(drug);
  }
}
