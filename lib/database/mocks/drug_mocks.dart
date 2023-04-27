import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:drugstore/database/drug_manager.dart';
import 'package:drugstore/database/models/Drug.dart';

class DrugMocks {
  static Future<void> createAll() async {
    List<Drug> drugs = await DrugManager.instance.getAll();
    if (drugs.isNotEmpty) return;

  //   DrugManager.instance.add(
  //     Drug(
  //       image: 'bin/media/drugs/ginseng.png',
  //       name: 'Ginseng',
  //       description: await rootBundle.loadString('bin/data/drugs/ginseng.txt'),
  //     ),
  //   );

  //   DrugManager.instance.add(
  //     Drug(
  //       image: 'bin/media/drugs/aloe.png',
  //       name: 'Aloe',
  //       description: "await rootBundle.loadString('bin/data/drugs/aloe.txt')",
  //     ),
  //   );

  //   DrugManager.instance.add(
  //     Drug(
  //       image: 'bin/media/drugs/mint.png',
  //       name: 'Mint',
  //       description: await rootBundle.loadString('bin/data/drugs/mint.txt'),
  //     ),
  //   );
  }
}
