import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:memory_lights/src/di/injection.dart';

import 'light_cell.dart';

class LightsPage extends StatelessWidget {
  final FlutterMidi flutterMidi;

  LightsPage({Key key, this.title}) : flutterMidi = getIt<FlutterMidi>(), super(key: key) {
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
                getIt<LightCell>(param1: LightCellProperties(1, Colors.green[400], Colors.green[100], 62)),
                _emptyCell(),
                getIt<LightCell>(param1: LightCellProperties(2, Colors.blue[400], Colors.blue[100], 65)),
                _emptyCell(),
                getIt<LightCell>(param1: LightCellProperties(3, Colors.red[400], Colors.red[100], 69)),
                _emptyCell(),
                getIt<LightCell>(param1: LightCellProperties(4, Colors.orange[400], Colors.orange[100], 72)),
                _emptyCell(),
              ],
            ));
  }

  Container _emptyCell() => Container(padding: const EdgeInsets.all(8));
}

