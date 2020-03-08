import 'package:bloc/bloc.dart';
import 'package:memory_lights/src/models/game_state.dart';

import 'game_event.dart';

class GameEngineBloc extends Bloc<GameEvent, GameState> {
  GameState _gameState;

  GameEngineBloc() : _gameState = GameState(nbCells: 4, level: 1, score: 0, record: [], status: GameStatus.setup), super();

  @override
  GameState get initialState => _gameState;

  @override
  Stream<GameState> mapEventToState(event) async* {
    yield event.join(
        _onStart, _onHumanPlay, _onHumanError, _onHumanCorrect);
  }

  GameState _onStart(StartEvent startEvent) {
    return _gameState.copyWith(status: GameStatus.listen);
  }

  GameState _onHumanPlay(HumanPlayEvent humanPlayEvent) {
    // TODO
    return _gameState;
  }

  GameState _onHumanError(HumanErrorEvent humanErrorEvent) {
    return _gameState;
  }

  GameState _onHumanCorrect(HumanCorrectEvent humanCorrectEvent) {
    return _gameState;
  }


}
