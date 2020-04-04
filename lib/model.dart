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
  PageController controller;

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

      // Controller to be used on our PageView
      controller = PageController(initialPage: currentlyPlayingLevel, keepPage: false);
      controller.addListener(() {
        if(controller.page.roundToDouble() != currentlyPlayingLevel) {
          loadLevel(controller.page.round());
        }
      });

      this.notifyListeners();
    }).catchError((error) {
      print(error.toString());
    });

  }

  void reset() {
    currentlyPlayingLevel = 0;
    lastUnlockedLevel = 0;
    notifyListeners();
  }

  void notifyCurrentLevelWon() {
    if (currentlyPlayingLevel == lastUnlockedLevel) {
      // GG! You unlocked the next level
      print("Unlock next level");
      unlockNextLevel();
    }
  }

  bool canMoveToNextLevel() {
      return !isLoading && currentlyPlayingLevel < lastUnlockedLevel;
  }

  void moveToNextLevel() {
    if(canMoveToNextLevel()) {
      controller.animateToPage(currentlyPlayingLevel + 1, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  bool canMoveToPreviousLevel() {
    return !isLoading && currentlyPlayingLevel > 0;
  }

  void moveToPreviousLevel() {
    if(canMoveToPreviousLevel()) {
      controller.animateToPage(currentlyPlayingLevel - 1, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void loadLevel(int level) {
    if(level <0 || level >= LevelStore.levels.length) {
      throw("Level value is out of bounds");
    }

    currentlyPlayingLevel = level;
    notifyListeners();
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
