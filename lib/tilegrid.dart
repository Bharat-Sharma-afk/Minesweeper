import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './tile.dart';

class TileGrid extends StatefulWidget {
  var board;
  var gameOver;

  TileGrid({Key? key, this.board, this.gameOver}) : super(key: key);

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
    widget.board.tiles_rem = widget.board.sizex * widget.board.sizey;
    super.initState();
  }

  reduceTile() {
    widget.board.tiles_rem = widget.board.tiles_rem - 1;
    if (widget.board.tiles_rem < 0) widget.board.tiles_rem = 0;
    gameWin();
  }

  gameWin() {
    if (widget.board.tiles_rem == widget.board.mines) {
      widget.gameOver(true);
    }
  }

  refresh() {
    print("Tile Grid State");
    setState(() {});
    print("Refreshed");
  }

  @override
  build(context) {
    row = [];
    btns = [];
    for (var x = 0; x < widget.board.sizex; x++) {
      List<Tile> temp = [];
      for (var y = 0; y < widget.board.sizey; y++) {
        temp.add(Tile(
          gameOver: widget.gameOver,
          x: x,
          y: y,
          board: widget.board,
          showRecurse: showRecurse,
          reduceTile: reduceTile,
        ));
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
      if (widget.board.vals[x][y] == ' ') {
        visited[x][y] = 1;
        btns[x][y].normal();
        for (var m = -1; m < 2; m++) {
          for (var n = -1; n < 2; n++) {
            if (x + m > -1 &&
                y + n > -1 &&
                x + m < widget.board.sizex &&
                y + n < widget.board.sizey) {
              recureFun(x + m, y + n, visited);
            }
          }
        }
      } else if (widget.board.vals[x][y] != '*') {
        visited[x][y] = 1;
        btns[x][y].normal();
      }
    }
  }

  showRecurse(var x, var y) {
    var visited = [];
    for (var i = 0; i < widget.board.sizex; i++) {
      var temp = [];
      for (var j = 0; j < widget.board.sizey; j++) {
        temp.add(0);
      }
      visited.add(temp);
    }

    setState(() {
      recureFun(x, y, visited);
    });
  }
}
