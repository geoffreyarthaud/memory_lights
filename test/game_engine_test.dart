import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:test/test.dart';

void main() {
  
  GameEngineBloc gameEngine;

  final GameState initial = GameState(nbCells: 4, level: 1, score: 0, record: [], status: GameStatus.setup);

  setUp(() {
    gameEngine = GameEngineBloc();
  });

  tearDown(() {
    gameEngine?.close();
  });

  test('Game should start at level 1', () {
    expect(gameEngine.initialState.level, 1);
  });

  test('Game should start at score 0', () {
    expect(gameEngine.initialState.score, 0);
  });

  test('Game should start with setup status', () {
    expect(gameEngine.initialState.status, GameStatus.setup);
  });

  test('Game should start with correct state', () {
    expect(gameEngine.initialState, initial);
  });

  test('When game starts, Then status is listen', () {

    // THEN
    expectLater(gameEngine, emitsInOrder(
      [initial, initial.copyWith(status: GameStatus.listen)]
    ));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

}