import 'package:sealed_unions/sealed_unions.dart';

import 'events.dart';

class PlayEvent extends AbstractEvent {
  final List<int> record;

  @override
  List<Object> get props => record;

  PlayEvent(this.record);

  @override
  String toString() => 'Play Event $record';
}

class PauseEvent extends AbstractEvent {}

class ResumeEvent extends AbstractEvent {}

class StopEvent extends AbstractEvent {}

class TickEvent extends AbstractEvent {
  final int note;

  TickEvent(this.note);
}

class PlayRecordEvent extends
  Union5Impl<PlayEvent, PauseEvent, ResumeEvent, StopEvent, TickEvent> {

  static Quintet<PlayEvent, PauseEvent, ResumeEvent, StopEvent, TickEvent> _factory =
    const Quintet<PlayEvent, PauseEvent, ResumeEvent, StopEvent, TickEvent>();

  PlayRecordEvent._(
      Union5<PlayEvent, PauseEvent, ResumeEvent, StopEvent, TickEvent> union
  ) : super(union);

  factory PlayRecordEvent.play(List<int> record)
    => PlayRecordEvent._(_factory.first(PlayEvent(record)));
  
  factory PlayRecordEvent.pause()
    => PlayRecordEvent._(_factory.second(PauseEvent()));

  factory PlayRecordEvent.resume()
    => PlayRecordEvent._(_factory.third(ResumeEvent()));

  factory PlayRecordEvent.stop()
    => PlayRecordEvent._(_factory.fourth(StopEvent()));

  factory PlayRecordEvent.tick(int note)
    => PlayRecordEvent._(_factory.fifth(TickEvent(note)));

  @override
  String toString() {
    return join((e) => e.toString(), (e) => e.toString(), (e) => e.toString(), (e) => e.toString(), (e) => e.toString());
  }

}
