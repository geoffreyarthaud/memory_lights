import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sealed_unions/sealed_unions.dart';
import 'package:flutter_midi/flutter_midi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FlutterMidi flutterMidi = FlutterMidi();
  // This widget is the root of your application.

  MyApp() {

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<LightBloc>(
          create: (context) => LightBloc(),
          child: MyHomePage(title: 'Memory lights'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final FlutterMidi flutterMidi = FlutterMidi();

  MyHomePage({Key key, this.title}) : super(key: key) {
    flutterMidi.unmute();
    rootBundle.load("assets/Piano.sf2").then((sf2) {
      flutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
    });
  }

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                _emptyCell(),
                LightCell(1, Colors.green[400], Colors.green[100], flutterMidi, 288),
                _emptyCell(),
                LightCell(2, Colors.blue[400], Colors.blue[100], flutterMidi, 288),
                _emptyCell(),
                LightCell(3, Colors.red[400], Colors.red[100], flutterMidi, 288),
                _emptyCell(),
                LightCell(4, Colors.orange[400], Colors.orange[100], flutterMidi, 288),
                _emptyCell(),
              ],
            ));
  }

  Container _emptyCell() => Container(padding: const EdgeInsets.all(8));
}

class LightCell extends StatelessWidget {
  final int id;

  final Color color;

  final Color highlight;

  final FlutterMidi flutterMidi;

  final int note;

  LightCell(this.id, this.color, this.highlight, this.flutterMidi, this.note);

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
        } else if(lightId == -1) {
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

class OffEvent {}

class OnEvent {
  final int cell;

  OnEvent(this.cell);
}

class GestureEvent {
  Union2<OffEvent, OnEvent> type;

  static Doublet<OffEvent, OnEvent> _factory = Doublet<OffEvent, OnEvent>();

  static GestureEvent _offEvent =
      GestureEvent._internal(Doublet<OffEvent, OnEvent>().first(OffEvent()));

  factory GestureEvent.onEvent(int cell) =>
      GestureEvent._internal(_factory.second(OnEvent(cell)));

  factory GestureEvent.offEvent() => _offEvent;

  GestureEvent._internal(this.type);
}

class LightBloc extends Bloc<GestureEvent, int> {
  @override
  int get initialState => -1;

  @override
  Stream<int> mapEventToState(GestureEvent event) async* {
    yield event.type.join(
        (e) => -1, // UnTapEvent
        (e) => e.cell); // TapEvent
  }
}
