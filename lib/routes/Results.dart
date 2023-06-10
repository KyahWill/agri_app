import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agri_app/Database.dart';
import 'package:agri_app/models/set.dart';
import 'package:agri_app/models/plot.dart';
class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final service = IsarService();
  Set? set;
  List<Plot>? plots;

  Future<void> getSetsFromIsar() async {
    Set? temp = await service.getLatestSet();
    setState(() {
      set = temp;
      plots = set?.plots.toList();
    });
  }

  @override
  void initState() {
    getSetsFromIsar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children:[
          const SizedBox(
            width:double.infinity,
            height:80,
          ),
          Text("RESULTS"),
          ListView.builder(
            itemCount: plots?.length,
            prototypeItem: ListTile(
                title: Text(plots!.first.number.toString()),
                leading: Text(plots!.first.status!)
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(plots![index].number.toString()),
                leading:Text(plots![index].status!),
              );
            },
          ),
        ElevatedButton(
          onPressed: () => context.go("/"),
          child: const Text("Go to home page"),

        ),],
      ),
      );
  }
}
