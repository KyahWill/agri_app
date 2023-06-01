import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          const Text("Coconut Leaf beetle Plot Detector",
              style:TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold
              )
          ),
          TextButton(
              onPressed: () => context.go("/camera"),
              child: const Text("Start")
          ),
          TextButton(
              onPressed: () => context.go("/instructions"),
              child: const Text("Instruction")
          ),
          TextButton(
              onPressed: () => context.go("/history"),
              child: const Text("Data History")
          ),
          TextButton(
              onPressed: () => context.go("/about"),
              child: const Text("About Brontispa")
          ),
        ]
      ),
    );
  }
}
