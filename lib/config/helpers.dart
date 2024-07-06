import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

Future<String> imageToBase64String(XFile image) async {
  Uint8List imageBytes = await image.readAsBytes();
  String base64String = base64Encode(imageBytes);
  return base64String;
}

Uint8List base64StringToImage(String base64String) {
  Uint8List decodedBytes = base64Decode(base64String);
  return decodedBytes;
}
