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
        body: Level(toggles: 'TTT∀', initialState: '0000'),
      ),
    );
  }
}

class Level extends StatefulWidget {
  Level({Key key, this.toggles, this.initialState}) : super(key: key);

  final String toggles;
  final String initialState;

  @override
  _LevelState createState() => _LevelState(initialState);
}

class _LevelState extends State<Level> {
  String _currentState;
  String _initialState;

  _LevelState(String initialState) {
    this._currentState = initialState;
    this._initialState = initialState;
  }

  void _pressToggle(int index) {
    setState(() {
      // current_state[index] = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C', 'D'];
    final List<int> colorCodes = <int>[600, 500, 400, 100];

    return ListView.builder(
        itemCount: _currentState.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 70,
            color: Colors.deepPurple[colorCodes[index]],
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        }
    );
  }
}