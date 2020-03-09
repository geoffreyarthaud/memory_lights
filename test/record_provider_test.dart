import 'package:memory_lights/src/utils/record_provider.dart';
import 'package:test/test.dart';

RecordProvider recordProvider;

void main() {

  setUp(() {
    recordProvider = RecordProvider();
  });

  testCorrectGetWithNumbers([1,4,45], [3,4,10]);
  testErrorGet(-2, 4);
  testErrorGet(2, -3);
  testErrorGet(0, 4);
  testErrorGet(2, 0);

}


void testErrorGet(int nbRecords, int nbCells) {
  test('Get $nbRecords records from $nbCells cells should throw an error', () {
    expect(() => recordProvider.get(nbRecords,nbCells), throwsArgumentError);
  });
}
  
void testCorrectGetWithNumbers(List<int> nbRecordsList, List<int> nbCellsList) {
  for (int nbRecords in nbRecordsList) {
    for(int nbCells in nbCellsList) {
    test('Get $nbRecords records from $nbCells cells should returns list of $nbRecords ints from 1 to $nbCells',() {
      List<int> record = recordProvider.get(nbRecords, nbCells);
      expect(record, hasLength(nbRecords));
      expect(record, containsAll([lessThan(nbCells + 1)]));
      expect(record, containsAll([greaterThan(0)]));
    });
  }
}
}
