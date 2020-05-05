import 'package:flutter/cupertino.dart';

import 'level.dart';
import 'model.dart';

class LevelData {
  final String toggles;
  final String initialState;
  final int maxMoves;
  final String tutorial;
  final String title;

  const LevelData(this.toggles, this.initialState, this.maxMoves, {this.tutorial, this.title});
}

class LevelStore {
  static const List<LevelData> levels = [
    // Tutorial
    LevelData('T', '0', 1, tutorial: "To win, enable all switches.\nThis level should be easy.", title: "Tutorial"),
    // Switch All
    LevelData('TTT∀', '0000', 1, tutorial: "Some switches have special effects.\nFor this level, you're only allowed to switch one toggle—choose wisely.", title: "New switch: ∞"),
    LevelData('∀TT∀', '0110', 3),
    LevelData('T∀TT', '1011', 4),
    // Switch Around
    LevelData('T↕TT↕T', '000000', 2, title: "New switch: ↕"),
    LevelData('T↕↕↕T', '10001', 1, tutorial: "You only apply the effect of the switch you clicked on. There is no cascade effect!"),
    LevelData('T↕TT∀T', '111001', 3),
    LevelData('∀↕↕T', '1001', 2),
    LevelData('↕∀↕T∀', '10100', 4),
    LevelData('T↕TT∀T', '010101', 6),

    // Switch first and last
    LevelData('TCT', '000', 1, title: "New switch: Ω"),
    LevelData('∀↕CT', '0101', 2),
    LevelData('∀↕↕C↕', '10011', 2),
    LevelData('↕C∀∀C∀↕', '1000111', 5),
    LevelData('TT↕∀∀C↕', '0011011', 4),
    LevelData('↕↕∀↕↕∀', '000110', 3),

    // Switch above
    LevelData('TTT⇑T', '01000', 2, title:"New switch: ⇑"),
    LevelData('↕↕↕⇑C∀', '010000', 2),
    LevelData('∀⇑⇑∀', '1000', 3),
    LevelData('⇑⇑∀⇑∀T', '001001', 4),
    LevelData('∀⇑CT↕∀', '001010', 6),
    LevelData('↕⇑∀C↕T', '000011', 6),

    // Switch intricate
    LevelData("%C%T", "1000", 2, title: "New switch: ☯"),
    LevelData("↕%%", "101", 3),
    LevelData("%CT%T", "01000", 5),
    LevelData("∀%TTC%", "000001", 4),
    LevelData("↕%∀%T", "00011", 5),
    LevelData("↕∀C%%", "11001", 5),
    LevelData("%%↕↕↕", "00011", 5),
    LevelData("%%%↕T", "00110", 5),
    LevelData('%⇑%∀%', '10001', 5),
    LevelData("T∀%CT%", "100011", 6),
    LevelData("%⇑TT%", "01000", 5),

    // Switch "sum of"
    LevelData('T↕↕N', '0010', 2, title: "Final switch: ∑"),
    LevelData('∀↕↕CTN', '001000', 3, tutorial: "Notice the switch displayed in deep purple?\nIt indicates which toggle will be impacted by ∑."),
    LevelData('N∀∀', '100', 4),
    LevelData('↕N∀', '010', 4),
    LevelData('NC∀∀', '0011', 5),
    LevelData('↕↕N↕', '0101', 6, tutorial: "Only three levels left to finish the game!"),
    LevelData('T↕%⇑CN%∀', '01010111', 6),
    LevelData('T∀N∀∀∀', '001110', 11, title: "The final level"),
  ];

  static Level getLevel(int levelNumber, UnlockedLevelsModel model) {
    // Only display tutorial the first time you're playing the level, or if you're coming back right after winning.
    // After this, keep it hidden.
    bool shouldDisplayTutorial = levelNumber + 1 >= model.lastUnlockedLevel;

    LevelData data = levels[levelNumber];
    Key key = ValueKey(data.toggles + data.initialState);
    return Level(key, data.toggles, data.initialState, data.maxMoves, shouldDisplayTutorial ? data.tutorial : null, model);
  }

  static String getTitle(int levelNumber) {
    String title = levels[levelNumber].title;
    return title;
  }

  static String getTitleOrFallback(int levelNumber) {
    String title = getTitle(levelNumber);
    if(title != null) {
      return title;
    }
    else {
      return 'Level #' + levelNumber.toString();
    }
  }
}
