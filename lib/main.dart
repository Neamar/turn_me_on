import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:turnmeon/level_data.dart';

import 'model.dart';

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
      home: ChangeNotifierProvider<UnlockedLevelsModel>(
        create: (context) => UnlockedLevelsModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Turn me on"),
            actions: <Widget>[
              const ResetButton()
            ],
          ),
          body: Consumer<UnlockedLevelsModel>(
            builder: (context, model, child) {
              if (model.isLoading) {
                // SharedPreferences are not ready yet
                return Center(child: CircularProgressIndicator());
              }

              return PageView.builder(
                controller: model.controller,
                itemBuilder: (context, position) {
                  return LevelStore.getLevel(position, model);
                },
                itemCount: model.lastUnlockedLevel + 1, // +1 since level starts at 0
              );
            },
          ),
          bottomNavigationBar: Consumer<UnlockedLevelsModel>(
            builder: (context, model, child) {
              return BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  if(!model.canMoveToPreviousLevel())  BottomNavigationBarItem(
                    icon: Icon(Icons.help),
                    title: Text('Get help'),
                  ),
                  if (model.canMoveToPreviousLevel())
                    BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_before),
                      title: Text('Previous level'),
                    ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Level #' +
                        (model.currentlyPlayingLevel + 1).toString()),
                  ),
                  if (model.canMoveToNextLevel())
                    BottomNavigationBarItem(
                      icon: Icon(Icons.navigate_next),
                      title: Text('Next level'),
                    ),
                ],
                currentIndex: 1,
                selectedItemColor: Colors.purple[800],
                onTap: (int index) {
                  if (index == 0 && model.canMoveToPreviousLevel()) {
                    model.moveToPreviousLevel();
                  }
                  else if (index == 0 && !model.canMoveToPreviousLevel()) {
                    Fluttertoast.showToast(
                        msg: "You win each level by enabling all switches within the specified amount of moves.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                    );
                  }
                  else if (((index == 1 && !model.canMoveToPreviousLevel()) ||
                          (index == 2)) &&
                      model.canMoveToNextLevel()) {
                    model.moveToNextLevel();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      onPressed: () {
        Fluttertoast.showToast(
          msg: "All progress reset.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Provider.of<UnlockedLevelsModel>(context, listen: false).reset();
      },
    );
  }
}