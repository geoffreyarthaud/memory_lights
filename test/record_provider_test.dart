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
  testErrorGet(-1, 4);
  testErrorGet(2, 0);

  test('Get new record from existent list', () {
    // GIVEN
    List<int> from = [4,5,2,1];
    List<int> record = recordProvider.get(5, 5, from: from);
    expect(record, hasLength(5));
    expect(record.sublist(0,4), from);
    expect(record[4], lessThan(6));
    expect(record[4], greaterThan(0));
  });

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
