import 'package:memory_lights/src/models/game_state.dart';
import 'package:sealed_unions/sealed_unions.dart';

import 'events.dart';

class StartEvent extends AbstractEvent {
  final GameState gameState;

  @override
  List<Object> get props => [gameState];

  StartEvent({this.gameState});

  @override
  String toString() => 'Start Event $gameState';
}

class HumanPlayEvent extends AbstractEvent {}

class HumanErrorEvent extends AbstractEvent {}

class HumanCorrectEvent extends AbstractEvent {}

class EndEvent extends AbstractEvent {}

class GameEvent extends
  Union5Impl<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent, EndEvent> {

  static Quintet<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent, EndEvent> _factory =
    const Quintet<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent, EndEvent>();

  GameEvent._(
      Union5<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent, EndEvent> union
  ) : super(union);

  factory GameEvent.startEvent({GameState gameState})
    => GameEvent._(_factory.first(StartEvent(gameState: gameState)));
  
  factory GameEvent.humanPlayEvent()
    => GameEvent._(_factory.second(HumanPlayEvent()));

  factory GameEvent.humanErrorEvent()
    => GameEvent._(_factory.third(HumanErrorEvent()));

  factory GameEvent.humanCorrectEvent()
    => GameEvent._(_factory.fourth(HumanCorrectEvent()));

    factory GameEvent.endEvent()
    => GameEvent._(_factory.fifth(EndEvent()));

  @override
  String toString() {
    return join((e) => e.toString(), (e) => e.toString(), (e) => e.toString(), (e) => e.toString(), (e) => e.toString());
  }

}
