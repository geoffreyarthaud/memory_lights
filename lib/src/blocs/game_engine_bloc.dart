import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/play_state.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';

import 'events.dart';
import 'game_event.dart';

final logger = Logger();

@singleton
class GameEngineBloc extends Bloc<GameEvent, GameState> {
  GameState _gameState;

  bool detectPlayRecordStop = false;

  int indexHumanPlay = 0;

  final RecordProvider recordProvider;

  final PlayRecordBloc playRecordBloc;

  final LightBloc lightBloc;

  StreamSubscription<PlayState> playRecordSubscription;

  StreamSubscription<int> lightSubscription;

  GameEngineBloc(this.recordProvider, this.playRecordBloc, this.lightBloc)
      : _gameState = GameState(
            nbCells: 4,
            level: 1,
            lifes: 3,
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
    if (startEvent.gameState == null ||
        startEvent.gameState.status == GameStatus.setup) {
      if (_checkState(startEvent, [GameStatus.setup])) {
        _gameState = _gameState.copyWith(
            status: GameStatus.listen,
            record: _gameState.record.isEmpty
                ? recordProvider.get(_gameState.level + 2, _gameState.nbCells)
                : _gameState.record);
        _startListen();
      }
    } else {
      _gameState = startEvent.gameState;
      switch (_gameState.status) {
        case GameStatus.listen:
          _startListen();
          break;
        case GameStatus.reproduce:
          lightSubscription = lightBloc.listen(_onLightEvent);
          break;
        case GameStatus.win:
          // TODO: Handle this case.
          break;
        case GameStatus.loose:
          // TODO: Handle this case.
          break;
        case GameStatus.setup:
        default:
          throw FormatException("Invalid status");
      }
    }
    return _gameState;
  }

  void _startListen() {
    playRecordSubscription = playRecordBloc.listen(_onPlayRecord);
    playRecordBloc.add(PlayRecordEvent.play(_gameState.record));
  }

  GameState _onHumanPlay(HumanPlayEvent humanPlayEvent) {
    lightSubscription = lightBloc.listen(_onLightEvent);
    return _gameState.copyWith(status: GameStatus.reproduce);
  }

  GameState _onHumanError(HumanErrorEvent humanErrorEvent) {
    return _gameState.copyWith(status: GameStatus.loose);
  }

  GameState _onHumanCorrect(HumanCorrectEvent humanCorrectEvent) {
    return _gameState.copyWith(status: GameStatus.win);
  }

  bool _checkState(AbstractEvent gameEvent, List<GameStatus> statusList) {
    if (statusList.contains(_gameState.status)) {
      return true;
    } else {
      logger.w(
          "Invalid event $gameEvent from current status ${_gameState.status}");
      return false;
    }
  }

  void _onPlayRecord(PlayState ps) {
    if (!detectPlayRecordStop && ps is Playing) {
      detectPlayRecordStop = true;
    } else if (detectPlayRecordStop && ps is Stopped) {
      playRecordSubscription.cancel();
      add(GameEvent.humanPlayEvent());
    }
  }

  void _onLightEvent(int lightId) {
    if (lightId <= 0) {
      return;
    }
    if (lightId != _gameState.record[indexHumanPlay]) {
      indexHumanPlay = 0;
      lightSubscription.cancel();
      add(GameEvent.humanErrorEvent());
    }
    indexHumanPlay++;
    if (indexHumanPlay >= _gameState.record.length) {
      indexHumanPlay = 0;
      lightSubscription.cancel();
      add(GameEvent.humanCorrectEvent());
    }
  }
}
