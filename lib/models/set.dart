import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:agri_app/models/plot.dart';
part 'set.g.dart';

@collection
class Set {
  Id id = Isar.autoIncrement;
  DateTime? dateCreated;
  final plots = IsarLink<Plot>();
}

