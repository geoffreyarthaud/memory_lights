import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

@singleton
class GameBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    logger.i("Bloc " + bloc.toString() + " with Object " + event.toString());
    super.onEvent(bloc, event);
  }
}