import 'package:agri_app/routes/Camera.dart';
import 'package:agri_app/routes/Instruction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agri_app/routes/Home.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras =await availableCameras();
  runApp(MyApp(cameras:cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required cameras,super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/camera',
            builder: (context, state) => CameraPage(cameras:cameras),
          ),
          GoRoute(
            path: '/results',
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: '/instruction',
            builder: (context, state) => Instruction(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => HomePage(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => HomePage(),
          ),
        ],
      ),
    );
  }
}
// GoRouter configuration