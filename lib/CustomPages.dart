import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:turnmeon/tracking.dart';

import 'model.dart';

class CustomPages {
  static Widget getSharePage(BuildContext context, UnlockedLevelsModel model) {
    return Center(
      child: Column(
        children: <Widget>[
          Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Enjoying Turn Me On?",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
            child: Text("Please share with friends, or rate on the Play Store!"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                label: Text("Share"),
                color: Colors.deepPurple,
                textColor: Colors.white,
                icon: Icon(
                  Icons.share,
                  size: 30,
                ),
                onPressed: () {
                  Tracking.logShareEvent();
                  Share.share('Check out this simple logic game! https://play.google.com/store/apps/details?id=fr.neamar.turnmeon');
                },
              ),
              RaisedButton.icon(
                label: Text("Rate"),
                color: Colors.deepPurple,
                textColor: Colors.white,
                icon: Icon(
                  Icons.rate_review,
                  size: 30,
                ),
                onPressed: () {
                  Tracking.logRateEvent();
                  AppReview.requestReview.then((onValue) {
                    print(onValue);
                  });
                },
              ),
            ],
          ),
          Spacer(flex: 3),
          RaisedButton(
              child: Text("Back to game"),
              onPressed: () {
                Tracking.logSharePageDismissed();
                model.hideShareScreen();
              }),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
