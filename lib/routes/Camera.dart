import 'dart:io';

import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'package:flutter/material.dart';

import 'dart:async';

class CameraPage extends StatefulWidget {
  const CameraPage({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>{

   late CameraController cameraController = CameraController(
    widget.cameras[0],
    ResolutionPreset.medium,
    enableAudio: false,
     
  );
  late TextEditingController delayController = TextEditingController();
  late TextEditingController startDelayController = TextEditingController();
  late TextEditingController plotNumberController = TextEditingController();
  Timer? timer;
  Interpreter? interpreter;
  Future<List<CameraDescription>> getCamera() async{
    return availableCameras();
  }

// Get a specific camera from the list of available cameras.

  void startCamera() async{
    interpreter = await Interpreter.fromAsset('test.tflite');
    await cameraController.initialize().then((value) => {
      if(mounted){
        setState(() {})
      }
    }).catchError((error) => {
      print(error)
    });
    cameraController.setFlashMode(FlashMode.off);
  }
  void takePicture() async{

    try {
      final image = await cameraController.takePicture();
      await GallerySaver.saveImage(image.path);
      // final imageFile = await XFile('image.jpg').readAsBytes();
      final tensor = TensorImage.fromFile(File(image!.path));

      // Pass the tensor to the interpreter.
      // final outputBuffer = TensorBuffer.createFixedSize(
      //   interpreter?.outputShape,
      //   _model.outputType,
      // );
      //
      // _model.interpreter.run(inputImage.buffer, outputBuffer.buffer);
      //
      // // Print the output.
      // print('OUTPUT: ');
      // print(outputs[0]);
      // final imageBytes = await image.readAsBytes();

      // File imageFile = File(image!.path);
      // int currentUnix = DateTime.now().millisecondsSinceEpoch;
      // final directory = (await getApplicationDocumentsDirectory())!.path;
      // String fileFormat = imageFile.path.split('.').last;
      // await imageFile.create();

      // getting a directory path for saving
      // final String path = getApplicationDocumentsDirectory().toString();

// copy the file to a new path


      setState(() {
      });

    } catch (e) {
      print('Error capturing image: $e');
    }

  }
  void takePictures() {
    var plotNumber = int.parse(plotNumberController.text);
    var startDelay = int.parse(startDelayController.text);
    var delay = int.parse(delayController.text);
    var counter = 0;

    timer = Timer.periodic(Duration(seconds:delay), (Timer t) {
      if(counter >= plotNumber){
        t.cancel();
      }else{
        takePicture();
        counter+=1;
      }

    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    await cameraController.initialize().then((value) => {
      if(mounted){
        setState(() {})
      }
    }).catchError((error) => {
      print(error)
    });
  }
  @override
  void initState(){
    delayController.text = '0';
    startDelayController.text = '0';
    plotNumberController.text = '0';

    startCamera();

    super.initState();
  }

  @override
  void dispose(){
    cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(cameraController.value.isInitialized){
      return Scaffold(
        body:
        SingleChildScrollView(
          child: Column(
          children: [
            const SizedBox(
              width:double.infinity,
              height:30,
            ),
            SizedBox(
              width:double.infinity,
              height:500,
              child:Padding(padding: EdgeInsets.all(16),child:CameraPreview(cameraController)),
            ),

            SizedBox(
              width:double.infinity,
              height:150,
              child:Row(
                children:[
                  Container(
                    child:TextButton(
                      onPressed: () => {takePictures()},
                      child:Text("START")
                    )
                  ),
                  Column(
                    children: [
                      Row(
                        children:[
                          SizedBox(
                          width:50,
                          child:TextFormField(
                            controller: delayController,
                            keyboardType: TextInputType.number,
                            ),
                          ),
                          Text("Delay"),
                        ]
                      ),
                      Row(
                          children:[
                            SizedBox(
                             width:50,
                             child:TextField(
                               controller: startDelayController,
                               keyboardType: TextInputType.number,
                             ),
                            ),
                            Text("Start Time"),
                          ]
                      ),
                      Row(
                          children:[
                            SizedBox(
                              width:50,
                              child:TextField(
                                controller: plotNumberController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Text("Plot Number"),
                          ]
                      ),
                    ]
                  )
                ]
              )
            ),
          ],
        ),)
      );
    }else {
      return Text("Error with setting up camera");
    }
    return const Placeholder();
  }
}
