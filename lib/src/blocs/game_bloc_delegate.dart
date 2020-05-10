import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

@singleton
class GameBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event.toString() + " from " + bloc.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition.nextState.toString() + " from " + bloc.toString());
    super.onTransition(bloc, transition);
  }

  
}