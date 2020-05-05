import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnmeon/level_data.dart';
import 'package:turnmeon/tracking.dart';

class UnlockedLevelsModel extends ChangeNotifier {
  static const SP_KEY = "last_unlocked_level";

  SharedPreferences _prefs;

  // When loading data form disk, this'll be set to true
  bool isLoading = true;
  // Max unlocked level for now
  int lastUnlockedLevel = -1;
  // Level we're playing
  int currentlyPlayingLevel = -1;
  // Level we want to reach (when furiously typing on previous / next buttons, we keep a buffer of number of times button was clicked to move fast)
  int targetLevel = -1;

  bool hasDisplayedShareScren = false;
  final int levelToDisplayShareScreenOn = 20;

  // When the last button Next / Previous was pressed (useful to distinguish between automatic scrolls and manual scrolls)
  DateTime lastSlideOrder = DateTime.now();
  // Duration of our animations
  final Duration slideDuration = Duration(milliseconds: 500);

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
      this.targetLevel = lastUnlockedLevel;

      // If your current level is the one where we usually display the share screen, do not display again.
      if(this.lastUnlockedLevel == levelToDisplayShareScreenOn) {
        hasDisplayedShareScren = true;
      }

      print("Model loaded");

      // Controller to be used on our PageView
      controller = PageController(initialPage: currentlyPlayingLevel, keepPage: false);
      controller.addListener(() {
        if (controller.page.roundToDouble() != currentlyPlayingLevel) {
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
    targetLevel = 0;
    controller.animateToPage(targetLevel, duration: slideDuration, curve: Curves.ease);
    notifyListeners();
  }

  void unlockAll() {
    lastUnlockedLevel = LevelStore.levels.length - 1;
    currentlyPlayingLevel = lastUnlockedLevel;
    targetLevel = currentlyPlayingLevel;
    controller.animateToPage(targetLevel, duration: slideDuration, curve: Curves.ease);
    notifyListeners();
  }

  void hideShareScreen() {
    hasDisplayedShareScren = true;
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

  /// Move potentially more than one level at a time (calls can stack)
  void moveToNextTargetLevel() {
    if(!isLoading && targetLevel < lastUnlockedLevel) {
      lastSlideOrder = DateTime.now();
      targetLevel++;
      controller.animateToPage(targetLevel, duration: slideDuration, curve: Curves.ease);
    }
  }

  bool canMoveToPreviousLevel() {
    return !isLoading && currentlyPlayingLevel > 0;
  }

  void moveToPreviousTargetLevel() {
    if(!isLoading && targetLevel > 0) {
      lastSlideOrder = DateTime.now();
      targetLevel--;
      controller.animateToPage(targetLevel, duration: slideDuration, curve: Curves.ease);
    }
  }

  void setTargetLevel(int level) {
    if(!isLoading && level > 0 && level <= lastUnlockedLevel) {
      lastSlideOrder = DateTime.now();
      targetLevel = level;
      controller.jumpToPage(targetLevel);
    }
  }

  void loadLevel(int level) {
    if (level < 0 || level >= LevelStore.levels.length) {
      throw ("Level value is out of bounds");
    }

    currentlyPlayingLevel = level;
    if(DateTime.now().difference(lastSlideOrder) > slideDuration) {
      targetLevel = level;
    }
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _writeStateToDisk();
    Tracking.logPlayerIdentity(lastUnlockedLevel, currentlyPlayingLevel);
    super.notifyListeners();
  }

  unlockNextLevel() {
    if (lastUnlockedLevel < LevelStore.levels.length - 1) {
      lastUnlockedLevel++;
    }
    notifyListeners();
  }
}
