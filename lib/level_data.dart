import 'package:flutter/cupertino.dart';

import 'level.dart';
import 'model.dart';

class LevelData {
  final String toggles;
  final String initialState;
  final int maxMoves;

  const LevelData(this.toggles, this.initialState, this.maxMoves);
}

class LevelStore {
  static const List<LevelData> levels = [
    LevelData('T', '0', 1),
    LevelData('TTT∀', '0000', 1),
    LevelData('∀TT∀', '0110', 3),
    LevelData('T∀TT', '1011', 4),
    LevelData('T↕TT↕T', '000000', 2),
    LevelData('T↕↕↕T', '10001', 1),
    LevelData('T↕TT∀T', '111001', 3),
    LevelData('∀↕↕T', '1001', 2),
    LevelData('↕∀↕T∀', '10100', 4),
    LevelData('T↕TT∀T', '010101', 6),
    LevelData('TCT', '000', 1),
    LevelData('∀↕CT', '0101', 2),
    LevelData('∀↕↕C↕', '10011', 2),
    LevelData('↕C∀∀C∀↕', '1000111', 5),
    LevelData('TT↕∀∀C↕', '0011011', 4),
    LevelData('↕↕∀↕↕∀', '000110', 3),
    LevelData('T↕↕N', '0010', 2),
    LevelData('∀↕↕CTN', '001000', 3),
    LevelData('NC∀∀', '0011', 5),
    LevelData('↕↕N↕', '0101', 6),
    LevelData('T∀N∀∀∀', '001110', 11),
  ];

  static Level getLevel(int levelNumber, UnlockedLevelsModel model) {
    LevelData data = levels[levelNumber];
    Key key = ValueKey(data.toggles + data.initialState);
    return Level(key, data.toggles, data.initialState, data.maxMoves, model);
  }
}