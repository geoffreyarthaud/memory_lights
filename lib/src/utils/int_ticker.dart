class IntTicker {
  static Stream<int> tick(List<int> notes, int duration) {
    int index = 0;
    List<int> notesAndPauses = List(notes.length*2);
    for(int i = 0; i < notes.length; i++) {
      notesAndPauses[2*i] = notes[i];
      notesAndPauses[2*i + 1] = 0;
    }
    return Stream.periodic(Duration(milliseconds: duration ~/ 2), (_) => notesAndPauses[index++])
      .take(notesAndPauses.length);
  }
}
