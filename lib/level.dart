import 'dart:ui';

import 'package:flutter/material.dart';

import 'model.dart';

class Level extends StatefulWidget {
  final String toggles;
  final String initialState;
  final String tutorial;
  final int allowedMoves;
  final UnlockedLevelsModel model;

  Level(Key key, this.toggles, this.initialState, this.allowedMoves, this.tutorial, this.model) : super(key: key);

  @override
  _LevelState createState() => _LevelState(toggles, initialState, allowedMoves, tutorial, model);
}

class _LevelState extends State<Level> {
  static const MaterialColor COLOR_GAME = Colors.deepPurple;
  static const MaterialColor COLOR_FAIL = Colors.red;
  static const MaterialColor COLOR_SUCCESS = Colors.green;

  static const STATE_PLAYING = 'playing';
  static const STATE_FAILED = 'failed';
  static const STATE_WON = 'won';

  static const String TOGGLE = 'T';
  static const String SWITCH_ALL = '∀';
  static const String SWITCH_AROUND = '↕';
  static const String SWITCH_EXTREMES = 'C';
  static const String SWITCH_NTH = 'N';

  static const defaultAnimationDuration = Duration(milliseconds: 350);

  final String toggles;
  final int _initialMoves;
  final String _initialState;
  final String tutorial;
  final UnlockedLevelsModel model;

  int _remainingMoves;
  String _currentState;
  String gameState;

  AnimationController winAnimation;

  _LevelState(this.toggles, this._initialState, this._initialMoves, this.tutorial, this.model) {
    this._currentState = _initialState;
    this._remainingMoves = _initialMoves;
    gameState = STATE_PLAYING;
  }

  String _switch(String toggleState) {
    return toggleState == "0" ? "1" : "0";
  }

  String _switchToggleInState(int toggleIndex, String state) {
    return state.substring(0, toggleIndex) + _switch(state[toggleIndex]) + state.substring(toggleIndex + 1);
  }

  void _pressToggle(int toggleIndex) {
    setState(() {
      String newState = _currentState;
      String toggleType = toggles[toggleIndex];
      if (toggleType == TOGGLE) {
        newState = _switchToggleInState(toggleIndex, newState);
      } else if (toggleType == SWITCH_ALL) {
        print("Switching an all-toggle with state " + newState);
        for (int i = 0; i < _currentState.length; i++) {
          newState = _switchToggleInState(i, newState);
          print("Switched toggle at " + i.toString() + " and new state is now " + newState);
        }
        print("New state will be " + newState);
      } else if (toggleType == SWITCH_AROUND) {
        if (toggleIndex > 0) {
          newState = _switchToggleInState(toggleIndex - 1, newState);
        }
        newState = _switchToggleInState(toggleIndex, newState);
        if (toggleIndex < toggles.length - 1) {
          newState = _switchToggleInState(toggleIndex + 1, newState);
        }
      } else if (toggleType == SWITCH_EXTREMES) {
        newState = _switchToggleInState(0, newState);
        newState = _switchToggleInState(toggleIndex, newState);
        newState = _switchToggleInState(toggles.length - 1, newState);
      } else if (toggleType == SWITCH_NTH) {
        int enabledCount = "1".allMatches(_currentState).length;
        newState = _switchToggleInState(toggleIndex, newState);
        newState = _switchToggleInState(enabledCount, newState);
      }

      // Idempotent moves should not decrease your pool.
      if (_currentState != newState) {
        _currentState = newState;
        _remainingMoves--;
      }

      bool hasWon = !_currentState.contains("0");
      if (hasWon) {
        gameState = STATE_WON;
        model.notifyCurrentLevelWon();
      } else if (_remainingMoves == 0) {
        gameState = STATE_FAILED;
      }
    });
  }

  void _reset() {
    setState(() {
      _currentState = _initialState;
      _remainingMoves = _initialMoves;
      gameState = STATE_PLAYING;
    });
  }

  String _getTitle(String toggleType, int index, int totalToggles) {
    if (toggleType == TOGGLE) {
      return 'A simple switch';
    } else if (toggleType == SWITCH_ALL) {
      return 'Toggle all switches';
    } else if (toggleType == SWITCH_AROUND) {
      if (index == 0) {
        return 'Toggle me, and the switch below me';
      } else if (index == totalToggles - 1) {
        return 'Toggle me, and the switch above me';
      } else {
        return 'Toggle me, and both switches around me';
      }
    } else if (toggleType == SWITCH_EXTREMES) {
      return 'Toggle me, and the first and last switches';
    } else if (toggleType == SWITCH_NTH) {
      return 'Toggle me, and the n-th toggle';
    }

    return 'An unknown toggle';
  }

