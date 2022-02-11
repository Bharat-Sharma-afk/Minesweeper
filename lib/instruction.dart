import 'package:flutter/material.dart';
import 'splashscreen.dart';

class InstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Instructions"),
        ),
        body: Column(
          children: [
            const Text("1. Just"),
            const Text("2. Don't"),
            const Text("3. Explode"),
            const Text("4. the Mines"),
          ],
        ));
  }
}
