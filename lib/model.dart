import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sound_app/firebase_handle.dart';

class Model {
  FirebaseStorage storage;

  Model() {
    storage = getIt<FirebaseStorage>();
  }

  /// firebaseからDLする
  Future<String> downLoadFile(String objPath) async {
    // download path
    StorageReference ref = storage.ref().child('sound/$objPath');
    final String url = await ref.getDownloadURL();
    return url;
  }
}
