import 'package:flutter/material.dart';
import 'package:flutter_criss_cross/helper.dart';

class ScoreBoard extends StatefulWidget {
  final String _playerXScore;
  final String _playerYScore;
  final String _totalGamePlays;

  ScoreBoard(this._playerXScore, this._playerYScore, this._totalGamePlays);

  @override
  State<StatefulWidget> createState() {
    return new ScoreBoardState();
  }
}

class ScoreBoardState extends State<ScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildText(widget._playerXScore),
          buildText(widget._playerYScore),
          buildText(widget._totalGamePlays),
        ],
      ),
    );
  }
}
