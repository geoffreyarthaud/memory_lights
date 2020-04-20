import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:injectable/injectable.dart';

import 'package:memory_lights/src/blocs/events.dart';
import 'package:memory_lights/src/blocs/light_bloc.dart';
import 'package:memory_lights/src/blocs/play_record_bloc.dart';
import 'package:memory_lights/src/blocs/play_state.dart';
import 'package:memory_lights/src/utils/midi_player.dart';

@injectable
class LightCell extends StatelessWidget {
  final int id;

  final Color color;

  final Color highlight;

  final MidiPlayer flutterMidi;

  final int note;

  final bool tappable;

  final LightBloc lightBloc;

  final PlayRecordBloc playBloc;

  LightCell(@factoryParam LightCellProperties props, this.flutterMidi, this.lightBloc, this.playBloc)
      : id = props.id,
        color = props.color,
        highlight = props.highlight,
        note = props.note,
        tappable = props.tappable;

  @override
  Widget build(BuildContext context) {
    return tappable ? _buildTappable(context) : _buildNonTappable(context);
  }

  Widget _buildTappable(BuildContext context) {
    //ignore: close_sinks
    final LightBloc lightBloc = BlocProvider.of<LightBloc>(context);

    return GestureDetector(onTapDown: (TapDownDetails details) {
      lightBloc.add(GestureEvent.onEvent(id));
    }, onTapUp: (TapUpDetails details) {
      lightBloc.add(GestureEvent.offEvent());
    }, onTapCancel: () {
      lightBloc.add(GestureEvent.offEvent());
    }, child: BlocBuilder<LightBloc, int>(
      bloc: lightBloc,
      builder: (context, lightId) {
      if (lightId == id) {
        flutterMidi.playMidiNote(midi: note);
      } else if (lightId == 0) {
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

  Widget _buildNonTappable(BuildContext context) {
    return BlocBuilder<PlayRecordBloc, PlayState>(
      bloc : playBloc,
      builder: (context, playState) {
        bool shouldPlay = playState is Playing && playState.note == id;
      if (shouldPlay) {
        flutterMidi.playMidiNote(midi: note);
      } else {
        flutterMidi.stopMidiNote(midi: note);
      }
      return Container(
        color: shouldPlay ? highlight : color
      );
    });
  }

  handleError() {
  }
}

class LightCellProperties {
  final int id;

  final Color color;

  final Color highlight;

  final int note;

  final bool tappable;

  LightCellProperties(this.id, this.color, this.highlight, this.note,
      {this.tappable = true});

  LightCellProperties copyWith({
    int id,
    Color color,
    Color highlight,
    int note,
    bool tappable,
  }) {
    return LightCellProperties(
      id ?? this.id,
      color ?? this.color,
      highlight ?? this.highlight,
      note ?? this.note,
      tappable: tappable ?? this.tappable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color.value,
      'highlight': highlight.value,
      'note': note,
      'tappable': tappable,
    };
  }

  static LightCellProperties fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LightCellProperties(
      map['id'],
      Color(map['color']),
      Color(map['highlight']),
      map['note'],
      tappable: map['tappable'],
    );
  }

  String toJson() => json.encode(toMap());

  static LightCellProperties fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'LightCellProperties(id: $id, color: $color, highlight: $highlight, note: $note, tappable: $tappable)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LightCellProperties &&
        o.id == id &&
        o.color == color &&
        o.highlight == highlight &&
        o.note == note &&
        o.tappable == tappable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        color.hashCode ^
        highlight.hashCode ^
        note.hashCode ^
        tappable.hashCode;
  }
}
