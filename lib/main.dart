import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:turnmeon/level_data.dart';
import 'package:turnmeon/tracking.dart';

import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Tracking.analytics.init(kReleaseMode ? "1f39eabedbcc6c75a33904d60e2414ad" : "f3f5aa45784b01e4782cc98c605d43c4");
  Tracking.analytics.enableCoppaControl();
  Tracking.analytics.trackingSessionEvents(true);
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
        child: Scaffold(
          appBar: AppBar(
            title: Text("Turn me on"),
            actions: <Widget>[
              Consumer<UnlockedLevelsModel>(builder: (context, model, child) {
                // Only display the reset button after level 3
                if(model.lastUnlockedLevel > 3) {
                  return ResetButton(model);
                }

                // Return nothing otherwise
                return SizedBox.shrink();
              }),
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
              return Material(
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
                    model.currentlyPlayingLevel == 0 ? 'Tutorial' : 'Level #' + model.currentlyPlayingLevel.toString(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  final UnlockedLevelsModel model;
  const ResetButton(UnlockedLevelsModel this.model);

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
                  child: new Text("Close"),
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
