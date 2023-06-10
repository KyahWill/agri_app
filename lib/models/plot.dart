import 'package:isar/isar.dart';
part 'plot.g.dart';

@collection
class Plot{
  Id id = Isar.autoIncrement;
  int? number;
  String? address;
  String? status;
}