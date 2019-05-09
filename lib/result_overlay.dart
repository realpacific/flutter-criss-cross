import 'package:flutter/material.dart';
import 'dart:math';

/// The Screen that is shown after a player wins or the game ends up in draw
class ResultOverlay extends StatefulWidget {
  final String _winner;
  final VoidCallback _onTap;

  ResultOverlay(this._winner, this._onTap);

  @override
  State<StatefulWidget> createState() {
    return new ResultOverlayState();
  }
}

class ResultOverlayState extends State<ResultOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _animation =
    new CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);
    _animation.addListener(() => this.setState(() => {}));
    _animationController.forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black87,
      child: new InkWell(
        onTap: () => widget._onTap(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(

                child: new Text(widget._winner, style: new TextStyle(
                    fontSize: _animation.value * 120.0,
                    color: Colors.white,
                    fontFamily: "OrbitronReg"),)
            ),
            new Container(
                child: new Text(widget._winner == 'XO' ? "draw" : "wins...",
                  style: new TextStyle(fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "OrbitronReg"),)
            ),
          ],
        ),
      ),
    );
  }
}