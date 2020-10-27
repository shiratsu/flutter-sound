import 'package:mvc_pattern/mvc_pattern.dart';

import 'model.dart';

class Con extends ControllerMVC {
  Con([StateMVC state]) : super(state) {
    m = Model();
  }

  Model m;

  /**
   * 音を取得
   */
  Future<String> downLoadSound(String objPath) async {
    return m.downLoadFile(objPath);
  }
}
