import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnmeon/level_data.dart';

class UnlockedLevelsModel extends ChangeNotifier {
  static const SP_KEY = "last_unlocked_level";

  SharedPreferences _prefs;

  bool isLoading = true;
  int lastUnlockedLevel = -1;
  int currentlyPlayingLevel = -1;

  Future<int> _readStateFromDisk() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(SP_KEY)) {
      _prefs.setInt(SP_KEY, 0);
    }

    return _prefs.getInt(SP_KEY);
  }

  void _writeStateToDisk() async {
    await _prefs.setInt(SP_KEY, max(0, lastUnlockedLevel));
  }

  UnlockedLevelsModel() {
    _readStateFromDisk().then((lastUnlockedLevel) {
      this.isLoading = false;
      this.lastUnlockedLevel = lastUnlockedLevel;
      this.currentlyPlayingLevel = lastUnlockedLevel;
      print("Model loaded");
      this.notifyListeners();
    }).catchError((error) {
      print(error.toString());
    });
  }

  void notifyCurrentLevelWon() {
    if (currentlyPlayingLevel == lastUnlockedLevel) {
      // GG! You unlocked the next level
      print("Unlock next level");
      unlockNextLevel();
    }
  }

  bool canMoveToNextLevel() {
      return currentlyPlayingLevel < lastUnlockedLevel;
  }

  void moveToNextLevel() {
    print("Levels " + currentlyPlayingLevel.toString() + " unlocked:" + lastUnlockedLevel.toString());
    if(canMoveToNextLevel()) {
      currentlyPlayingLevel++;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    _writeStateToDisk();
    super.notifyListeners();
  }

  unlockNextLevel() {
    if(lastUnlockedLevel < LevelStore.levels.length - 1) {
      lastUnlockedLevel++;
    }
    notifyListeners();
  }
}
