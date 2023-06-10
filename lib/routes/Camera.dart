import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:agri_app/Database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';

class CameraPage extends StatefulWidget {
  const CameraPage({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>{
  final service = IsarService();
  late CameraController cameraController = CameraController(
    widget.cameras[0],
    ResolutionPreset.medium,
    enableAudio: false,
     
  );
   String text = "WAITING TO START";
  late TextEditingController delayController = TextEditingController();
  late TextEditingController startDelayController = TextEditingController();
  late TextEditingController plotNumberController = TextEditingController();
  Timer? timer;
  Interpreter? interpreter;
  Future<List<CameraDescription>> getCamera() async{
    return availableCameras();
  }
  final picker = ImagePicker();

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
      final tensor = TensorImage.fromFile(File(image.path));
      print("TENSOR");
      print(tensor.dataType);
      await GallerySaver.saveImage(image.path);
      // final imageFile = await XFile('image.jpg').readAsBytes();

      var output = List.filled(1*3, 0).reshape([1,3]);

      interpreter!.run(image,
          output);

      print(output);

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
        text = "";
      });

    } catch (e) {
      print('Error capturing image: $e');
    }

  }
  void takePictures() async {
    var plotNumber = int.parse(plotNumberController.text);
    var delay = int.parse(delayController.text);
    var counter = 0;
    setState((){text = "starting now";});
    service.setSets();
    /*
    * timer.periodic = 1
    * cancel timer on delay * plotnumber
    * time left = delay - (counter % delay)
    * */
    var totalDelay = plotNumber * delay;
    timer = Timer.periodic(const Duration(seconds:1), (Timer t) async {
      var timeLeft = delay - (counter % delay);
      setState((){
        text="$timeLeft seconds left";
      });
      if(counter >= totalDelay){
        t.cancel();
        setState((){
          text="DONE";
        });
        context.go('/results');
      }
      if(counter % delay == 0){
        takePicture();
        String address = (await picker.pickImage(source: ImageSource.gallery))!.path;
        service.setPlot(address);
      }
      counter+=1;
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
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: const Text("Go to home page"),
            ),
            const SizedBox(
              width:double.infinity,
              height:30,
            ),
            SizedBox(
              width:double.infinity,
              height:500,
              child:Padding(
                  padding: const EdgeInsets.all(16),
                  child:CameraPreview(cameraController)
              ),
            ),

            SizedBox(
              width:double.infinity,
              height:150,
              child:Row(
                children:[
                  TextButton(
                      onPressed: ()=>takePictures(),
                      child:const Text("START")

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
                          const Text("Delay"),
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
                            const Text("Plot Number"),
                          ]
                      ),
                      Text(text),
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
  }
}
