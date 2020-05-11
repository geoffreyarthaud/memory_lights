import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_lights/src/blocs/game_engine_bloc.dart';
import 'package:memory_lights/src/blocs/game_event.dart';
import 'package:memory_lights/src/di/injection.dart';
import 'package:memory_lights/src/models/game_state.dart';

import 'light_cell.dart';

@singleton
class LightsPage extends StatelessWidget {

  final GameEngineBloc gameEngineBloc;

  LightsPage(this.gameEngineBloc)
      : title = 'Memory lights',
        super();

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameEngineBloc, GameState>(
        bloc: gameEngineBloc,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Restart',
                    onPressed: () {
                      gameEngineBloc.add(GameEvent.endEvent());
                    },
                  )]
              ),
              body: Column(children: <Widget>[
                Expanded(
                    child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: <Widget>[
                    _emptyCell(),
                    getIt<LightCell>(
                        param1: LightCellProperties(
                            1, Colors.green[400], Colors.green[100], 62,
                            tappable: _isTappable(state))),
                    _emptyCell(),
                    getIt<LightCell>(
                        param1: LightCellProperties(
                            2, Colors.blue[400], Colors.blue[100], 65,
                            tappable: _isTappable(state))),
                    centerAction(state),
                    getIt<LightCell>(
                        param1: LightCellProperties(
                            3, Colors.red[400], Colors.red[100], 69,
                            tappable: _isTappable(state))),
                    _emptyCell(),
                    getIt<LightCell>(
                        param1: LightCellProperties(
                            4, Colors.orange[400], Colors.orange[100], 72,
                            tappable: _isTappable(state))),
                    _emptyCell(),
                  ],
                )),
                Row(children: [
                  Expanded(
                      child: Text(_getLeftFooterText(state),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15))),
                  Text(_getRightFooterTest(state),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15)),
                ])
              ]));
        });
  }

  Container _emptyCell() => Container(padding: const EdgeInsets.all(8));

  String _getLeftFooterText(GameState state) {
    return 'Level : ' + state.level.toString() + ' ' + (state.lifes > 5 ? '❤️ x ' + state.lifes.toString() : '❤️'*state.lifes);
  }

  String _getRightFooterTest(GameState state) {
    return 'Score : ' + state.score.toString();
  }

  Widget centerAction(GameState gameState) {
    switch (gameState.status) {
      
      case GameStatus.listen:
        return _centerText('👀', Colors.black);
      case GameStatus.reproduce:
        return _centerText('👇', Colors.black);
      case GameStatus.win:
        return _centerText('😊', Colors.black);
      case GameStatus.loose:
        return _centerText('💔', Colors.black);
      case GameStatus.setup:
      default:
        return RaisedButton(
            onPressed: () => gameEngineBloc.add(GameEvent.startEvent()),
            color: Colors.purple,
            child: const Text('GO !', style: TextStyle(fontSize: 40)));
    }
  }

  bool _isTappable(GameState state) {
    return state.status != GameStatus.listen;
  }

  Widget _centerText(String text, Color backgroundColor) {
    return Container(padding: const EdgeInsets.all(8), 
              child: Center(
                child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 40))));
  }
}
