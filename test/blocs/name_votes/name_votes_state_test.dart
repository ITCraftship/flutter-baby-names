import 'package:flutter_test/flutter_test.dart';
import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/models/name_vote_model.dart';

void main() {
  group('NameVotesState substate', () {
    group('NameVotesLoaded should', () {
      test('be equal when all items in the array are the same', () {
        final votes1 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state1 = NameVotesLoaded(votes1);
        final votes2 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state2 = NameVotesLoaded(votes2);
        expect(state1 == state2, isTrue);
      });

      test('not be equal when items in the array are different', () {
        final votes1 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state1 = NameVotesLoaded(votes1);
        final votes2 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcde', name: 'Name 3', votes: 9)
        ];
        final state2 = NameVotesLoaded(votes2);
        expect(state1 == state2, isTrue);
      });
    });
  });
}
