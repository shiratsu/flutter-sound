import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:async';
import 'dart:io';
import '.env.dart' as env;

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() async {
  final FirebaseApp app = await myFirebaseApp();
  // final FirebaseStorage storage =
  //     FirebaseStorage(app: app, storageBucket: env.storageBucket);

  getIt.registerLazySingleton(
      () => FirebaseStorage(app: app, storageBucket: env.storageBucket));
}

Future<FirebaseApp> myFirebaseApp() {
  return FirebaseApp.configure(
    name: env.firebaseName,
    options: FirebaseOptions(
      appId: Platform.isIOS ? env.iosGoogleAppID : env.androidGoogleAppID,
      messagingSenderId: env.gcmSenderID,
      apiKey: env.apiKey,
      projectId: env.projectID,
    ),
  );
}
