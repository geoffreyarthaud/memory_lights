import 'package:memory_lights/src/blocs/play_event.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/play_state.dart';
import 'package:test/test.dart';

void main() {
  PlayRecordBloc playRecordBloc;

  setUp(() {
    playRecordBloc = PlayRecordBloc();
  });

  test('When play event of one note 42, then emits this note after initialization', () {
    // THEN
    expectLater(playRecordBloc, emitsInOrder(
      [Stopped(), Paused(), Playing(42), Playing(0)]
    ));

    // WHEN
    playRecordBloc.add(PlayRecordEvent.play([42], 10));
  });

    test('When play event of four note 4,2,3,5, then emits theses notes after initialization', () {
    // THEN
    expectLater(playRecordBloc, emitsInOrder(
      [Stopped(), Paused(), Playing(4), Playing(0), Playing(2), Playing(0), Playing(3), Playing(0), Playing(5), Playing(0)]
    ));

    // WHEN
    playRecordBloc.add(PlayRecordEvent.play([4,2,3,5], 10));
  });
}