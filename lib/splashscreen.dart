import 'package:flutter/material.dart';
import './instruction.dart';
import './play.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Column(
        children: [
          Spacer(),
          Image.asset("images/Mine.png"),
          const Text(
            "Minesweeper",
            style: TextStyle(
                fontFamily: "Cursive", color: Colors.white, fontSize: 50),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                );
              },
              child: const Text("Play")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InstructionScreen()),
                );
              },
              child: Text("Instructions")),
          ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
                //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Text("Quit")),
          Spacer(),
        ],
      ),
    );
  }
}
