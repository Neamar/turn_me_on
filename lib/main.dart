import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:turnmeon/level_data.dart';
import 'package:turnmeon/tracking.dart';

import 'CustomPages.dart';
import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Tracking.init();
  runApp(TurnMeOnApp());
}

class TurnMeOnApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turn me on',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ChangeNotifierProvider<UnlockedLevelsModel>(
          create: (context) => UnlockedLevelsModel(),
          child: Consumer<UnlockedLevelsModel>(builder: (context, model, child) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Turn me on"),
                  actions: <Widget>[
                    // Only display the reset button after level 3
                    if (model.lastUnlockedLevel > 3)
                      ResetButton(model),
                    if (model.lastUnlockedLevel >= 10)
                      FastScrollButton(model),
                  ],
                ),
                body: model.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PageView.builder(
                        controller: model.controller,
                        itemBuilder: (context, position) {
                          if (position == model.levelToDisplayShareScreenOn &&
                              model.lastUnlockedLevel == model.levelToDisplayShareScreenOn &&
                              !model.hasDisplayedShareScren) {
                            return CustomPages.getSharePage(context, model);
                          }

                          return LevelStore.getLevel(position, model);
                        },
                        itemCount: model.lastUnlockedLevel + 1, // +1 since level starts at 0
                      ),
                bottomNavigationBar: model.isLoading
                    ? null
                    : Material(
                        elevation: 8,
                        child: Row(children: <Widget>[
                          IconButton(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              icon: Icon(Icons.navigate_before),
                              tooltip: "Move to previous level",
                              onPressed: model.canMoveToPreviousLevel()
                                  ? () {
                                      model.moveToPreviousTargetLevel();
                                    }
                                  : null),
                          Expanded(
                              child: Text(
                            LevelStore.getTitleOrFallback(model.currentlyPlayingLevel),
                            textAlign: TextAlign.center,
                          )),
                          IconButton(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              icon: Icon(Icons.navigate_next),
                              tooltip: "Move to next level",
                              onPressed: model.canMoveToNextLevel()
                                  ? () {
                                      model.moveToNextTargetLevel();
                                    }
                                  : null),
                        ]),
                      ));
          })),
    );
  }
}

class ResetButton extends StatelessWidget {
  final UnlockedLevelsModel model;

  const ResetButton(this.model);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Reset all progress"),
              content: new Text("This will clear all your progress. You'll need to finish again each level to get back to your current level."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Reset"),
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "All progress reset.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );

                    model.reset();
                    Navigator.of(context).pop();
                  },
                  onLongPress: () {
                    Fluttertoast.showToast(
                      msg: "All progress unlocked, you little cheater!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );

                    model.unlockAll();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class FastScrollButton extends StatelessWidget {
  final UnlockedLevelsModel model;

  const FastScrollButton(this.model);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.history),
      onSelected: (int item) {
        model.setTargetLevel(item);
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem<int>> items = [];
        for (int i = 0; i <= model.lastUnlockedLevel; i++) {
          if (LevelStore.getTitle(i) != null) {
            items.add(PopupMenuItem<int>(value: i, child: Text(LevelStore.getTitle(i))));
          }
        }

        return items;
      },
    );
  }
}
