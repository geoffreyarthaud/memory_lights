// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_midi/flutter_midi.dart';
import 'package:memory_lights/src/di/light_module.dart';
import 'package:memory_lights/src/app.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final lightModule = _$LightModule();

  //Eager singletons must be registered in the right order
  g.registerSingleton<FlutterMidi>(lightModule.flutterMidi);
  g.registerSingleton<MyApp>(MyApp(g<FlutterMidi>()));
}

class _$LightModule extends LightModule {}
