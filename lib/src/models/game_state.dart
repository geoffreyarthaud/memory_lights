
import 'package:flutter/foundation.dart';

class GameState {
  final int nbCells;
  final int level;
  final int score;
  final int nbTry;
  final GameStatus status;
  final List<int> record;
  GameState({
    this.nbCells,
    this.level,
    this.score,
    this.nbTry,
    this.status,
    this.record,
  });

  GameState copyWith({
    int nbCells,
    int level,
    int score,
    int nbTry,
    GameStatus status,
    List<int> record,
  }) {
    return GameState(
      nbCells: nbCells ?? this.nbCells,
      level: level ?? this.level,
      score: score ?? this.score,
      nbTry: nbTry ?? this.nbTry,
      status: status ?? this.status,
      record: record ?? this.record,
    );
  }

  @override
  String toString() {
    return 'GameState(nbCells: $nbCells, level: $level, score: $score, nbTry: $nbTry, status: $status, record: $record)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GameState &&
      o.nbCells == nbCells &&
      o.level == level &&
      o.score == score &&
      o.nbTry == nbTry &&
      o.status == status &&
      listEquals(o.record, record);
  }

  @override
  int get hashCode {
    return nbCells.hashCode ^
      level.hashCode ^
      score.hashCode ^
      nbTry.hashCode ^
      status.hashCode ^
      record.hashCode;
  }
}

enum GameStatus {
  setup,
  listen,
  reproduce,
  win,
  loose,
}