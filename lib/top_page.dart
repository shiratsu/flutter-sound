import 'package:flutter/material.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'dart:async';
import 'stream.dart';
import 'one_sound_page.dart';
import 'config/sound_define.dart';

class TopPage extends StatefulWidget {
  TopPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  StreamController _itemsController;
  ScrollController _scrollController = new ScrollController();

  List<Map<String, String>> soundList = [
    {
      "title": "hogehoge",
      "imagePath": "assets/image002.png",
      "soundPath": "sound/brainrelax.mp3",
    },
    {
      "title": "hogehoge",
      "imagePath": "assets/image003.png",
      "soundPath": "sound-with-p/brainrelax.mp3",
    }
  ];

  @override
  void initState() {
    super.initState();
    // _itemsController = StreamController();
    // _itemsController.add(Fetching());
    // // requestSoundList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: _soundListBox(context)),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /**
   * 音声一覧を表示
   */
  Widget _soundListBox(BuildContext context) {
    return soundList == null
        ? Container(
            color: Color(0xFF010101),
          )
        : GridView.count(crossAxisCount: 2, children: _makeSoundsWidget());
  }

  /// 一覧を作成
  List<Widget> _makeSoundsWidget() {
    List<Widget> listWidgets = [];
    for (var i = 0; i < soundList.length; i++) {
      listWidgets.add(_soundWidget(soundList[i]["imagePath"],
          soundList[i]["title"], soundList[i]["soundPath"]));
    }
    return listWidgets;
  }

  /// 一個一個のwidget
  Widget _soundWidget(String strImagePath, String strTitle, String soundPath) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push<Widget>(
            MaterialPageRoute(
              settings: RouteSettings(name: 'OneSoundPage'), // webページ
              builder: (context) {
                return OneSoundPage(
                  soundPath: soundPath,
                  title: strTitle,
                );
              },
            ),
          );
        },
        child: Container(
          // width: 100,
          color: Color(0xFF010101),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                strImagePath,
                height: 150,
              ),
              Text(strTitle)
            ],
          ),
        ));
  }
}
