import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:test/test.dart';

void main() {
  
  GameEngineBloc gameEngine;

  final GameState expectedInitial = GameState(nbCells: 4, level: 1, score: 0, record: [], status: GameStatus.setup);

  setUp(() {
    gameEngine = GameEngineBloc();
  });

  tearDown(() {
    gameEngine?.close();
  });

  test('Game should start with correct state', () {

    expect(gameEngine.initialState, expectedInitial);
  });

  test('When game starts, Then status is finally listen', () {

    // THEN
    expectLater(gameEngine, emitsInOrder(
      [expectedInitial, expectedInitial.copyWith(status: GameStatus.listen)]
    ));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

  test('When game starts, Then a record is filled', () {
    // GIVEN

    // THEN
    gameEngine.listen(expectAsync1((gameState) {
      if (gameState.status == GameStatus.listen) {
        expect(gameState.record.length, greaterThan(0));
      }
    }, count: 2));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

}