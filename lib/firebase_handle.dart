import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:async';
import 'dart:io';
import '.env.dart' as env;

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() async {
  print(Firebase.apps);

  final FirebaseApp app = await myFirebaseApp();
  final FirebaseStorage storage =
      FirebaseStorage(app: app, storageBucket: env.storageBucket);

  // print(Firebase.apps);

  getIt.registerLazySingleton(() => storage);
}

Future<FirebaseApp> myFirebaseApp() async {
  print(Firebase.apps);

  // if (Firebase.app(env.firebaseName) != null) {
  //   return Firebase.app(env.firebaseName);
  //
  var app;

  try {
    app = await Firebase.initializeApp(
      name: env.firebaseName,
      options: FirebaseOptions(
        appId: Platform.isIOS ? env.iosGoogleAppID : env.androidGoogleAppID,
        messagingSenderId: env.gcmSenderID,
        apiKey: env.apiKey,
        projectId: env.projectID,
      ),
    );
  } catch (e) {
    print(e);
    app = Firebase.app(env.firebaseName);
  }
  return app;
}
