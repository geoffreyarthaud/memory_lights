import 'package:equatable/equatable.dart';

abstract class PlayState extends Equatable {
  @override
  List<Object> get props => [];
}

class Stopped extends PlayState {}

class Playing extends PlayState {
  final int note;

  Playing(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() {
    return "Playing " + note.toString();
  }
}

class Paused extends PlayState {}