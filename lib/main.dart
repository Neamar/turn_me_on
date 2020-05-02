import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:turnmeon/level_data.dart';
import 'package:turnmeon/tracking.dart';

import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Tracking.analytics.init("f3f5aa45784b01e4782cc98c605d43c4");
  Tracking.analytics.enableCoppaControl();
  Tracking.analytics.trackingSessionEvents(true);
  runApp(TurnMeOnApp());
}

class TurnMeOnApp extends StatelessWidget {
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
            actions: <Widget>[const ResetButton()],
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
                              model.moveToPreviousLevel();
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
                              model.moveToNextLevel();
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
