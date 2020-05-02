import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import 'level.dart';

enum LevelResult {
  won,
  failed,
  restarted,
}

class Tracking {
  static Amplitude analytics = Amplitude.getInstance(instanceName: "Turn me on Dev");

  static DateTime levelStarted;
  static void logLevelStarted() {
    levelStarted = new DateTime.now();
  }
  static void logLevelPlayed(LevelState levelState, LevelResult result) {
    DateTime levelEnded = new DateTime.now();

    analytics.logEvent("Level played", eventProperties: {
      "code": levelState.toggles,
      "number": levelState.model.currentlyPlayingLevel,
      "result": result.toString(),
      "allowedMoves": levelState.initialMoves,
      "isTutorial": levelState.isTutorial(),
      "remainingMoves": levelState.remainingMoves,
      "timeSpent": levelEnded.difference(levelStarted).inSeconds,
      "wonForFirstTime":  result == LevelResult.won && levelState.model.currentlyPlayingLevel == levelState.model.lastUnlockedLevel
    });
  }

  static void logPlayerIdentity(int lastUnlockedLevel, int currentlyPlayingLevel) {
    final Identify identify = Identify()
      ..set('lastUnlockedLevel', lastUnlockedLevel)
      ..set('currentlyPlayingLevel', currentlyPlayingLevel);
    analytics.identify(identify);
  }
}
