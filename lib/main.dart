import 'package:flutter/material.dart';
import 'top_page.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:gcloud/db.dart';
import 'package:gcloud/storage.dart';
import 'package:gcloud/pubsub.dart';
import 'package:gcloud/service_scope.dart' as ss;
import 'package:gcloud/src/datastore_impl.dart' as datastore_impl;

String strCustomUserAgent = '';
var client;

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initUserAgentState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TopPage(title: '音源一覧'),
    );
  }

  void _loginGcloud() async {
    // Read the service account credentials from the file.
    var jsonCredentials = new File('hiratsuka-gcp.json').readAsStringSync();
    var credentials =
        new auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    // Get an HTTP authenticated client using the service account credentials.
    var scopes = []
      ..addAll(datastore_impl.DatastoreImpl.SCOPES)
      ..addAll(Storage.SCOPES)
      ..addAll(PubSub.SCOPES);
    client = await auth.clientViaServiceAccount(credentials, scopes);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initUserAgentState() async {
    String userAgent, webViewUserAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      strCustomUserAgent =
          strCustomUserAgent + " PrivateSoundApp Smp Application";
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent;
      strCustomUserAgent =
          webViewUserAgent + " PrivateSoundApp Smp Application";
      print('''
applicationVersion => ${FlutterUserAgent.getProperty('applicationVersion')}
systemName         => ${FlutterUserAgent.getProperty('systemName')}
userAgent          => $userAgent
webViewUserAgent   => $webViewUserAgent
packageUserAgent   => ${FlutterUserAgent.getProperty('packageUserAgent')}
      ''');
      // print("test");
      setState(() {});
    } on PlatformException {
      userAgent = webViewUserAgent = '<error>';
    }

    return;
  }
}
