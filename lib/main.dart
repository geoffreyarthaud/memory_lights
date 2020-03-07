import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'src/app.dart';
import 'src/di/injection.dart';

void main() {
    configureInjection(Env.prod);
    runApp(MyApp(getIt<FlutterMidi>()));
} 
