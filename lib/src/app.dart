import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';

import 'blocs/light_bloc.dart';
import 'ui/lights_page.dart';

@singleton
class MyApp extends StatelessWidget {
  final FlutterMidi flutterMidi;

  MyApp(this.flutterMidi);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: BlocProvider<LightBloc>(
          create: (context) => LightBloc(),
          child: LightsPage(title: 'Memory lights'),
        ));
  }
}

