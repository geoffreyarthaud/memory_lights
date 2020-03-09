class IntTicker {
  static Stream<int> tick(List<int> notes, int duration) {
    int index = 0;
    notes.add(0);
    return Stream.periodic(Duration(milliseconds: duration), (_) => notes[index++])
      .take(notes.length);
  }
}
