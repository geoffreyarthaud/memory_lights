import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';

import 'blocs/light_bloc.dart';
import 'di/injection.dart';
import 'ui/lights_page.dart';

@singleton
class MyApp extends StatelessWidget {
  final FlutterMidi flutterMidi;

  final LightsPage lightsPage;

  MyApp(this.flutterMidi, this.lightsPage) : super();

  @override
  Widget build(BuildContext context) {
    flutterMidi.unmute();
    rootBundle.load("assets/piano.sf2").then((sf2) {
      flutterMidi.prepare(sf2: sf2, name: "piano.sf2");
    });
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: BlocProvider<LightBloc>(
          create: (context) => LightBloc(),
          child: lightsPage
        ));
  }
}

