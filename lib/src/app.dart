import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'blocs/light_bloc.dart';
import 'ui/lights_page.dart';

class MyApp extends StatelessWidget {
  final FlutterMidi flutterMidi = FlutterMidi();
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<LightBloc>(
          create: (context) => LightBloc(),
          child: LightsPage(title: 'Memory lights'),
        ));
  }
}

