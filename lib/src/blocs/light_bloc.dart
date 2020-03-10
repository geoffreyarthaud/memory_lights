import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_lights/src/blocs/events.dart';

@singleton
class LightBloc extends Bloc<GestureEvent, int> {
  @override
  int get initialState => -1;

  @override
  Stream<int> mapEventToState(GestureEvent event) async* {
    yield event.type.join(
        (e) => 0, // UnTapEvent
        (e) => e.cell); // TapEvent
  }
}