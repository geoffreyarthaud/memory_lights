import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';

import 'events.dart';
import 'game_event.dart';

final logger = Logger();

@singleton
class GameEngineBloc extends Bloc<GameEvent, GameState> {
  GameState _gameState;

  final RecordProvider recordProvider;

  final PlayRecordBloc playRecordBloc;

  GameEngineBloc(this.recordProvider, this.playRecordBloc)
      : _gameState = GameState(
            nbCells: 4,
            level: 1,
            score: 0,
            record: [],
            status: GameStatus.setup),
        super();

  @override
  GameState get initialState => _gameState;

  @override
  Stream<GameState> mapEventToState(event) async* {
    yield event.join(_onStart, _onHumanPlay, _onHumanError, _onHumanCorrect);
  }

  GameState _onStart(StartEvent startEvent) {
    if (startEvent.gameState == null) {
      if (_checkState(startEvent, [GameStatus.setup])) {
        _gameState = _gameState.copyWith(
          status: GameStatus.listen,
          record: recordProvider.get(_gameState.level + 2, _gameState.nbCells)
        );
        playRecordBloc.add(PlayRecordEvent.play(_gameState.record));
      }
    } else {
      // TODO : check GameState correctness
      return startEvent.gameState;
    }
    return _gameState;
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

  bool _checkState(AbstractEvent gameEvent, List<GameStatus> statusList) {
    if(statusList.contains(_gameState.status)) {
      return true;
    } else {
      logger.w("Invalid event $gameEvent from current status ${_gameState.status}");
      return false;
    }
  }
}
