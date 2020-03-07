import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';

@registerModule
abstract class LightModule {
  @singleton
  FlutterMidi get flutterMidi => FlutterMidi();
}