import 'dart:math';

import 'package:quiver/check.dart';

class RecordProvider {
  final random = Random();

  List<int> get(int nbRecords, int nbCells) {
    checkArgument(nbRecords > 0);
    checkArgument(nbCells > 0);
    return List.generate(nbRecords, (_) => random.nextInt(nbCells) + 1);
  }
}