  Text getSubtitle(String toggleType) {
    if (toggleType == SWITCH_NTH) {
      return Text("(n is the number of active toggles)");
    }
    return null;
  }

  String _getSwitchIcon(String toggleType, int index, int totalToggles) {
    if (toggleType == TOGGLE) {
      return '·';
    } else if (toggleType == SWITCH_ALL) {
      return '∞';
    } else if (toggleType == SWITCH_AROUND) {
      if (index == 0) {
        return '↓';
      } else if (index == totalToggles - 1) {
        return '↑';
      } else {
        return SWITCH_AROUND;
      }
    } else if (toggleType == SWITCH_EXTREMES) {
      return 'Ω';
    } else if (toggleType == SWITCH_NTH) {
      return '∑';
    }

    return '?';
  }

  double _getIconSize(String toggleType) {
   if (toggleType == SWITCH_AROUND) {
      return 25;
    } else if (toggleType == SWITCH_NTH) {
      return 18;
    }

    return 20;
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor headerColor = COLOR_GAME;
    String textToDisplay = "moves remaining";
    if (_remainingMoves == 1) {
      textToDisplay = "move remaining";
    } else if (gameState == STATE_FAILED) {
      textToDisplay = "No moves remaining";
      headerColor = COLOR_FAIL;
    } else if (gameState == STATE_WON) {
      headerColor = COLOR_SUCCESS;
      if (model.canMoveToNextLevel()) {
        textToDisplay = "You won!";
      } else {
        textToDisplay = "YOU WON THE GAME. Congrats!";
      }
    }

    bool hasAtLeastOneSwitchNth = toggles.contains(SWITCH_NTH);
    int enabledCount = "1".allMatches(_currentState).length;

    return Column(children: <Widget>[
      AnimatedContainer(
        duration: defaultAnimationDuration,
        color: headerColor[300],
        curve: Curves.fastOutSlowIn,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if(gameState == STATE_WON && model.canMoveToNextLevel()) {
                model.moveToNextLevel();
              }
              else {
                _reset();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _remainingMoves > 0 ? _remainingMoves.toString() : '',
                          style: TextStyle(
                              fontSize: 50.0,
                              color: headerColor[900]),
                        ),
                      ),
                      Text(textToDisplay),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                    crossFadeState: gameState == STATE_WON && model.canMoveToNextLevel() ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: defaultAnimationDuration,
                    firstChild: Icon(Icons.navigate_next, color: headerColor[900], semanticLabel: 'Move to next level', size: 50),
                    secondChild: Icon(Icons.refresh, color: headerColor[900], semanticLabel: 'Restart level', size: 50)),
              ]),
            ),
          ),
        ),
      ),
      if (tutorial != null)
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.yellow[300],
          child: Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.help_outline,
                color: Colors.yellow[700],
                size: 30.0,
                semanticLabel: 'Help',
              ),
            ),
            Flexible(
              child: Text(tutorial),
            )
          ]),
        ),
      Expanded(
          child: ListView.builder(
              itemCount: _currentState.length,
              itemBuilder: (BuildContext context, int index) {
                return SwitchListTile(
                  title: Text(_getTitle(toggles[index], index, toggles.length)),
                  subtitle: getSubtitle(toggles[index]),
                  value: _currentState[index] == "1",
                  secondary: Container(
                    constraints: BoxConstraints(minWidth: 35, maxWidth: 35),
                    // secondary min width is 35 and we want to center our icon
                    child: Text(
                      _getSwitchIcon(toggles[index], index, toggles.length),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: _getIconSize(toggles[index]),
                          color: hasAtLeastOneSwitchNth && enabledCount == index ? Colors.deepPurple[900] : Colors.deepPurple[200]),
                    ),
                  ),
                  onChanged: gameState != STATE_PLAYING || (toggles[index] == SWITCH_NTH && enabledCount == index)
                      ? null
                      : (bool value) {
                          _pressToggle(index);
                        },
                );
              }))
    ]);
  }
}
