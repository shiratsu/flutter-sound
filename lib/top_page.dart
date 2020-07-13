import 'package:flutter/material.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert';
import 'dart:async';
import 'stream.dart';

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

  List<dynamic> listSounds = [];

  @override
  void initState() {
    super.initState();
    _itemsController = StreamController();
    _itemsController.add(Fetching());
    requestSoundList();
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
          child: StreamBuilder(
        stream: _itemsController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is Fetching) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data is Fetched) {
              // データ取得完了
              return _soundListBox(context);
            }
          }
        },
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /**
   * 音声一覧を表示
   */
  Widget _soundListBox(BuildContext context) {
    return listSounds == null
        ? Container()
        : ListView.builder(
            itemCount: listSounds.length,
            itemBuilder: (context, index) {
              return _buildSoundItem(index, context);
            },
            controller: _scrollController);
  }

  /**
   * 一覧の音のアイテム
   * 
   */
  Widget _buildSoundItem(int index, BuildContext context) {
    var sound = listSounds[index];

    return InkWell(
        onTap: () {
          Navigator.of(context).push<Widget>(
            MaterialPageRoute(
              builder: (context) {},
            ),
          );
        },
        child: Card(
          child: _makeEachRow(sound, context),
          margin: const EdgeInsets.all(1.0),
        ));
  }

  /**
   * 各行の音アイテム設定
   */
  Widget _makeEachRow(dynamic sound, BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50.0,
      child: Center(child: Text(sound['title'])),
    );
  }

  /**
   * 音源一覧を取得
   */
  Future<void> requestSoundList() async {
    print(DotEnv().env['SOUND_LIST_URL_BASE']);
    print(DotEnv().env['SOUND_LIST_URL']);
    String strListUrl =
        DotEnv().env['SOUND_LIST_URL_BASE'] + DotEnv().env['SOUND_LIST_URL'];

    http.Response response = await http.get(strListUrl);
    if (response.statusCode != 200) {
      print("失敗だよ〜〜＞＜");
      return;
    }

    print("通信できたよ〜〜");

    // APIから取得した求人データ
    listSounds = json.decode(response.body);

    _itemsController.add(Fetched());
  }
}
