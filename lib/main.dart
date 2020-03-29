import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Turn me on"),
        ),
        body: Level('T↕TT∀T', '111001', 3),
      ),
    );
  }
}

class Level extends StatefulWidget {
  Level(this.toggles, this.initialState, this.allowedMoves);

  final String toggles;
  final String initialState;
  final int allowedMoves;

  @override
  _LevelState createState() => _LevelState(toggles, initialState, allowedMoves);
}

class _LevelState extends State<Level> {
  static const MaterialColor COLOR_GAME = Colors.deepPurple;
  static const MaterialColor COLOR_FAIL = Colors.red;
  static const MaterialColor COLOR_SUCCESS = Colors.green;

  static const String TOGGLE = 'T';
  static const String SWITCH_ALL = '∀';
  static const String SWITCH_AROUND = '↕';
  static const String SWITCH_EXTREMES = 'C';
  static const String SWITCH_NTH = 'N';

  final String toggles;
  final int _initialMoves;
  final String _initialState;

  int _remainingMoves;
  String _currentState;

  _LevelState(this.toggles, this._initialState, this._initialMoves) {
    this._currentState = _initialState;
    this._remainingMoves = _initialMoves;
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
      }
      _currentState = newState;
    });
  }

  void _reset() {
    setState(() {
      _currentState = _initialState;
      _remainingMoves = _initialMoves;
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
      return SWITCH_EXTREMES;
    }

    return '?';
  }

  @override
  Widget build(BuildContext context) {
    String textToDisplay = "moves remaining";
    if (_remainingMoves == 1) {
      textToDisplay = "move remaining";
    } else if (_remainingMoves == 0) {
      textToDisplay = "You've lost :(";
    }

    MaterialColor headerColor = _remainingMoves == 0 ? COLOR_FAIL : COLOR_GAME;

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
                  onChanged: _remainingMoves == 0
                      ? null
                      : (bool value) {
                          _pressToggle(index);
                        },
                );
              }))
    ]);
  }
}
