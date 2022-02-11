import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './tile.dart';

class TileGrid extends StatefulWidget {
  var vals;
  var currVals, size, mines, gameOver, flagging, tiles_rem;

  TileGrid(
      {this.size,
      this.mines,
      this.vals,
      this.currVals,
      this.gameOver,
      this.flagging,
      this.tiles_rem});

  @override
  createState() {
    return TileGridState();
  }
}

class TileGridState extends State<TileGrid> {
  List<Widget> row = [];
  List<List<Tile>> btns = [];

  @override
  void initState() {
    widget.tiles_rem = widget.size * widget.size;
    super.initState();
  }

  reduceTile() {
    widget.tiles_rem = widget.tiles_rem - 1;
    if (widget.tiles_rem < 0) widget.tiles_rem = 0;
    gameWin();
  }

  gameWin() {
    //print("K");
    //print(widget.tiles_rem);
    if (widget.tiles_rem == widget.mines) {
      widget.gameOver(true);
    }
  }

  @override
  build(context) {
    row = [];
    btns = [];
    for (var x = 0; x < widget.size; x++) {
      List<Tile> temp = [];
      for (var y = 0; y < widget.size; y++) {
        temp.add(Tile(
            gameOver: widget.gameOver,
            x: x,
            y: y,
            vals: widget.vals,
            currVals: widget.currVals,
            showRecurse: showRecurse,
            reduceTile: reduceTile,
            flagging: widget.flagging));
      }
      row.add(Row(
        children: [...temp],
      ));
      btns.add(temp);
    }
    return Column(children: row);
  }

  recureFun(x, y, visited) {
    if (visited[x][y] != 1) {
      if (widget.vals[x][y] == ' ') {
        visited[x][y] = 1;
        btns[x][y].normal();
        for (var m = -1; m < 2; m++) {
          for (var n = -1; n < 2; n++) {
            if (x + m > -1 &&
                y + n > -1 &&
                x + m < widget.size &&
                y + n < widget.size) {
              recureFun(x + m, y + n, visited);
            }
          }
        }
      } else if (widget.vals[x][y] != '*') {
        visited[x][y] = 1;
        btns[x][y].normal();
      }
    }
  }

  showRecurse(var x, var y) {
    var visited = [];
    for (var i = 0; i < widget.size; i++) {
      var temp = [];
      for (var j = 0; j < widget.size; j++) {
        temp.add(0);
      }
      visited.add(temp);
    }
    //for (var i = 0; i < widget.size; i++) print(widget.currVals[i]);

    setState(() {
      recureFun(x, y, visited);
    });
  }
}
