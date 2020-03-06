import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'light_cell.dart';

class LightsPage extends StatelessWidget {
  final FlutterMidi flutterMidi = FlutterMidi();

  LightsPage({Key key, this.title}) : super(key: key) {
    flutterMidi.unmute();
    rootBundle.load("assets/piano.sf2").then((sf2) {
      flutterMidi.prepare(sf2: sf2, name: "piano.sf2");
    });
  }

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                _emptyCell(),
                LightCell(1, Colors.green[400], Colors.green[100], flutterMidi, 62),
                _emptyCell(),
                LightCell(2, Colors.blue[400], Colors.blue[100], flutterMidi, 65),
                _emptyCell(),
                LightCell(3, Colors.red[400], Colors.red[100], flutterMidi, 69),
                _emptyCell(),
                LightCell(4, Colors.orange[400], Colors.orange[100], flutterMidi, 72),
                _emptyCell(),
              ],
            ));
  }

  Container _emptyCell() => Container(padding: const EdgeInsets.all(8));
}

