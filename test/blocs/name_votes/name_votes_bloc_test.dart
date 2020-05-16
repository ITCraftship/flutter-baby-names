import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes.dart';
import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

class MockNameVotesRepository extends Mock implements NameVotesRepository {}

void main() {
  MockNameVotesRepository nameVotesRepository;

  setUp(() {
    nameVotesRepository = MockNameVotesRepository();
  });

  group('NameVotesBloc', () {
    final nameVotes = [
      NameVote(id: 'one', name: 'George', votes: 5, reference: null),
      NameVote(id: 'two', name: 'Ben', votes: 2, reference: null)
    ];

    blocTest(
        'subscribes to all() and my() vites of the repository on LoadNameVotes event',
        build: () async {
          when(nameVotesRepository.all())
              .thenAnswer((realInvocation) => Stream.empty());
          when(nameVotesRepository.my())
              .thenAnswer((realInvocation) => Stream.empty());
          return NameVotesBloc(nameVotesRepository: nameVotesRepository);
        },
        act: (bloc) => bloc.add(LoadNameVotes()),
        verify: (_) async {
          verify(nameVotesRepository.all()).called(1);
          verify(nameVotesRepository.my()).called(1);
        });

    // this is more of an integration test, so we're publishing
    // on the underlying stream and checking if the block correctly maps the event and
    // emits the proper state
    // we could even integrate more layers – i.e. mock the firestore streams and use real repo implementation
    blocTest(
        'emits [NameVotesLoaded] when the name votes repository publishes all votes',
        build: () async {
          when(nameVotesRepository.all())
              .thenAnswer((realInvocation) => Stream.value(nameVotes));
          when(nameVotesRepository.my())
              .thenAnswer((realInvocation) => Stream.empty());
          return NameVotesBloc(nameVotesRepository: nameVotesRepository);
        },
        act: (bloc) => bloc.add(LoadNameVotes()),
        wait: const Duration(milliseconds: 0), // need to add wait, so that the listen on all() adds an event to the block
        expect: [NameVotesLoaded(nameVotes: nameVotes)]);
  });
}
