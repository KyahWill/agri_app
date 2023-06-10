import 'dart:ui';

import 'package:agri_app/model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:camera/camera.dart';

// Future<Classifier> _loadLabels(String labelsFileName) async {
//
// // #1
// final rawLabels = await FileUtil.loadLabels(labelsFileName);
//
// // #2
// final labels = rawLabels
//     .map((label) => label.substring(label.indexOf(' ')).trim())
//     .toList();
// return labels;
// }


Future<ClassifierModel> _loadModel(String modelFileName) async {
// #1
final interpreter = await Interpreter.fromAsset(modelFileName);

// #2
final inputShape = interpreter.getInputTensor(0).shape;
final outputShape = interpreter.getOutputTensor(0).shape;

// #3
final inputType = interpreter.getInputTensor(0).type;
final outputType = interpreter.getOutputTensor(0).type;


return ClassifierModel(
interpreter: interpreter,
inputShape: inputShape,
outputShape: outputShape,
inputType: inputType,
outputType: outputType,
);
}

TensorImage _preProcessInput(Image image) {
// #1
final inputTensor = TensorImage(_model.inputType);
inputTensor.loadImage(image);

// #2
final minLength = min(inputTensor.height, inputTensor.width);
final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

// #3
final shapeLength = _model.inputShape[1];
final resizeOp = ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);
// #4
final normalizeOp = NormalizeOp(127.5, 127.5);

// #5
final imageProcessor = ImageProcessorBuilder()
    .add(cropOp)
    .add(resizeOp)
    .add(normalizeOp)
    .build();

imageProcessor.process(inputTensor);

// #6
return inputTensor;
}