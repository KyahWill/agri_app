import 'package:flutter/material.dart';
import 'package:agri_app/Database.dart';
import 'package:agri_app/models/set.dart';
import 'package:go_router/go_router.dart';
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final service = IsarService();
  var sets;

  Future<List<Set?>?> getSetsFromIsar() async {
    var temp = await service.getSets();
    setState(() {
      sets = temp;
    });
  }

  @override
  void initState() {
    getSetsFromIsar();
    super.initState();
  }
  Widget getHistory(){
    if (sets == null ) {
      return Center(child:
      Column( children: [
          SizedBox(
            width:double.infinity,
            height:80,
          ),
          Text("RESULTS"),
          Text("No Brontispa were Detected"),
          ElevatedButton(
            onPressed: () => context.go("/"),
            child: const Text("Go to home page"),
          ),
      ]),);
    }
    return ListView.builder(
      itemCount: sets.length,
      prototypeItem: ListTile(
        title: Text(sets.first),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(sets[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      SingleChildScrollView(
        child:getHistory()
      ),
    );
  }
}
