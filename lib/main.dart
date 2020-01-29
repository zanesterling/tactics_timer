import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boggle Board',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Boggle Board'),
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
  Duration _timeLeft = Duration(minutes: 3);
  Timer _timer;
  Widget _board;

  static String _renderDuration(Duration d) {
    if (d == Duration()) {
      return "0s";
    }
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
    _board = SizedBox(width: 400, height: 400);
    super.initState();
  }

  void resetTimer() {
    endTimer();
    startTimer();
  }

  void endTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        if (_timeLeft > Duration()) {
          _timeLeft -= Duration(seconds: 1);
        }
      });
    });
  }

  bool playing() {
    return _timer != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        child: InkWell(
          child: Center(
            child: Column(
              children: <Widget>[
                _board,
                SizedBox(height: 200),
                Text(
                  _renderDuration(_timeLeft),
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              resetTimer();
              _board = Board(key: UniqueKey());
              _timeLeft = Duration(minutes: 3);
            });
          },
        ),
        decoration: BoxDecoration(
          color: _timeLeft == Duration() ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  Board({Key key}) : super(key: key);

  void randomize() {
  }

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  static final DICE = [
    "RIFOBX",
    "IFEHEY",
    "DENOWS",
    "UTOKND",
    "HMSRAO",
    "LUPETS",
    "ACITOA",
    "YLGKUE",
    "QBMJOA",
    "EHISPN",
    "VETIGN",
    "BALIYT",
    "EZAVND",
    "RALESC",
    "UWILRG",
    "PACEMD",
  ];

  static List<Tuple2<String, int>> randomRoll() {
    final _random = new Random();
    var newDice = new List<Tuple2<String, int>>();
    for (var die in DICE) {
      var char = die[_random.nextInt(die.length)];
      String s = char == 'Q' ? 'Qu' : char.toString();
      newDice.add(Tuple2(s, _random.nextInt(4)));
    }
    newDice.shuffle();
    return newDice;
  }

  List<Tuple2<String, int>> _roll;

  void randomize() {
    _roll = randomRoll();
  }

  @override
  void initState() {
    _roll = randomRoll();
    super.initState();
  }

  // TODO: random orientations
  static Widget buildDie(BuildContext context, Tuple2<String, int> die) {
    final NS = ["N", "Z", "M", "W"];
    final char = die.item1;
    return Transform.rotate(
      angle: die.item2 * pi / 2,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Text(
            char,
            style: TextStyle(
              fontSize: 75,
              fontWeight: FontWeight.bold,
              decoration: NS.contains(char) ? TextDecoration.underline : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var builtDice = _roll.map((d) => buildDie(context, d)).toList();
    var makeRow = (d, i, j) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: d.sublist(i, j),
        );
    return Center(
        child: Column(
      children: [
        makeRow(builtDice, 0, 4),
        makeRow(builtDice, 4, 8),
        makeRow(builtDice, 8, 12),
        makeRow(builtDice, 12, 16),
      ],
    ));
  }
}
