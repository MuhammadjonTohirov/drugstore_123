import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/drug_list_controller.dart';

class DrugListWidget extends StatefulWidget {
  DrugListController controller =
      Get.put<DrugListController>(DrugListController());

  DrugListWidget({Key? key}) : super(key: key);

  @override
  State<DrugListWidget> createState() => _DrugListWidgetState();
}

class _DrugListWidgetState extends State<DrugListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller.searchController,
                  decoration: const InputDecoration(
                    hintText: 'Qidirish',
                  ),
                  onChanged: (value) => widget.controller.setSearchText(value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView(
              children: widget.controller.drugItems.toList(),
            ),
          ),
        ),
      ],
    );
  }
}
