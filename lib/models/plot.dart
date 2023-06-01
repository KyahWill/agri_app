import 'dart:typed_data';
import 'package:isar/isar.dart';
part 'plot.g.dart';

@collection
class Plot{
  Id id = Isar.autoIncrement;
  String? address;

}