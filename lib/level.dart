import 'package:flutter/material.dart';

import 'model.dart';

class Level extends StatefulWidget {
  final String toggles;
  final String initialState;
  final int allowedMoves;
  final UnlockedLevelsModel model;

  Level(Key key, this.toggles, this.initialState, this.allowedMoves, this.model)
      : super(key: key);

  @override
  _LevelState createState() =>
      _LevelState(toggles, initialState, allowedMoves, model);
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

  final String toggles;
  final int _initialMoves;
  final String _initialState;
  final UnlockedLevelsModel model;

  int _remainingMoves;
  String _currentState;
  String gameState;

  _LevelState(
      this.toggles, this._initialState, this._initialMoves, this.model) {
    this._currentState = _initialState;
    this._remainingMoves = _initialMoves;
    gameState = STATE_PLAYING;
  }

  String _switch(String toggleState) {
    return toggleState == "0" ? "1" : "0";
  }

  String _switchToggleInState(int toggleIndex, String state) {
    return state.substring(0, toggleIndex) +
        _switch(state[toggleIndex]) +
        state.substring(toggleIndex + 1);
  }

  void _pressToggle(int toggleIndex) {
    setState(() {
      _remainingMoves--;
      String newState = _currentState;
      String toggleType = toggles[toggleIndex];
      if (toggleType == TOGGLE) {
        newState = _switchToggleInState(toggleIndex, newState);
      } else if (toggleType == SWITCH_ALL) {
        for (int i = 0; i < _currentState.length; i++) {
          newState = _switchToggleInState(i, newState);
        }
      } else if (toggleType == SWITCH_AROUND) {
        if (toggleIndex > 0) {
          newState = _switchToggleInState(toggleIndex - 1, newState);
        }
        newState = _switchToggleInState(toggleIndex, newState);
        if (toggleIndex < toggles.length - 1) {
          newState = _switchToggleInState(toggleIndex + 1, newState);
        }
      } else if(toggleType == SWITCH_EXTREMES) {
        newState = _switchToggleInState(0, newState);
        newState = _switchToggleInState(toggleIndex, newState);
        newState = _switchToggleInState(toggles.length - 1, newState);
      }
      else if(toggleType == SWITCH_NTH) {
        int enabledCount = "1".allMatches(_currentState).length;
        newState = _switchToggleInState(toggleIndex, newState);
        newState = _switchToggleInState(enabledCount, newState);
      }
      _currentState = newState;

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

  String _getTitle(String toggleType) {
    if (toggleType == TOGGLE) {
      return 'A simple switch';
    } else if (toggleType == SWITCH_ALL) {
      return 'Toggle all switches';
    } else if (toggleType == SWITCH_AROUND) {
      return 'Toggle me and both switches around me';
    } else if (toggleType == SWITCH_EXTREMES) {
      return 'Toggle me, and the first and last switches';
    } else if(toggleType == SWITCH_NTH) {
      return 'Toggle me and the n-th toggle (n is the number of active toggles)';
    }

    return 'An unknown toggle';
  }

  String _getSecondaryTitle(String toggleType) {
    if (toggleType == TOGGLE) {
      return ' ';
    } else if (toggleType == SWITCH_ALL) {
      return SWITCH_ALL;
    } else if (toggleType == SWITCH_AROUND) {
      return SWITCH_AROUND;
    } else if (toggleType == SWITCH_EXTREMES) {
      return 'Ω';
    } else if(toggleType == SWITCH_NTH) {
      return '∑';
    }

    return '?';
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
      textToDisplay = "You won!";
    }

    return Column(children: <Widget>[
      Material(
        color: headerColor[300],
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
                          fontSize: 50.0, // insert your font size here
                          color: headerColor[900]),
                    ),
                  ),
                  Text(textToDisplay),
                ],
              ),
            ),
            if (gameState == STATE_WON && model.canMoveToNextLevel())
              IconButton(
                icon: Icon(Icons.navigate_next,
                    color: headerColor[900],
                    semanticLabel: 'Move to next level'),
                onPressed: () {
                  model.moveToNextLevel();
                },
                iconSize: 50,
              ),
            if (gameState != STATE_WON)
              IconButton(
                icon: Icon(Icons.refresh,
                    color: headerColor[900], semanticLabel: 'Restart level'),
                onPressed: _reset,
                iconSize: 50,
              ),
          ]),
        ),
      ),
      Expanded(
          child: ListView.builder(
              itemCount: _currentState.length,
              itemBuilder: (BuildContext context, int index) {
                return SwitchListTile(
                  title: Text(_getTitle(toggles[index])),
                  value: _currentState[index] == "1",
                  secondary: Text(
                    _getSecondaryTitle(toggles[index]),
                    style: TextStyle(
                        fontSize: 20.0, // insert your font size here
                        color: Colors.deepPurple),
                  ),
                  onChanged: gameState != STATE_PLAYING
                      ? null
                      : (bool value) {
                          _pressToggle(index);
                        },
                );
              }))
    ]);
  }
}
