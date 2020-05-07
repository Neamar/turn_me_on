import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:turnmeon/tracking.dart';

import 'model.dart';

class Level extends StatefulWidget {
  final String toggles;
  final String initialState;
  final String tutorial;
  final int allowedMoves;
  final UnlockedLevelsModel model;

  Level(Key key, this.toggles, this.initialState, this.allowedMoves, this.tutorial, this.model) : super(key: key);

  @override
  LevelState createState() => LevelState(toggles, initialState, allowedMoves, tutorial, model);
}

class LevelState extends State<Level> {
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
  static const String SWITCH_ABOVE = '⇑';
  static const String SWITCH_INTRICATE = '%';
  static const String SWITCH_NTH = 'N';
  static const defaultAnimationDuration = Duration(milliseconds: 350);

  final String toggles;
  final int initialMoves;
  final UnlockedLevelsModel model;
  int remainingMoves;

  final String _initialState;
  final String _tutorial;

  String _currentState;
  String _gameState;

  bool textIsFlashing = false;

  LevelState(this.toggles, this._initialState, this.initialMoves, this._tutorial, this.model) {
    this._currentState = _initialState;
    this.remainingMoves = initialMoves;
    _gameState = STATE_PLAYING;
    Tracking.logLevelStarted();
  }

  String _switch(String toggleState) {
    return toggleState == "0" ? "1" : "0";
  }

  String _switchToggleInState(int toggleIndex, String state) {
    return state.substring(0, toggleIndex) + _switch(state[toggleIndex]) + state.substring(toggleIndex + 1);
  }

  String _setToggleInState(int toggleIndex, String value, String state) {
    return state.substring(0, toggleIndex) + value + state.substring(toggleIndex + 1);
  }

  bool isTutorial() {
    return _tutorial != null;
  }

  void _pressToggle(int toggleIndex) {
    setState(() {
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
      } else if (toggleType == SWITCH_EXTREMES) {
        newState = _switchToggleInState(0, newState);
        newState = _switchToggleInState(toggleIndex, newState);
        newState = _switchToggleInState(toggles.length - 1, newState);
      } else if (toggleType == SWITCH_ABOVE) {
        String value = _switch(_currentState[toggleIndex]);
        newState = (value * (toggleIndex + 1)) + _currentState.substring(toggleIndex + 1);
      } else if (toggleType == SWITCH_INTRICATE) {
        String toggledState = _switch(_currentState[toggleIndex]);
        for (int i = 0; i < _currentState.length; i++) {
          if (i == toggleIndex) {
            newState = _setToggleInState(i, toggledState, newState);
          } else if (toggles[i] == SWITCH_INTRICATE) {
            newState = _setToggleInState(i, _switch(toggledState), newState);
          }
        }
      } else if (toggleType == SWITCH_NTH) {
        int enabledCount = "1".allMatches(_currentState).length;
        newState = _switchToggleInState(toggleIndex, newState);
        if(enabledCount > 0) {
          newState = _switchToggleInState(enabledCount - 1, newState);
        }
      }

      // Idempotent moves should not decrease your pool.
      if (_currentState != newState) {
        _currentState = newState;
        remainingMoves--;
      }

      bool hasWon = !_currentState.contains("0");
      if (hasWon) {
        _gameState = STATE_WON;
        _flashText();
        Tracking.logLevelPlayed(this, LevelResult.won);
        model.notifyCurrentLevelWon();
      } else if (remainingMoves == 0) {
        _gameState = STATE_FAILED;
        _flashText();
      }
    });
  }

  void _reset() {
    setState(() {
      Tracking.logLevelPlayed(this, _gameState == STATE_FAILED ? LevelResult.failed : LevelResult.restarted);
      _currentState = _initialState;
      remainingMoves = initialMoves;
      _gameState = STATE_PLAYING;
      Tracking.logLevelStarted();
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
    } else if (toggleType == SWITCH_ABOVE) {
      return 'Toggle me, and set all switches above to my value';
    } else if (toggleType == SWITCH_INTRICATE) {
      return 'Toggle me, set opposite value on my twin';
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
    } else if (toggleType == SWITCH_ABOVE) {
      return SWITCH_ABOVE;
    } else if (toggleType == SWITCH_INTRICATE) {
      return '☯';
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

  void _flashText() {
    setState(() {
      textIsFlashing = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        textIsFlashing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor headerColor = COLOR_GAME;
    String textToDisplay = "moves remaining";
    if (remainingMoves == 1) {
      textToDisplay = "move remaining";
    } else if (_gameState == STATE_FAILED) {
      textToDisplay = "No moves remaining";
      headerColor = COLOR_FAIL;
    } else if (_gameState == STATE_WON) {
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
              if (_gameState == STATE_WON && model.canMoveToNextLevel()) {
                model.moveToNextTargetLevel();
              } else {
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
                          remainingMoves > 0 ? remainingMoves.toString() : '',
                          style: TextStyle(fontSize: 50.0, color: headerColor[900]),
                        ),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: new Duration(milliseconds: 200),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: textIsFlashing ? Theme.of(context).textTheme.bodyText1.fontSize + 4 : Theme.of(context).textTheme.bodyText1.fontSize),
                        child: Text(textToDisplay),
                      )
                    ],
                  ),
                ),
                AnimatedCrossFade(
                    crossFadeState: _gameState == STATE_WON && model.canMoveToNextLevel() ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: defaultAnimationDuration,
                    firstChild: Icon(Icons.navigate_next, color: headerColor[900], semanticLabel: 'Move to next level', size: 50),
                    secondChild: Icon(Icons.refresh, color: headerColor[900], semanticLabel: 'Restart level', size: 50)),
              ]),
            ),
          ),
        ),
      ),
      if (_tutorial != null)
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
              child: Text(_tutorial),
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
                          fontFamily: 'RobotoMono',
                          color: hasAtLeastOneSwitchNth && enabledCount == index + 1 ? Colors.deepPurple[900] : Colors.deepPurple[200]),
                    ),
                  ),
                  onChanged: _gameState == STATE_FAILED || (toggles[index] == SWITCH_NTH && enabledCount == index + 1)
                      ? null
                      : (bool value) {
                          // When state = WON, we want to keep the toggles enabled, but clicking them shouldn't do anything
                          if (_gameState == STATE_WON) {
                            _flashText();
                            return;
                          }
                          _pressToggle(index);
                        },
                );
              }))
    ]);
  }
}
