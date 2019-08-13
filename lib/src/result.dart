import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('hi'),
        Image.asset('assets/nation_flag_loading2.gif',width: 100,height: 100,),
//        Container(
//          child: Center(child: ChangeRaisedButtonColor()),
//        ),
      ],
    );
  }
}


class ChangeRaisedButtonColor extends StatefulWidget {
  @override
  ChangeRaisedButtonColorState createState() => ChangeRaisedButtonColorState();
}

class ChangeRaisedButtonColorState extends State<ChangeRaisedButtonColor>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTween;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _colorTween = ColorTween(begin: Colors.red, end: Colors.green)
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => RaisedButton(
        child: Text("Change my color"),
        color: _colorTween.value,
        onPressed: () {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        },
      ),
    );
  }
}