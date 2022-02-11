import 'package:flutter/material.dart';
import 'dart:io';

main() => runApp(Tile());

class Tile extends StatefulWidget {
  @override
  var x;
  var y;
  var vals, type;
  var currVals, flagging;
  var gameOver, showRecurse, reduceTile;

  Tile(
      {this.gameOver,
      this.showRecurse,
      this.x = 0,
      this.y = 0,
      this.vals,
      this.currVals,
      this.reduceTile,
      this.flagging});

  normal() {
    if (currVals[x][y] != vals[x][y]) {
      currVals[x][y] = vals[x][y];
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
    print(widget.flagging);
    if (widget.vals[widget.x][widget.y] == '*') {
      setState(() {
        widget.currVals[widget.x][widget.y] = widget.vals[widget.x][widget.y];
        widget.type = "Mine";
      });
      //sleep(Duration(seconds: 5));
    }
    setState(() {
      if (widget.vals[widget.x][widget.y] == '*') {
        //var x = 0;
        widget.gameOver(false);
      } else if (widget.vals[widget.x][widget.y] != ' ') {
        widget.normal();
      } else {
        widget.showRecurse(widget.x, widget.y);
      }
    });
  }

  var clr;
  @override
  void initState() {
    clr = Colors.orangeAccent;

    if (widget.currVals[widget.x][widget.y] == "") {
      widget.type = "Not Touched";
    } else if (widget.currVals[widget.x][widget.y] == "*") {
      widget.type = "Mine";
    } else {
      widget.type = "Normal";
    }
    super.initState();
  }

  @override
  build(context) {
    if (widget.currVals[widget.x][widget.y] == "") {
      widget.type = "Not Touched";
    } else if (widget.currVals[widget.x][widget.y] == "*") {
      widget.type = "Mine";
    } else {
      widget.type = "Normal";
    }
    var MaxWidth = MediaQuery.of(context).size.width;
    var TileSize = MaxWidth * 0.098;

    if (widget.type == "Not Touched") {
      clr = Colors.orangeAccent;
    } else if (widget.type == "Normal") {
      clr = Colors.white;
    } else if (widget.type == "Mine") {
      clr = Colors.redAccent;
    }
    return Container(
        alignment: Alignment.center,
        child: SizedBox(
            height: TileSize, //height of button
            width: TileSize, //width of button
            child: ElevatedButton(
              onPressed: () => {click()},
              child: Text(
                widget.currVals[widget.x][widget.y],
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      width: 1, color: Colors.brown), //border width and color
                  elevation: 3,
                  primary: clr,
                  shape: ContinuousRectangleBorder()),
            )));
    //width: double.infinity);
  }
}
