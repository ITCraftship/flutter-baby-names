import 'package:flutter_test/flutter_test.dart';
import 'package:name_voter/models/name_vote_model.dart';

void main() {
  group('NameVote should', () {
    test('be equal when id, name and votes are equeal', () {
      final record1 = NameVote(id: '123', name: 'Test', votes: 4);
      final record2 = NameVote(id: '123', name: 'Test', votes: 4);
      expect(record1 == record2, isTrue);
    });

    test('be equal when any of id, name and votes are not equeal', () {
      final record1 = NameVote(id: '123', name: 'Test', votes: 4);
      final record2 = NameVote(id: '123', name: 'Test 1', votes: 4);
      final record3 = NameVote(id: '1234', name: 'Test', votes: 4);
      final record4 = NameVote(id: '123', name: 'Test', votes: 9);
      expect(record1 == record2, isFalse);
      expect(record1 == record3, isFalse);
      expect(record1 == record4, isFalse);
    });
  });
}
