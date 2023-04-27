// create body menu controller
import 'package:drugstore/controllers/add_drug_controller.dart';
import 'package:drugstore/database/models/Drug.dart';
import 'package:drugstore/views/add_new_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/pages/drug_list/drug_list.dart';
import 'drug_list_controller.dart';

// import '../views/drug_item_view.dart';

// create enum for menus
abstract class MenuType {}

enum HomeMenuType implements MenuType {
  add,
  edit,
  delete,
  back,
}

enum AddDrugMenuType implements MenuType {
  save,
  cancel,
}

class MenuItem {
  const MenuItem({
    required this.title,
    required this.icon,
    required this.type,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final MenuType type;
  final Function onTap;
}

class HomePageController extends GetxController {
// create menu list
  final RxList<MenuItem> menuItems = RxList<MenuItem>([]);
  final Rx<RouteType> routeType = RouteType.home.obs;
  Map<String, dynamic> routeArguments = {};
  @override
  void onInit() {
    // add 3 items to list
    menusForHomePage();
    super.onInit();
  }

  void menusForHomePage() {
    menuItems.value = [];
    menuItems.add(
      MenuItem(
        title: 'Qo\'shish',
        icon: Icons.add,
        type: HomeMenuType.add,
        onTap: () {
          routeArguments = {};
          routeType.value = RouteType.add;
          menusForAddNewDrug();
        },
      ),
    );
    menuItems.add(
      MenuItem(
        title: 'O\'chirish',
        icon: Icons.delete,
        type: HomeMenuType.delete,
        onTap: () {
          routeArguments = {};
          DrugListController controller = Get.find<DrugListController>();
          controller.deleteSelectedItems();
          update();
        },
      ),
    );
  }

  void menusForAddNewDrug() {
    menuItems.value = [];
    menuItems.add(
      MenuItem(
        title: 'Saqlash',
        icon: Icons.save,
        type: AddDrugMenuType.save,
        onTap: () {
          AddDrugController controller = Get.find<AddDrugController>();
          if (routeArguments.isEmpty) {
            controller.saveDrug().then((newDrug) {
              if (newDrug != null) {
                // add new drug to list
                DrugListController drugListController =
                    Get.find<DrugListController>();
                drugListController.addDrug(newDrug);
                menusForHomePage();

                routeType.value = RouteType.home;
              }
            });
          } else {
            controller.updateDrug().then((drug) {
              if (drug != null) {
                // add new drug to list
                DrugListController drugListController =
                    Get.find<DrugListController>();
                drugListController.reloadData();
                menusForHomePage();

                routeType.value = RouteType.home;
              }
            });
          }
        },
      ),
    );

    menuItems.add(
      MenuItem(
        title: 'Qaytish',
        icon: Icons.cancel,
        type: AddDrugMenuType.cancel,
        onTap: () {
          routeType.value = RouteType.home;
          menusForHomePage();
        },
      ),
    );
  }

  void editDrug(Drug drug) {
    routeArguments['drug'] = drug;
    routeType.value = RouteType.edit;
    menusForAddNewDrug();
  }

  @override
  void onClose() {
    super.onClose();
    menuItems.clear();
  }

  Widget screen({Map<String, dynamic> args = const {}}) {
    switch (routeType.value) {
      case RouteType.home:
        return DrugListWidget();
      case RouteType.add:
        return AddNewItem();
      case RouteType.edit:
        return AddNewItem(drug: args['drug'] as Drug);
    }
  }
}
