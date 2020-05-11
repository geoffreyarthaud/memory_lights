import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:memory_lights/src/utils/int_ticker.dart';

import 'play_event.dart';
import 'play_state.dart';

final Logger logger = Logger();

@singleton
class PlayRecordBloc extends Bloc<PlayRecordEvent, PlayState> {

  @override
  PlayState get initialState => Stopped();

  StreamSubscription<int> _tickerSubscription;

  @override
  Stream<PlayState> mapEventToState(PlayRecordEvent event) async* {
    yield* event.join(
      (e) => _mapPlayToState(e),
      (e) => _mapPauseToState(e),
      (e) => _mapResumeToState(e),
      (e) => _mapStopToState(e),
      (e) => _mapTickToState(e),
    );
  }

  Stream<PlayState> _mapPlayToState(PlayEvent e) async* {
    yield Paused();
    _tickerSubscription?.cancel();
    _tickerSubscription = IntTicker
      .tick(e.record, e.duration)
      .listen((note) => add(PlayRecordEvent.tick(note)),
      onDone: () {
        add(PlayRecordEvent.stop());
      });

  }

  Stream<PlayState> _mapPauseToState(PauseEvent e) async* {
    if (state is Playing) {
      _tickerSubscription?.pause();
      yield Paused();
    }
  }

  Stream<PlayState> _mapResumeToState(ResumeEvent e) async* {
    if (state is Paused) {
      _tickerSubscription.resume();
      yield Playing(0);
    }
  }

  Stream<PlayState> _mapStopToState(StopEvent e) async* {
    _tickerSubscription?.cancel();
    yield Stopped();
  }

  Stream<PlayState> _mapTickToState(TickEvent e) async* {
    yield Playing(e.note);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
