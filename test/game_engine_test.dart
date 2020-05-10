@Timeout(const Duration(seconds: 2))
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/play_state.dart';
import 'package:memory_lights/src/models/game_state.dart';
import 'package:memory_lights/src/utils/record_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockRecordProvider extends Mock implements RecordProvider {}
class MockPlayRecordBloc extends Mock implements PlayRecordBloc {}
class MockLightBloc extends Mock implements LightBloc {}

GameEngineBloc gameEngine;

void main() {
  
  MockRecordProvider mockRecordProvider; 
  MockPlayRecordBloc mockPlayRecordBloc;
  MockLightBloc mockLightBloc;

  final GameState expectedInitial = GameState(nbCells: 4, level: 1, lifes: 3, score: 0, record: [], status: GameStatus.setup);

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

    // WHEN
    gameEngine.add(GameEvent.startEvent());

    // THEN
    expectLater(gameEngine, emitsInOrder(
      [expectedInitial, expectedInitial.copyWith(status: GameStatus.listen)]
    ));

  });

  test('When game starts, then a record is correctly filled', () {
    // GIVEN
    List<int> expectedRecord = [2,4,1,3];
    when(mockRecordProvider.get(any, any)).thenReturn(expectedRecord);

    // WHEN
    gameEngine.add(GameEvent.startEvent());

    // THEN
    gameEngine.listen(expectAsync1((gameState) {
      if (gameState.status == GameStatus.listen) {
        expect(gameState.record, containsAllInOrder(expectedRecord));
      }
    }, count: 2));

  });

  test('When game starts, then a a play event is emitted', () {
    // GIVEN
    List<int> expectedRecord = [2,4,1,3];
    when(mockRecordProvider.get(any, any)).thenReturn(expectedRecord);

    // WHEN
    gameEngine.add(GameEvent.startEvent());

    // THEN
    gameEngine.listen((gameState) {
      if (gameState.status == GameStatus.listen) {
        verify(mockPlayRecordBloc.add(PlayRecordEvent.play(expectedRecord))).called(1);
      }
    });

  });

  test('When Record has finished playing, then game state becomes reproduce', () {
    // GIVEN
    mockStates(mockPlayRecordBloc, [Paused(), Playing(1), Playing(0), Stopped()]);
    var loadedState = GameState(
            nbCells: 4,
            level: 1,
            score: 0,
            record: [2,4,1,3],
            status: GameStatus.listen);
        
    // WHEN
    gameEngine.add(GameEvent.startEvent(gameState: loadedState));

    // THEN
    expect(gameEngine, emitsInOrder(
      [expectedInitial, loadedState, loadedState.copyWith(status: GameStatus.reproduce)]
    ));


  });

  test('When human plays and make mistake, then a loose event is emitted', () {
    // GIVEN
    mockStates(mockLightBloc, [-1, 1, 0, 2, 0, 3, 0, 4]);
    var loadedState = GameState(
            nbCells: 4,
            level: 1,
            score: 0,
            record: [2,4,1,3],
            status: GameStatus.reproduce);

    // WHEN
    gameEngine.add(GameEvent.startEvent(gameState: loadedState));
    
    // THEN
    expect(gameEngine, emitsInOrder(
      [expectedInitial, loadedState, loadedState.copyWith(status: GameStatus.loose)]
    ));
    
  });

    test('When human plays without error, then a win event is emitted', () {
    // GIVEN
    mockStates(mockLightBloc, [-1, 2, 0, 4, 0, 1, 0, 3]);
    var loadedState = GameState(
            nbCells: 4,
            level: 1,
            score: 0,
            record: [2,4,1,3],
            status: GameStatus.reproduce);

    // WHEN
    gameEngine.add(GameEvent.startEvent(gameState: loadedState));
    
    // THEN
    expect(gameEngine, emitsInOrder(
      [expectedInitial, loadedState, loadedState.copyWith(status: GameStatus.win)]
    ));
    
  });

}

StreamSubscription<T> mockStream<T>(Invocation invocation, List<T> fromList) {
  return Stream.fromIterable(fromList).listen(invocation.positionalArguments[0]);
}

void mockStates<S>(Bloc<dynamic,S> bloc, List<S> states) {
  when(bloc.listen(any)).thenAnswer((i) => mockStream(i, states));
}
