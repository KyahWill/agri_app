import 'dart:async';

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

  Future<Set?> getLatestSet() async {
    final isar = await db;
    return isar.sets.get(await isar.sets.count() - 1);
  }

  void setSets() async {
    final isar = await db;
    final set = Set()
    ..dateCreated = DateTime.timestamp();
    await isar.writeTxn(() async {
      await isar.sets.put(set);
    });
  }

  void setPlot(String address) async {
    final isar = await db;
    final setCount = await isar.sets.count();
    final set = await  isar.sets.get(setCount-1);

    final plot = Plot()
      ..status='not infected'
      ..address=address
      ..number=await set?.plots.count();

    set?.plots.add(plot);
    await isar.writeTxn(() async {
      await isar.plots.put(plot);
      await set?.plots.save();
    });
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