import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_lights/src/models/events.dart';

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