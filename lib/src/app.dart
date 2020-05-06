import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_lights/src/blocs/game_bloc_delegate.dart';

import 'blocs/light_bloc.dart';
import 'ui/lights_page.dart';

@singleton
class MyApp extends StatelessWidget {

  final LightsPage lightsPage;

  final GameBlocDelegate gameBlocDelegate;

  MyApp(this.lightsPage, this.gameBlocDelegate) : super() {
    BlocSupervisor.delegate = gameBlocDelegate;
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: BlocProvider<LightBloc>(
          create: (context) => LightBloc(),
          child: lightsPage
        ));
  }
}

