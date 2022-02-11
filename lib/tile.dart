import 'package:flutter/material.dart';
import 'dart:io';

import 'package:mine/play.dart';

main() => runApp(Tile());

class Tile extends StatefulWidget {
  @override
  var x;
  var y;
  var type, board, flag, widget;
  var gameOver, showRecurse, reduceTile;

  Tile(
      {this.gameOver,
      this.showRecurse,
      this.x = 0,
      this.y = 0,
      this.board,
      this.reduceTile});

  normal() {
    if (board.currVals[x][y] != board.vals[x][y]) {
      board.currVals[x][y] = board.vals[x][y];
      reduceTile();
    }
    type = "Normal";
  }

  createState() {
    return TileState();
  }
}

class TileState extends State<Tile> {
  click() {
    if (widget.board.flagging == 1) {
      setState(() {
        if (widget.board.currVals[widget.x][widget.y] == 'F') {
          widget.board.currVals[widget.x][widget.y] = '';
          widget.board.flagged += 1;
        } else if (widget.board.currVals[widget.x][widget.y] == '' &&
            widget.board.flagged > 0) {
          widget.board.currVals[widget.x][widget.y] = 'F';
          widget.board.flagged -= 1;
        }
      });
      widget.board.infoPaneKey.currentState!.refresh();
    } else if (widget.board.currVals[widget.x][widget.y] != 'F') {
      setState(() {
        if (widget.board.vals[widget.x][widget.y] == '*') {
          widget.board.currVals[widget.x][widget.y] =
              widget.board.vals[widget.x][widget.y];
          widget.type = "Mine";
          widget.gameOver(false);
        } else if (widget.board.vals[widget.x][widget.y] != ' ') {
          widget.normal();
        } else {
          widget.showRecurse(widget.x, widget.y);
        }
      });
    }
    print(widget.board.flagged);
  }

  var clr;

  @override
  build(context) {
    if (widget.board.currVals[widget.x][widget.y] == "") {
      widget.type = "Not Touched";
    } else if (widget.board.currVals[widget.x][widget.y] == "*") {
      widget.type = "Mine";
    } else if (widget.board.currVals[widget.x][widget.y] == "F") {
      widget.type = "Flag";
    } else {
      widget.type = "Normal";
    }
    var MaxWidth = MediaQuery.of(context).size.width;
    var TileSize = MaxWidth * (1 / widget.board.sizey) * 0.98;

    if (widget.type == "Not Touched") {
      clr = Color.fromRGBO(31, 27, 24, 0.4);
      widget.widget = Image.asset(
        "images/tile.png",
      );
    } else if (widget.type == "Normal") {
      clr = Colors.white;
      widget.widget = Text(
        widget.board.currVals[widget.x][widget.y],
        style: TextStyle(color: Colors.black),
      );
    } else if (widget.type == "Flag") {
      widget.widget = Image.asset(
        "images/flag.ico",
        //height: 100,
        //width: 100,
      );
    } else if (widget.type == "Mine") {
      widget.widget = Image.asset(
        "images/mine.ico",
        //height: 100,
        //width: 100,
      );
      clr = Colors.redAccent;
    }
    return Container(
        alignment: Alignment.center,
        child: SizedBox(
            height: TileSize, //height of button
            width: TileSize, //width of button
            child: ElevatedButton(
              onPressed: () => {click()},
              child: widget.widget,
              style: ElevatedButton.styleFrom(
                  //side: BorderSide(width: 1, color: Colors.brown), //border width and color
                  elevation: 3,
                  padding: EdgeInsets.all(0.0),
                  primary: clr,
                  shape: ContinuousRectangleBorder()),
            )));
    //width: double.infinity);
  }
}
