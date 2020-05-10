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

class GameEvent extends
  Union4Impl<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent> {

  static Quartet<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent> _factory =
    const Quartet<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent>();

  GameEvent._(
      Union4<StartEvent, HumanPlayEvent, HumanErrorEvent, HumanCorrectEvent> union
  ) : super(union);

  factory GameEvent.startEvent({GameState gameState})
    => GameEvent._(_factory.first(StartEvent(gameState: gameState)));
  
  factory GameEvent.humanPlayEvent()
    => GameEvent._(_factory.second(HumanPlayEvent()));

  factory GameEvent.humanErrorEvent()
    => GameEvent._(_factory.third(HumanErrorEvent()));

  factory GameEvent.humanCorrectEvent()
    => GameEvent._(_factory.fourth(HumanCorrectEvent()));

  @override
  String toString() {
    return join((e) => e.toString(), (e) => e.toString(), (e) => e.toString(), (e) => e.toString());
  }

}
