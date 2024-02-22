import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
}

Future<String> uploadImage(String childName, Uint8List image) async {
  final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final Reference ref = _storage.ref().child(childName).child(fileName);
  final UploadTask uploadTask = ref.putData(image);
  TaskSnapshot snapshot = await uploadTask;
  return await snapshot.ref.getDownloadURL();
}

Future<void> saveImage(String _userId, Uint8List image) async {
  final String url = await uploadImage('profile_images', image);
  _firestore.collection('users').doc(_userId).update({'imageUrl': url});
}
