import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async{
  //print (image.path);
  final String filename = image.path.split('/').last;

  Reference ref = storage.ref().child('images').child(filename);
  final UploadTask uploadTask = ref.putFile(image);
  //print(uploadTask);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  //print(snapshot);

  final String _url = await snapshot.ref.getDownloadURL();
  //print(url);
  
  return false;
}