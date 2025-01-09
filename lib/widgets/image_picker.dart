import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CompletionImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image : $e');
    }
    return null;
  }
}
