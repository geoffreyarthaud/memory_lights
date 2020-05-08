import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockRecordProvider extends Mock implements RecordProvider {}
class MockPlayRecordBloc extends Mock implements PlayRecordBloc {}
class MockLightBloc extends Mock implements LightBloc {}

void main() {
  
  MockRecordProvider mockRecordProvider; 
  MockPlayRecordBloc mockPlayRecordBloc;
  MockLightBloc mockLightBloc;

  GameEngineBloc gameEngine;

  final GameState expectedInitial = GameState(nbCells: 4, level: 1, score: 0, record: [], status: GameStatus.setup);

  setUp(() {
    mockRecordProvider = MockRecordProvider();
    mockPlayRecordBloc = MockPlayRecordBloc();
    mockLightBloc = MockLightBloc();
    gameEngine = GameEngineBloc(mockRecordProvider, mockPlayRecordBloc, mockLightBloc);
  });

  tearDown(() {
    gameEngine?.close();
    mockPlayRecordBloc?.close();
    mockLightBloc?.close();
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

  test('When game starts, then a record is correctly filled', () {
    // GIVEN
    List<int> expectedRecord = [2,4,1,3];
    when(mockRecordProvider.get(any, any)).thenReturn(expectedRecord);

    // THEN
    gameEngine.listen(expectAsync1((gameState) {
      if (gameState.status == GameStatus.listen) {
        expect(gameState.record, containsAllInOrder(expectedRecord));
      }
    }, count: 2));

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });

  test('When game starts, then a a play event is emitted', () {
    // GIVEN
    List<int> expectedRecord = [2,4,1,3];
    when(mockRecordProvider.get(any, any)).thenReturn(expectedRecord);

    // THEN
    gameEngine.listen((gameState) {
      if (gameState.status == GameStatus.listen) {
        verify(mockPlayRecordBloc.add(PlayRecordEvent.play(expectedRecord))).called(1);
      }
    });

    // WHEN
    gameEngine.add(GameEvent.startEvent());
  });




}