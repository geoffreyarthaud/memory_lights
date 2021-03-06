import 'package:equatable/equatable.dart';
import 'package:sealed_unions/sealed_unions.dart';

abstract class AbstractEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OffEvent {}

class OnEvent {
  final int cell;

  OnEvent(this.cell);
}

class GestureEvent {
  Union2<OffEvent, OnEvent> type;

  static Doublet<OffEvent, OnEvent> _factory = Doublet<OffEvent, OnEvent>();

  static GestureEvent _offEvent =
      GestureEvent._internal(Doublet<OffEvent, OnEvent>().first(OffEvent()));

  factory GestureEvent.onEvent(int cell) =>
      GestureEvent._internal(_factory.second(OnEvent(cell)));

  factory GestureEvent.offEvent() => _offEvent;

  GestureEvent._internal(this.type);

  @override
  String toString() {
    return type.join((e) => e.toString(), (e) => e.toString());
  }
}
