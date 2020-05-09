import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:flutter/foundation.dart' show kReleaseMode, kIsWeb;

import 'level.dart';

enum LevelResult {
  won,
  failed,
  restarted,
}

class Tracking {
  static Amplitude analytics = Amplitude.getInstance(instanceName: "Turn me on Dev");

  static init() {
    if(!kIsWeb) {
      analytics.init(kReleaseMode ? "1f39eabedbcc6c75a33904d60e2414ad" : "f3f5aa45784b01e4782cc98c605d43c4");
      analytics.enableCoppaControl();
      analytics.trackingSessionEvents(true);
    }
  }
  static DateTime levelStarted;
  static void logLevelStarted() {
    levelStarted = new DateTime.now();
  }

  static void logLevelPlayed(LevelState levelState, LevelResult result) {
    if(kIsWeb) {
      return;
    }

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

  static void logSharePageDismissed() {
    if(kIsWeb) {
      return;
    }

    analytics.logEvent("Share page dismissed");
  }

  static void logShareEvent() {
    if(kIsWeb) {
      return;
    }

    analytics.logEvent("Share button clicked");
  }

  static void logRateEvent() {
    if(kIsWeb) {
      return;
    }

    analytics.logEvent("Rate button clicked");
  }

  static void logPlayerIdentity(int lastUnlockedLevel, int currentlyPlayingLevel) {
    if(kIsWeb) {
      return;
    }

    final Identify identify = Identify()
      ..set('lastUnlockedLevel', lastUnlockedLevel)
      ..set('currentlyPlayingLevel', currentlyPlayingLevel);
    analytics.identify(identify);
  }
}
