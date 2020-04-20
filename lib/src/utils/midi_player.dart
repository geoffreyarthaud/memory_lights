import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';

@singleton
class MidiPlayer {
  final FlutterMidi flutterMidi;

  bool _isReady = false;

  bool _hasPlayed = false;

  MidiPlayer(this.flutterMidi) {
    WidgetsFlutterBinding.ensureInitialized();
    flutterMidi.unmute();
    rootBundle.load("assets/piano.sf2").then((sf2) {
      flutterMidi.prepare(sf2: sf2, name: "piano.sf2");
    }).then((_) => _isReady = true);
  }

  bool get isReady => _isReady;

  Future<String> playMidiNote({int midi}) {
    if (_isReady) {
      _hasPlayed = true;
      return flutterMidi.playMidiNote(midi: midi);
    } else {
      return new Future(() => "");
    }
  }

  Future<String> stopMidiNote({int midi}) {
    if (_isReady && _hasPlayed) {
      return flutterMidi.stopMidiNote(midi: midi);
    } else {
      return new Future(() => "");
    }
  }

}