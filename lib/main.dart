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
        body: Level(toggles: 'TTTT', initialState: '0010'),
      ),
    );
  }
}

class Level extends StatefulWidget {
  Level({Key key, this.toggles, this.initialState}) : super(key: key);

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
    return state.substring(0, toggleIndex) + _switch(state[toggleIndex]) + state.substring(toggleIndex + 1);
  }

  void _pressToggle(int toggleIndex) {
    setState(() {
      String newState = _currentState;
      String toggleType = toggles[toggleIndex];
      if (toggleType == TOGGLE) {
        newState = _switchToggleInState(toggleIndex, newState);
      }

      print("New States is " + newState);
      _currentState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _currentState.length,
        itemBuilder: (BuildContext context, int index) {
          return SwitchListTile(
            title: const Text('Toggle me'),
            onChanged: (bool value) {
              print("A toggle was pressed");
              _pressToggle(index);
            },
            value: _currentState[index] == "1",
          );
        });
  }
}
