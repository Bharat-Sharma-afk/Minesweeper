import 'package:flutter/material.dart';
import './tilegrid.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  @override
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int size = 10;
  int sizex = 10;
  int sizey = 10;
  int mines = 10;
  var board, tileGrid;
  var ctext, tilesRem;

  gameEndDialog(type) {
    showDialog<String>(
      context: ctext,
      barrierDismissible: false,
      builder: (BuildContext ctext) => AlertDialog(
        title: type ? const Text('Hurray') : const Text('Game Over'),
        content: type
            ? const Text('You Won the Game!!!')
            : const Text('You Lost the Game!!!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(ctext, 'OK');
              newgame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    newgame();
    super.initState();
  }

  var _flagging = 0;
  ChangeFlagging() {
    setState(() {
      _flagging += 1;
      _flagging = (_flagging % 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    ctext = context;
    return Material(
        child: Container(
            color: Colors.black38,
            child: Column(children: [
              Spacer(),
              Container(
                  child: const Text(
                "Minesweeper",
                style: TextStyle(
                    fontFamily: "Cursive", color: Colors.black, fontSize: 50),
              )),
              const Spacer(),
              Container(
                  child: Row(children: [
                const Spacer(),
                const Text("Mines: 10"),
                Spacer(),
                ElevatedButton(
                  onPressed: ChangeFlagging,
                  child: (_flagging == 1)
                      ? Image.asset(
                          "images/flag.ico",
                          height: 50,
                          width: 50,
                        )
                      : Image.asset(
                          "images/mine.ico",
                          height: 50,
                          width: 50,
                        ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), primary: Colors.white70),
                ),
                Spacer(),
                Text("Time"),
                Spacer()
              ])),
              Spacer(),
              Container(
                  padding: EdgeInsets.all(4),
                  //titleTextStyle: const TextStyle(fontSize: 50, fontFamily: "Cursive", color: Colors.black),
                  child: tileGrid),
              Spacer(),
            ])));
  }

  gameOver(type) {
    setState(() {
      gameEndDialog(type);
    });
  }

  newgame() {
    setState(() {
      _flagging = 0;
      tilesRem = size * size;
      board = BoardMatrix(size: size, mines: mines, sizex: sizex, sizey: sizey);
      tileGrid = TileGrid(
          size: size,
          mines: mines,
          vals: board.vals,
          currVals: board.displayedVals,
          gameOver: gameOver,
          flagging: _flagging,
          tiles_rem: tilesRem);
    });
  }
}

class BoardMatrix {
  List<List<String>> vals = [];
  List<List<String>> displayedVals = [];

  var mines = 0;
  var size = 0;
  var sizex, sizey;
  var flagging;

  BoardMatrix({this.size = 0, this.mines = 0, this.sizex = 0, this.sizey = 0}) {
    for (var i = 0; i < sizex; i++) {
      List<String> temp = [];
      List<String> temp2 = [];
      for (var j = 0; j < sizey; j++) {
        temp.add("");
        temp2.add("");
      }
      vals.add(temp);
      displayedVals.add(temp2);
    }
    var rng = Random();
    while (mines > 0) {
      var x = (rng.nextInt(sizex));
      var y = (rng.nextInt(sizey));
      if (vals[x][y] != '*') {
        vals[x][y] = '*';
        mines--;
      }
    }

    for (var i = 0; i < sizex; i++) {
      for (var j = 0; j < sizey; j++) {
        if (vals[i][j] != '*') {
          var cnt = 0;
          for (var m = -1; m < 2; m++) {
            for (var n = -1; n < 2; n++) {
              if (i + m > -1 && j + n > -1 && i + m < size && j + n < size) {
                if (vals[i + m][j + n] == '*') cnt++;
              }
            }
          }
          if (cnt != 0) {
            vals[i][j] = "${cnt}";
          } else {
            vals[i][j] = " ";
          }
        }
      }
    }
  }
}
