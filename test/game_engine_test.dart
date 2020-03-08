import 'package:memory_lights/src/models/game_engine.dart';
import 'package:test/test.dart';

void main() {
  
  GameEngine gameEngine;

  setUp(() {
    gameEngine = GameEngine();
  });

  test('Game should start at level 1', () {
    expect(gameEngine.level, 1);
  });

  test('Game should start at score 0', () {
    expect(gameEngine.score, 0);
  });
}