// drug details page

import 'package:drugstore/database/models/Drug.dart';
import 'package:flutter/material.dart';

class DrugDetailsPage extends StatefulWidget {
  final Drug drug;

  const DrugDetailsPage({Key? key, required this.drug}) : super(key: key);

  @override
  State<DrugDetailsPage> createState() => _DrugDetailsPageState();
}

class _DrugDetailsPageState extends State<DrugDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // there should me drug image, title, and description
    return Column(
      children: [
        // drug image
        Image.asset(widget.drug.image),
        Row(
          children: [
            // drug title
            Text(widget.drug.name),
            // drug description
            Text(widget.drug.description),
          ],
        ),
      ],
    );
  }
}
