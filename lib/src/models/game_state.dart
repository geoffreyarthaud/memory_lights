
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GameState {
  final int nbCells;
  final int level;
  final int lifes;
  final int score;
  final GameStatus status;
  final List<int> record;
  final int lastScore;
  final int lastLevel;
  GameState({
    this.nbCells,
    this.level,
    this.lifes,
    this.score,
    this.status,
    this.record,
    this.lastScore,
    this.lastLevel,
  });

  GameState copyWith({
    int nbCells,
    int level,
    int lifes,
    int score,
    GameStatus status,
    List<int> record,
    int lastScore,
    int lastLevel,
  }) {
    return GameState(
      nbCells: nbCells ?? this.nbCells,
      level: level ?? this.level,
      lifes: lifes ?? this.lifes,
      score: score ?? this.score,
      status: status ?? this.status,
      record: record ?? this.record,
      lastScore: lastScore ?? this.lastScore,
      lastLevel: lastLevel ?? this.lastLevel,
    );
  }

  @override
  String toString() {
    return 'GameState(nbCells: $nbCells, level: $level, lifes: $lifes, score: $score, status: $status, record: $record, lastScore: $lastScore, lastLevel: $lastLevel)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is GameState &&
      o.nbCells == nbCells &&
      o.level == level &&
      o.lifes == lifes &&
      o.score == score &&
      o.status == status &&
      listEquals(o.record, record) &&
      o.lastScore == lastScore &&
      o.lastLevel == lastLevel;
  }

  @override
  int get hashCode {
    return nbCells.hashCode ^
      level.hashCode ^
      lifes.hashCode ^
      score.hashCode ^
      status.hashCode ^
      record.hashCode ^
      lastScore.hashCode ^
      lastLevel.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'nbCells': nbCells,
      'level': level,
      'lifes': lifes,
      'score': score,
      'status': status,
      'record': record,
      'lastScore': lastScore,
      'lastLevel': lastLevel,
    };
  }

  static GameState fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GameState(
      nbCells: map['nbCells'],
      level: map['level'],
      lifes: map['lifes'],
      score: map['score'],
      status: map['status'],
      record: List<int>.from(map['record']),
      lastScore: map['lastScore'],
      lastLevel: map['lastLevel'],
    );
  }

  String toJson() => json.encode(toMap());

  static GameState fromJson(String source) => fromMap(json.decode(source));
}

enum GameStatus {
  setup,
  listen,
  reproduce,
  win,
  loose,
}