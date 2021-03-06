import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/play_state.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';

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

  static final List<int> durations = [1000, 707, 500, 354, 250];

  static final GameState initialGameState = GameState(
      nbCells: 4,
      level: 1,
      lifes: 3,
      score: 0,
      lastScore: 0,
      lastLevel: 0,
      record: [],
      status: GameStatus.setup);

  StreamSubscription<PlayState> playRecordSubscription;

  StreamSubscription<int> lightSubscription;

  GameEngineBloc(this.recordProvider, this.playRecordBloc, this.lightBloc)
      : _gameState = initialGameState,
        super();

  @override
  GameState get initialState => _gameState;

  @override
  Stream<GameState> mapEventToState(event) async* {
    yield event.join(
        _onStart, _onHumanPlay, _onHumanError, _onHumanCorrect, _onEnded);
  }

  GameState _onStart(StartEvent startEvent) {

    if (startEvent.gameState == null ||
        startEvent.gameState.status == GameStatus.setup) {
      _gameState = _gameState.copyWith(
          status: GameStatus.listen,
          record: recordProvider.get(_gameState.level + 2, _gameState.nbCells,
              from: _gameState.record));
      _startListen();
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
          break;
        case GameStatus.loose:
          break;
        case GameStatus.setup:
        default:
          throw FormatException("Invalid status");
      }
    }
    return _gameState;
  }

  void _startListen() {
    detectPlayRecordStop = false;
    playRecordSubscription = playRecordBloc.listen(_onPlayRecord);
    playRecordBloc.add(PlayRecordEvent.play(_gameState.record,
        durations[min(_gameState.level ~/ 5, durations.length - 1)]));
  }

  GameState _onHumanPlay(HumanPlayEvent humanPlayEvent) {
    indexHumanPlay = 0;
    lightSubscription = lightBloc.listen(_onLightEvent);
    return _gameState.copyWith(status: GameStatus.reproduce);
  }

  GameState _onHumanError(HumanErrorEvent humanErrorEvent) {
    _gameState = _gameState.copyWith(
        status: GameStatus.loose, lifes: _gameState.lifes - 1);
    if (_gameState.lifes > 0) {
      Timer(Duration(seconds: 3), () => add(GameEvent.startEvent()));
    } else {
      Timer(Duration(seconds: 3), () => add(GameEvent.endEvent()));
    }

    return _gameState.copyWith(status: GameStatus.loose);
  }

  GameState _onHumanCorrect(HumanCorrectEvent humanCorrectEvent) {
    int nextScore = _gameState.score + 100 + _gameState.lifes;
    int nextLevel = _gameState.level + 1;
    int nextLifes =
        nextLevel % 5 == 0 ? _gameState.lifes + 1 : _gameState.lifes;
    _gameState = _gameState.copyWith(
        status: GameStatus.win,
        score : nextScore,
        level: nextLevel,
        lifes: nextLifes);
    Timer(Duration(seconds: 3), () => add(GameEvent.startEvent()));
    return _gameState;
  }

  GameState _onEnded(EndEvent endEvent) {
    lightSubscription?.cancel();
    playRecordSubscription?.cancel();
    playRecordBloc.add(PlayRecordEvent.stop());
    _gameState = initialGameState.copyWith(lastLevel: _gameState.level, lastScore: _gameState.score);
    return _gameState;
  }

  void _onPlayRecord(PlayState ps) {
    if (!detectPlayRecordStop && ps is Playing) {
      detectPlayRecordStop = true;
    } else if (detectPlayRecordStop && ps is Stopped) {
      playRecordSubscription.cancel();
      playRecordSubscription = null;
      add(GameEvent.humanPlayEvent());
    }
  }

  void _onLightEvent(int lightId) {
    if (lightId <= 0) {
      return;
    }
    if (lightId != _gameState.record[indexHumanPlay]) {
      lightSubscription.cancel();
      lightSubscription = null;
      add(GameEvent.humanErrorEvent());
    } else {
      indexHumanPlay++;
      if (indexHumanPlay >= _gameState.record.length) {
        lightSubscription.cancel();
        lightSubscription = null;
        add(GameEvent.humanCorrectEvent());
      }
    }
  }
}
