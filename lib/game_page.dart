import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_criss_cross/helper.dart';

import 'result_overlay.dart';
import 'score_board.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //debugPaintSizeEnabled = true;
    return new GameScreenState();
  }
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  var _turn = 'O', _starter = 'O', _winner = '';
  var _moves = List(9);
  bool _showOverlay = false;
  int _winsX = 0, _winsO = 0, _total = 0, _cPlayed = 0, _count = 0;

  @override
  void initState() {
    super.initState();
    _clearBoard();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 200));
    _animation =
        new CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animation.addListener(() {
      this.setState(() {});
    });
    _animation.addStatusListener((AnimationStatus status) {});
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _setGameOver(String win) {
    this.setState(() {
      _winner = win;
      _showOverlay = true;
      if (_winner == 'X')
        _winsX++;
      else if (_winner == 'O') _winsO++;
      _total++;
    });
  }

  _clearBoard() {
    for (int i = 0; i < _moves.length; i++) _moves[i] = '';
  }

  _checkForWins(int i, int j, int k) =>
      _moves[i] == _moves[j] && _moves[j] == _moves[k] && _moves[j] != '';

  _checkHorizontal(int startIndex) =>
      _checkForWins(startIndex, startIndex + 1, startIndex + 2);

  _checkVertical(int startIndex) =>
      _checkForWins(startIndex, startIndex + 3, startIndex + 6);

  _checkDiagonal(int startIndex) => startIndex == 0
      ? _checkForWins(startIndex, startIndex + 4, startIndex + 8)
      : _checkForWins(startIndex, startIndex * 2, startIndex * 3);

  void _handleInputAndCheckForWinner(index) {
    _turn = (_cPlayed % 2 == 0)
        ? (_count % 2 == 0 ? 'O' : 'X')
        : (_count % 2 == 0 ? 'X' : 'O');
    if (_moves[index] == '') {
      _moves[index] = _turn;
      _count++;
    } else
      return;
    if (_count < 5) return;
    if (_checkHorizontal(0) ||
        _checkHorizontal(3) ||
        _checkHorizontal(6) ||
        _checkVertical(0) ||
        _checkVertical(1) ||
        _checkVertical(2) ||
        _checkDiagonal(0) ||
        _checkDiagonal(2))
      _setGameOver(_moves[index]);
    else if (_count == 9) _setGameOver('XO');
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.black,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Expanded(child: _buildGameBoard()),
                new Column(
                  children: <Widget>[
                    buildText('XO', size: 50),
                    new Container(
                      margin: new EdgeInsets.only(top: 20.0, bottom: 2.0),
                      child: buildText('SCORE BOARD', size: 12),
                    ),
                  ],
                ),
                _buildScoreBoard(),
              ],
            ),
            _showOverlay == true
                ? new ResultOverlay(_winner, () {
                    this.setState(() {
                      _resetGame();
                    });
                  })
                : new Container()
          ],
        ));
  }

  GridView _buildGameBoard() {
    return new GridView.count(
      crossAxisCount: 3,
      children: new List<Widget>.generate(9, (index) {
        return _buildGameTile(index);
      }),
    );
  }

  GridTile _buildGameTile(int index) {
    return new GridTile(
      child: new Container(
        margin: const EdgeInsets.all(1.0),
        child: new Material(
            color: Colors.blueAccent,
            child: new InkWell(
                onTap: () {
                  this.setState(() {
                    if (_moves[index] == '') {
                      _animationController.reset();
                      _animationController.forward();
                      _handleInputAndCheckForWinner(index);
                    }
                  });
                },
                splashColor: Colors.indigo,
                child: new Center(
                  child: buildText(_moves[index], size: 80, fam: BOLD),
                ))),
      ),
    );
  }

  Container _buildScoreBoard() {
    return new Container(
        decoration: new BoxDecoration(
          border: new Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: new Row(
          children: <Widget>[
            new ScoreBoard('Player X: ', ' Player O: ', 'Total: '),
            new ScoreBoard('$_winsX', '$_winsO', '$_total'),
            new Container(
              margin: new EdgeInsets.only(left: 50.0),
              child: new Column(
                children: <Widget>[
                  buildText('TURN', decor: TextDecoration.underline, size: 14),
                  buildText(_count == 0 ? _starter : (_turn == 'O' ? 'X' : 'O'),
                      size: 40.0 + _animation.value * 20.0, fam: REG),
                ],
              ),
            )
          ],
        ));
  }

  void _resetGame() {
    _starter = _starter == 'O' ? 'X' : 'O';
    _turn = _starter;
    _cPlayed++;
    _showOverlay = false;
    _count = 0;
    _clearBoard();
    _winner = '';
  }
}
