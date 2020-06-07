import 'package:flutter_test/flutter_test.dart';
import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/models/user_votes.dart';

void main() {
  group('NameVotesState substate', () {
    group('NameVotesLoaded should', () {
      test('be equal when all items in the name votes array are the same', () {
        const votes1 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state1 = NameVotesLoaded(nameVotes: votes1);
        const votes2 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state2 = NameVotesLoaded(nameVotes: votes2);
        expect(state1 == state2, isTrue);
      });

      test('not be equal when items in the name votes array are different', () {
        const votes1 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcd', name: 'Name 2', votes: 5)
        ];
        final state1 = NameVotesLoaded(nameVotes: votes1);
        const votes2 = [
          NameVote(id: 'abc', name: 'Name 1', votes: 1),
          NameVote(id: 'abcde', name: 'Name 3', votes: 9)
        ];
        final state2 = NameVotesLoaded(nameVotes: votes2);
        expect(state1 == state2, isFalse);
      });

      test('be equal when user votes contain the same names', () {
        final userVotes1 = UserVotes(votedNames: const {'suzie', 'jenny'});
        final state1 = NameVotesLoaded(userVotes: userVotes1);
        final userVotes2 = UserVotes(votedNames: const {'suzie', 'jenny'});
        final state2 = NameVotesLoaded(userVotes: userVotes2);
        expect(state1 == state2, isTrue);
      });

      test("not be equal when user votes don't contain the same names", () {
        final userVotes1 = UserVotes(votedNames: const {'suzie', 'jenny'});
        final state1 = NameVotesLoaded(userVotes: userVotes1);
        final userVotes2 = UserVotes(votedNames: const {'annie', 'nina'});
        final state2 = NameVotesLoaded(userVotes: userVotes2);
        expect(state1 == state2, isFalse);
      });

      test('be equal when user votes and name votes are the same', () {
        final state1 = NameVotesLoaded(nameVotes: const [
          NameVote(id: 'bonnie', name: 'Bonnie', votes: 5),
          NameVote(id: 'carrie', name: 'Carrie', votes: 1),
          NameVote(id: 'clyde', name: 'Clyde', votes: 2)
        ], userVotes: const UserVotes.fromSet({'bonnie', 'carrie,' 'clyde'}));

        final state2 = NameVotesLoaded(nameVotes: const [
          NameVote(id: 'bonnie', name: 'Bonnie', votes: 5),
          NameVote(id: 'carrie', name: 'Carrie', votes: 1),
          NameVote(id: 'clyde', name: 'Clyde', votes: 2)
        ], userVotes: const UserVotes.fromSet({'bonnie', 'carrie,' 'clyde'}));

        expect(state1 == state2, isTrue);
      });
    });
  });
}
