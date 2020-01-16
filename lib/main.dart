import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tactics Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Tactics Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Duration _timeLeft = Duration(minutes:2);
  Timer _timer;

  static String _renderDuration(Duration d) {
    if (d == Duration()) { return "0s"; }
    var components = [];
    var times = [d.inDays, d.inHours % 24, d.inMinutes % 60, d.inSeconds % 60];
    var suffixes = ["d", "h", "m", "s"];
    var anyFound = false;
    for (var pair in zip([times, suffixes])) {
      var t = pair[0];
      var s = pair[1];
      if (0 < t || anyFound) {
        components.add(t.toString() + s);
        anyFound = true;
      }
    }
    return components.join(" ");
  }

  @override
  void initState() {
    resetTimer();
    super.initState();
  }

  void resetTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds:1), (v) {
      setState(() {
        if (_timeLeft > Duration()) {
          _timeLeft -= Duration(seconds: 1);
        }
      });
    });
  }

  bool ding() {
    return _timeLeft == Duration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: InkWell(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _renderDuration(_timeLeft),
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              _timeLeft = Duration(minutes:2);
              resetTimer();
            });
          },
        ),
        decoration: BoxDecoration(
          color: ding() ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
