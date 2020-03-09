import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockRecordProvider extends Mock implements RecordProvider {}

void main() {
  
  MockRecordProvider mockRecordProvider = MockRecordProvider();

  GameEngineBloc gameEngine;

  final GameState expectedInitial = GameState(nbCells: 4, level: 1, score: 0, record: [], status: GameStatus.setup);

  setUp(() {
    gameEngine = GameEngineBloc(mockRecordProvider);
  });

  tearDown(() {
    gameEngine?.close();
  });

  test('Game should start with correct state', () {

    expect(gameEngine.initialState, expectedInitial);
  });

  test('When game starts, then status is setup and then listen', () {

    // THEN
    expectLater(gameEngine, emitsInOrder(
      [expectedInitial, expectedInitial.copyWith(status: GameStatus.listen)]
    ));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

  test('When game starts, then a record is filled', () {
    // GIVEN
    when(mockRecordProvider.get(any, any)).thenReturn([2,4,1,3]);

    // THEN
    gameEngine.listen(expectAsync1((gameState) {
      if (gameState.status == GameStatus.listen) {
        expect(gameState.record, hasLength(greaterThan(0)));
      }
    }, count: 2));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

}