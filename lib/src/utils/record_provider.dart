import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:quiver/check.dart';

@singleton
class RecordProvider {
  final random = Random();

  List<int> get(int nbRecords, int nbCells, {List<int> from}) {
    List<int> initFrom = from ?? [];
    checkArgument(nbRecords >= initFrom.length);
    checkArgument(nbCells > 0);
    return initFrom + List.generate(nbRecords - initFrom.length, (_) => random.nextInt(nbCells) + 1);
  }
}