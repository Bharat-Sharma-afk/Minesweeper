import 'dart:io';

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
  int sizex = 14;
  int sizey = 10;
  int mines = 15;
  var board, tileGrid, iPane;
  var ctext;

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

  @override
  Widget build(BuildContext context) {
    ctext = context;
    return Material(
        child: Container(
            //color: Colors.orangeAccent,
            child: Container(
                color: Colors.black26, //.fromRGBO(31, 27, 24, 1),
                child: Column(children: [
                  Spacer(),
                  Container(
                      child: const Text(
                    "Minesweeper",
                    style: TextStyle(
                        fontFamily: "Calibri",
                        color: Color.fromRGBO(83, 109, 123, 0.95),
                        fontSize: 30),
                  )),
                  Spacer(),
                  iPane,
                  Spacer(),
                  Container(
                      padding: EdgeInsets.all(4),
                      //titleTextStyle: const TextStyle(fontSize: 50, fontFamily: "Cursive", color: Colors.black),
                      child: tileGrid),
                  Spacer(),
                ]))));
  }

  standard() {
    var MaxWidth = MediaQuery.of(context).size.width;
    var TileSize = MaxWidth * (1 / board.sizey) * 0.98;
  }

  gameOver(type) {
    //type True when Game Win and False if Lose
    for (var x = 0; x < sizex; x++) {
      for (var y = 0; y < sizey; y++) {
        if (board.vals[x][y] == '*') {
          board.currVals[x][y] = '*';
        }
      }
    }

    board.tileGridKey.currentState!.refresh();
    Future.delayed(Duration(seconds: 2)).then((_) {
      gameEndDialog(type);
    });
  }

  newgame() {
    setState(() {
      board = BoardMatrix(mines: mines, sizex: sizex, sizey: sizey);
      iPane = InfoPane(
        key: board.infoPaneKey,
        board: board,
      );
      board.InfoPane = iPane;
      tileGrid = TileGrid(
        key: board.tileGridKey,
        board: board,
        gameOver: gameOver,
      );
    });
  }
}

class BoardMatrix {
  List<List<String>> vals = [];
  List<List<String>> currVals = [];

  final GlobalKey<InfoPaneState> infoPaneKey = GlobalKey<InfoPaneState>();
  final GlobalKey<TileGridState> tileGridKey = GlobalKey<TileGridState>();
  var mines = 0;
  var sizex, sizey;
  var flagging, tiles_rem, flagged;
  var InfoPane;

  BoardMatrix({this.mines = 0, this.sizex = 0, this.sizey = 0}) {
    var NoMines = mines;
    for (var i = 0; i < sizex; i++) {
      List<String> temp = [];
      List<String> temp2 = [];
      for (var j = 0; j < sizey; j++) {
        temp.add("");
        temp2.add("");
      }
      vals.add(temp);
      currVals.add(temp2);
    }
    var rng = Random();
    while (NoMines > 0) {
      var x = (rng.nextInt(sizex));
      var y = (rng.nextInt(sizey));
      if (vals[x][y] != '*') {
        vals[x][y] = '*';
        NoMines--;
      }
    }

    for (var i = 0; i < sizex; i++) {
      for (var j = 0; j < sizey; j++) {
        if (vals[i][j] != '*') {
          var cnt = 0;
          for (var m = -1; m < 2; m++) {
            for (var n = -1; n < 2; n++) {
              if (i + m > -1 && j + n > -1 && i + m < sizex && j + n < sizey) {
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
    tiles_rem = sizex * sizey;
    flagging = 0;
    flagged = mines;
  }
}

class InfoPane extends StatefulWidget {
  var board;

  InfoPane({Key? key, this.board}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InfoPaneState();
  }
}

class InfoPaneState extends State<InfoPane> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Image.asset(
        "images/mine.ico",
        height: 50,
        width: 50,
      ),
      Text(
        "${widget.board.flagged}",
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
      Spacer(),
      ElevatedButton(
        onPressed: ChangeFlagging,
        child: (widget.board.flagging == 1)
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
    ]));
  }

  ChangeFlagging() {
    setState(() {
      widget.board.flagging += 1;
      widget.board.flagging = (widget.board.flagging % 2);
    });
  }

  refresh() {
    print("Info Pane Refresh");
    setState(() {
      print(widget.board.flagged);
    });
  }
}
