import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';
import 'player_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'fetch_state.dart';

import 'con.dart';

typedef void OnError(Exception exception);

const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';

class OneSoundPage extends StatefulWidget {
  // final String title;
  // final String strUrlKey;
  const OneSoundPage({Key key, this.soundPath}) : super(key: key);

  final String soundPath;

  @override
  _OneSoundPageState createState() => _OneSoundPageState();
}

class _OneSoundPageState extends StateMVC<OneSoundPage> {
  _OneSoundPageState() : super(Con()) {
    con = controller;
  }
  Con con;

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  StreamController _soundController;

  String soundUrl = "";

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }

    _soundController = StreamController.broadcast();

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  Widget _remoteUrl(String soundUrl) {
    return SingleChildScrollView(
      child: _Tab(children: [
        Text(
          'Sample 1 ($kUrl1)',
          key: Key('url1'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: soundUrl),
      ]),
    );
  }

  /// 非同期で音を取得する
  Widget remoteUrlFuture() {
    return FutureBuilder(
      future: con.downLoadSound(widget.soundPath),
      builder: (context, snapshot) {
        // 非同期処理が完了している場合にWidgetの中身を呼び出す
        if (snapshot.hasData) {
          return _remoteUrl(snapshot.data);
          // 非同期処理が未完了の場合にインジケータを表示する
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<int> _getDuration() async {
    // File audiofile = await audioCache.load('audio2.mp3');
    // await advancedPlayer.setUrl(
    //   audiofile.path,
    // );
    int duration = await Future.delayed(
        Duration(seconds: 2), () => advancedPlayer.getDuration());
    return duration;
  }

  Widget notification() {
    return _Tab(children: [
      Text('Play notification sound: \'messenger.mp3\':'),
      _Btn(
          txt: 'Play',
          onPressed: () =>
              audioCache.play('messenger.mp3', isNotification: true)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              title: Text('audioplayers Example'),
            ),
            // body: TabBarView(
            //   children: [
            //     remoteUrl(),
            //     notification(),
            //     Advanced(
            //       advancedPlayer: advancedPlayer,
            //     )
            //   ],
            // ),
            body: remoteUrlFuture()),
      ),
    );
  }
}

class Advanced extends StatefulWidget {
  final AudioPlayer advancedPlayer;

  const Advanced({Key key, this.advancedPlayer}) : super(key: key);

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  bool seekDone;

  @override
  void initState() {
    widget.advancedPlayer.seekCompleteHandler =
        (finished) => setState(() => seekDone = finished);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
    return SingleChildScrollView(
      child: _Tab(
        children: [
          Column(children: [
            Text('Source Url'),
            Row(children: [
              _Btn(
                  txt: 'Audio 1',
                  onPressed: () => widget.advancedPlayer.setUrl(kUrl1)),
              _Btn(
                  txt: 'Audio 2',
                  onPressed: () => widget.advancedPlayer.setUrl(kUrl2)),
              _Btn(
                  txt: 'Stream',
                  onPressed: () => widget.advancedPlayer.setUrl(kUrl3)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Release Mode'),
            Row(children: [
              _Btn(
                  txt: 'STOP',
                  onPressed: () =>
                      widget.advancedPlayer.setReleaseMode(ReleaseMode.STOP)),
              _Btn(
                  txt: 'LOOP',
                  onPressed: () =>
                      widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP)),
              _Btn(
                  txt: 'RELEASE',
                  onPressed: () => widget.advancedPlayer
                      .setReleaseMode(ReleaseMode.RELEASE)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Volume'),
            Row(children: [
              _Btn(
                  txt: '0.0',
                  onPressed: () => widget.advancedPlayer.setVolume(0.0)),
              _Btn(
                  txt: '0.5',
                  onPressed: () => widget.advancedPlayer.setVolume(0.5)),
              _Btn(
                  txt: '1.0',
                  onPressed: () => widget.advancedPlayer.setVolume(1.0)),
              _Btn(
                  txt: '2.0',
                  onPressed: () => widget.advancedPlayer.setVolume(2.0)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Control'),
            Row(children: [
              _Btn(
                  txt: 'resume',
                  onPressed: () => widget.advancedPlayer.resume()),
              _Btn(
                  txt: 'pause', onPressed: () => widget.advancedPlayer.pause()),
              _Btn(txt: 'stop', onPressed: () => widget.advancedPlayer.stop()),
              _Btn(
                  txt: 'release',
                  onPressed: () => widget.advancedPlayer.release()),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Seek in milliseconds'),
            Row(children: [
              _Btn(
                  txt: '100ms',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 100));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '500ms',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 500));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '1s',
                  onPressed: () {
                    widget.advancedPlayer
                        .seek(Duration(seconds: audioPosition.inSeconds + 1));
                    setState(() => seekDone = false);
                  }),
              _Btn(
                  txt: '1.5s',
                  onPressed: () {
                    widget.advancedPlayer.seek(Duration(
                        milliseconds: audioPosition.inMilliseconds + 1500));
                    setState(() => seekDone = false);
                  }),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Rate'),
            Row(children: [
              _Btn(
                  txt: '0.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 0.5)),
              _Btn(
                  txt: '1.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.0)),
              _Btn(
                  txt: '1.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5)),
              _Btn(
                  txt: '2.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 2.0)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Text('Audio Position: ${audioPosition}'),
          seekDone == null
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : Text(seekDone ? "Seek Done" : "Seeking..."),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final List<Widget> children;

  const _Tab({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}
