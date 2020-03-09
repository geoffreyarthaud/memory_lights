// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:memory_lights/src/utils/record_provider.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:memory_lights/src/di/light_module.dart';
import 'package:memory_lights/src/ui/light_cell.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final lightModule = _$LightModule();
  g.registerFactoryParam<LightCell, LightCellProperties, dynamic>(
      (props, _) => LightCell(props, g<FlutterMidi>()));

  //Eager singletons must be registered in the right order
  g.registerSingleton<RecordProvider>(RecordProvider());
  g.registerSingleton<PlayRecordBloc>(PlayRecordBloc());
  g.registerSingleton<GameEngineBloc>(
      GameEngineBloc(g<RecordProvider>(), g<PlayRecordBloc>()));
  g.registerSingleton<FlutterMidi>(lightModule.flutterMidi);
}

class _$LightModule extends LightModule {}
