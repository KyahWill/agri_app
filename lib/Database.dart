import 'dart:async';
import 'dart:math';

import 'package:isar/isar.dart';
import 'package:agri_app/models/set.dart';
import 'package:agri_app/models/plot.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }
  Future<List<Set?>?> getSets() async {
    final isar = await db;
    return  await isar.sets.where().findAll();
  }

  Future<void> setSets() async {
    final isar = await db;
    final set = Set()
    ..dateCreated = DateTime.timestamp();
    await isar.writeTxn(() async {
      await isar.sets.put(set);
    });
  }

  Future<void> setPlot() async {
    final isar = await db;
    final plot = Plot();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [SetSchema,PlotSchema],
        directory: 'database',
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}