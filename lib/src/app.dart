import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/light_bloc.dart';
import 'ui/lights_page.dart';

class MyApp extends StatelessWidget {

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

