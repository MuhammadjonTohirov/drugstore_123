import 'dart:io';
import 'dart:typed_data';

import 'package:drugstore/database/drug_manager.dart';
import 'package:drugstore/database/media_manager.dart';
import 'package:drugstore/database/models/Drug.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDrugController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? imagePath;
  Uint8List? imageData;
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

    // save image at imagePath to a folder

    File imageFile = File(imagePath!);
    
    String imageKey = imageFile.absolute.path.replaceAll("\\", "_");

    final drug = Drug(
      name: titleController.text,
      description: descriptionController.text,
      image: imageKey,
    );

    MediaManager.instance.add(imageKey, await imageFile.readAsBytes());
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
    
    String imageKey = imageFile.absolute.path.replaceAll("/", "_");
    
    final drug = Drug(
      name: titleController.text,
      description: descriptionController.text,
      image: imageKey,
    );

    MediaManager.instance.update(imageKey, await imageFile.readAsBytes()); 

    if (drug.id == null && id != null) {
      drug.id = id;
    }

    return await DrugManager.instance.update(drug);
  }
}
