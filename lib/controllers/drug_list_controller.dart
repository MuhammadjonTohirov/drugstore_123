// create controller for home_page.dart
import 'dart:async';

import 'package:drugstore/controllers/home_page_controller.dart';
import 'package:drugstore/database/drug_manager.dart';
import 'package:drugstore/database/models/Drug.dart';
import 'package:drugstore/views/pages/drug_list/drug_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/mocks/drug_mocks.dart';

enum RouteType {
  home,
  add,
  edit,
}

class DrugListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  // create list of drugItems
  final RxList<DrugItem> drugItems = RxList<DrugItem>([]);
  // create list of selected item ids
  final RxList<int> selectedIds = RxList<int>([]);
  // create route type

  Timer? _timer;

  @override
  void onInit() {
    // add 3 items to list
    fetchItems();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    drugItems.close();
    selectedIds.clear();
    super.onClose();
  }

  void fetchItems() {
    DrugMocks.createAll().then(
      (value) => DrugManager.instance.getAll().then((value) {
        for (var element in value) {
          addDrug(element);
        }
      }),
    );
  }

  void addDrug(Drug item) {
    DrugItem drugItem = DrugItem.createWith(item);
    drugItem.onClick = (p0) {
      HomePageController menuController = Get.find<HomePageController>();
      menuController.editDrug(item);
    };
    drugItems.add(drugItem);
  }

  void reloadData() {
    drugItems.clear();
    fetchItems();
  }

  void selectItem(int id) {
    selectedIds.add(id);
  }

  void deselectItem(int id) {
    selectedIds.remove(id);
  }

  bool isSelected(int id) {
    return selectedIds.contains(id);
  }

  bool hasSelectedItems() {
    return selectedIds.isNotEmpty;
  }

  void deleteSelectedItems() {
    for (var id in selectedIds) {
      drugItems.removeWhere((element) => element.id == id);
      DrugManager.instance.deleteBy(id);
    }

    update();
  }

  void _searchItems() {
    // filter drugst
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      reloadData();
      return;
    }

    drugItems.retainWhere((element) {
      return element.title.toLowerCase().contains(query);
    });
  }

  void setSearchText(String text) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer(const Duration(milliseconds: 500), () {
      _searchItems();
    });
  }
}
