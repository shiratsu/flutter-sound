import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';

typedef void OnError(Exception exception);

const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';

class SoundPage extends StatefulWidget {
  SoundPage({FlutterKey.Key key, this.title, this.strUrlKey}) : super(key: key);

  final String title;
  final String strUrlKey;

  @override
  _SoundPageState createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  /// localのfileをロードする
  Future _loadFile() async {
    final bytes = await readBytes(kUrl1);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
      });
    }
  }

  /// Tracks the position while the user drags the seek bar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: Center(),
    );
  }
}
