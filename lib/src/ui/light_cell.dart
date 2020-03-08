import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/events.dart';

@injectable
class LightCell extends StatelessWidget {
  final int id;

  final Color color;

  final Color highlight;

  final FlutterMidi flutterMidi;

  final int note;

  LightCell(@factoryParam LightCellProperties props, this.flutterMidi) :
  id = props.id,
  color = props.color,
  highlight = props.highlight,
  note = props.note;

  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    final LightBloc lightBloc = BlocProvider.of<LightBloc>(context);

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        lightBloc.add(GestureEvent.onEvent(id));
      },
      onTapUp : (TapUpDetails details) {
        lightBloc.add(GestureEvent.offEvent());
      },
      onTapCancel : () {
        lightBloc.add(GestureEvent.offEvent());
      },
      child: BlocBuilder<LightBloc, int>(builder: (context, lightId) {
        if (lightId == id) {
          flutterMidi.playMidiNote(midi: note);
        } else if(lightId == 0) {
          flutterMidi.stopMidiNote(midi: note);
        }
        return Container(
          color: lightId == id ? highlight : color,
          child: Icon(
            Icons.touch_app,
            color: lightId == id ? Colors.black : Colors.white,
          ),
        );
      }));
  }
}

class LightCellProperties {
  final int id;

  final Color color;

  final Color highlight;

  final int note;

  LightCellProperties(this.id, this.color, this.highlight, this.note);
  
}
