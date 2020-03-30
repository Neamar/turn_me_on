import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnlockedLevelsModel extends ChangeNotifier {
  static const SP_KEY = "last_unlocked_level";

  SharedPreferences _prefs;

  bool isLoading = true;
  int lastUnlockedLevel = -1;
  int currentlyPlayingLevel = -1;

  Future<int> readStateFromDisk() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(SP_KEY)) {
      _prefs.setInt(SP_KEY, 0);
    }

    return _prefs.getInt(SP_KEY);;
  }

  void writeStateToDisk() async {
    await _prefs.setInt(SP_KEY, max(0, lastUnlockedLevel));
  }

  UnlockedLevelsModel() {
    readStateFromDisk().then((lastUnlockedLevel) {
      this.isLoading = false;
      this.lastUnlockedLevel = lastUnlockedLevel;
      this.currentlyPlayingLevel = lastUnlockedLevel;
      print("Model loaded");
      this.notifyListeners();
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void notifyListeners() {
    writeStateToDisk();
    super.notifyListeners();
  }

  unlockNextLevel() {
    lastUnlockedLevel++;
    notifyListeners();
  }
}