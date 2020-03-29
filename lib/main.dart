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
        body: Level('T↕TT∀T', '111001'),
      ),
    );
  }
}

class Level extends StatefulWidget {
  Level(this.toggles, this.initialState);

  final String toggles;
  final String initialState;

  @override
  _LevelState createState() => _LevelState(toggles, initialState);
}

class _LevelState extends State<Level> {
  static const String TOGGLE = 'T';
  static const String SWITCH_ALL = '∀';
  static const String SWITCH_AROUND = '↕';
  static const String SWITCH_EXTREMES = 'C';
  static const String SWITCH_NTH = 'N';

  final String toggles;
  String _currentState;
  String _initialState;

  _LevelState(String this.toggles, String initialState) {
    this._currentState = initialState;
    this._initialState = initialState;
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
      String newState = _currentState;
      String toggleType = toggles[toggleIndex];
      if (toggleType == TOGGLE) {
        newState = _switchToggleInState(toggleIndex, newState);
      } else if (toggleType == SWITCH_ALL) {
        for(int i = 0; i < _currentState.length; i++) {
          newState = _switchToggleInState(i, newState);
        }
      }
      else if(toggleType == SWITCH_AROUND) {
        if(toggleIndex > 0) {
          newState = _switchToggleInState(toggleIndex - 1, newState);
        }
        newState = _switchToggleInState(toggleIndex, newState);
        if(toggleIndex < toggles.length - 1) {
          newState = _switchToggleInState(toggleIndex + 1,newState);
        }
      }
      print("New States is " + newState);
      _currentState = newState;
    });
  }
  
  String getTitle(String toggleType) {
    if(toggleType == TOGGLE) {
      return 'A simple switch';
    }
    else if(toggleType == SWITCH_ALL) {
      return 'Toggle all switches';
    }
    else if(toggleType == SWITCH_AROUND) {
      return 'Toggle me and both switches around me';
    }
    else if(toggleType == SWITCH_EXTREMES) {
      return 'Toggle me, and the first and last switches';
    }

    return 'An unknown toggle';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _currentState.length,
        itemBuilder: (BuildContext context, int index) {
          return SwitchListTile(
            title: Text(getTitle(toggles[index])),
            onChanged: (bool value) {
              print("A toggle was pressed");
              _pressToggle(index);
            },
            value: _currentState[index] == "1",
          );
        });
  }
}
