import 'package:flutter/material.dart';
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
            ),
            body: Consumer<UnlockedLevelsModel>(
              builder: (context, model, child) {
                if (model.isLoading) {
                  // SharedPreferences are not ready yet
                  return Center(child: CircularProgressIndicator());
                }

                return LevelStore.getLevel(model.currentlyPlayingLevel, () {
                  if(model.currentlyPlayingLevel == model.lastUnlockedLevel) {
                    // GG! You unlocked the next level
                    print("Unlock next level");
                    model.unlockNextLevel();
                  }
                });
              },
            )),
      ),
    );
  }
}