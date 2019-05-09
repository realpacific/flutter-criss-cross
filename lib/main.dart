import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_criss_cross/helper.dart';

import 'game_page.dart';

void main() => runApp(new MaterialApp(
      title: "XO",
      home: new LandingPage(),
    ));

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LandingPageState();
  }
}

class LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  var _colors = [
    Colors.red,
    Colors.indigo,
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.amber,
    Colors.red,
  ];
  int _indexColor = 0;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 800));
    _animation = new CurvedAnimation(
        parent: _animationController, curve: Curves.decelerate);
    _animation.addListener(() => this.setState(() => {}));
    _animation.addStatusListener((AnimationStatus status) {});

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
      color: _colors[_indexColor],
      child: new InkWell(
        splashColor: _colors[_indexColor + 1],
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new GameScreen())),
        onLongPress: () => this.setState(() {
              _animationController.reset();
              _animationController.forward();
              _indexColor++;
              if (_indexColor >= _colors.length - 1) _indexColor = 0;
            }),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(top: 200.0),
              child: new Transform.rotate(
                  angle: _indexColor % 2 == 0
                      ? _animation.value * 2 * Math.pi
                      : _animation.value * -2 * Math.pi,
                  child: buildText("XO", size: 120, fam: BOLD)),
            ),
            new Container(
                margin: new EdgeInsets.only(top: 30.0),
                child:
                    buildText("Press to start the game.", size: 14, fam: REG)),
            new Expanded(
                child: new Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: new Container(
                  margin: const EdgeInsets.only(bottom: 2.0),
                  child: buildText("by realpacific", size: 18, fam: REG)),
            ))
          ],
        ),
      ),
    );
  }
}
