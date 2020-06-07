import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes.dart';
import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/models/user_votes.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

class MockNameVotesRepository extends Mock implements NameVotesRepository {}

void main() {
  MockNameVotesRepository nameVotesRepository;

  setUp(() {
    nameVotesRepository = MockNameVotesRepository();
  });

  group('NameVotesBloc', () {
    final nameVotes = [
      const NameVote(id: 'one', name: 'George', votes: 5),
      const NameVote(id: 'two', name: 'Ben', votes: 2)
    ];

    const userVotes = UserVotes.fromSet({'jenny', 'moira'});

    blocTest(
        'subscribes to all() and my() vites of the repository on LoadNameVotes event',
        build: () async {
          when(nameVotesRepository.all())
              .thenAnswer((realInvocation) => const Stream.empty());
          when(nameVotesRepository.my())
              .thenAnswer((realInvocation) => const Stream.empty());
          return NameVotesBloc(nameVotesRepository: nameVotesRepository);
        },
        act: (bloc) async => bloc.add(LoadNameVotes()),
        verify: (_) async {
          verify(nameVotesRepository.all()).called(1);
          verify(nameVotesRepository.my()).called(1);
        });

    // this is more of an integration test, so we're publishing
    // on the underlying stream and checking if the block correctly maps the event and
    // emits the proper state
    // we could even integrate more layers – i.e. mock the firestore streams and use real repo implementation
    // however this will only work when publishing on the first subscription
    // see the test for publishing my votes – it is skipped, because it doesn't work
    blocTest(
        'emits [NameVotesLoaded] with name votes when the name votes repository publishes all votes',
        build: () async {
          when(nameVotesRepository.all())
              .thenAnswer((realInvocation) => Stream.value(nameVotes));
          when(nameVotesRepository.my())
              .thenAnswer((realInvocation) => const Stream.empty());
          return NameVotesBloc(nameVotesRepository: nameVotesRepository);
        },
        act: (bloc) async => bloc.add(LoadNameVotes()),
        wait: const Duration(), // need to add wait, so that the listen on all() adds an event to the block
        expect: [NameVotesLoaded(nameVotes: nameVotes)]);

    // the blocTest doesn't yet allow to wait for all times, so to test
    // if the internal stream subscriptions work properly and actually publish
    // accurate events and then states, we're using fake_async library and flushing all times in the "act" callback
    fakeAsync((async) {
      blocTest(
          'emits [NameVotesLoaded] with user votes when the name votes repository publishes my votes',
          build: () async {
        when(nameVotesRepository.all())
            .thenAnswer((realInvocation) => const Stream.empty());
        when(nameVotesRepository.my())
            .thenAnswer((realInvocation) => Stream.value(userVotes));
        return NameVotesBloc(nameVotesRepository: nameVotesRepository);
      }, act: (bloc) async {
        bloc.add(LoadNameVotes());
        async.flushTimers();
      },
          wait: const Duration(),
          expect: [NameVotesLoaded(userVotes: userVotes)]);
    });

    fakeAsync((async) {
      blocTest(
          'emits [NameVotesLoaded, NameVotesLoaded] with name and user votes when the name votes repository publishes all votes and my votes',
          build: () async {
        when(nameVotesRepository.all())
            .thenAnswer((realInvocation) => Stream.value(nameVotes));
        when(nameVotesRepository.my())
            .thenAnswer((realInvocation) => Stream.value(userVotes));
        return NameVotesBloc(nameVotesRepository: nameVotesRepository);
      }, act: (bloc) async {
        bloc.add(LoadNameVotes());
        async.flushTimers();
      }, wait: const Duration(), expect: [
        NameVotesLoaded(nameVotes: nameVotes),
        NameVotesLoaded(nameVotes: nameVotes, userVotes: userVotes)
      ]);
    });

    // TODO: test that when the user has already submitted a vote, there will be no update of vote count

    blocTest(
        "publishes [NameVotesLoaded] with the new vote when the submitted name vote didn't exist",
        build: () async {
          when(nameVotesRepository.all())
              .thenAnswer((realInvocation) => const Stream.empty());
          when(nameVotesRepository.my())
              .thenAnswer((realInvocation) => const Stream.empty());
          when(nameVotesRepository.recordVote(argThat(anything)))
              .thenAnswer((_) => Future.value());
          return NameVotesBloc(nameVotesRepository: nameVotesRepository);
        },
        act: (bloc) async {
          final nameVotes = [
            const NameVote(id: 'bonnie', name: 'Bonnie', votes: 5),
            const NameVote(id: 'clyde', name: 'Clyde', votes: 2)
          ];
          const userVotes = UserVotes.fromSet({'bonnie', 'clyde'});
          bloc.add(UpdateNameVotes(nameVotes));
          bloc.add(const UpdateUserVotes(userVotes));
          return bloc.add(const SubmitNameVote(
              NameVote(id: 'carrie', name: 'Carrie', votes: 1)));
        },
        skip: 4,
        wait: const Duration(seconds: 1),
        expect: [
          NameVotesLoaded(nameVotes: const [
            NameVote(id: 'bonnie', name: 'Bonnie', votes: 5),
            NameVote(id: 'carrie', name: 'Carrie', votes: 1),
            NameVote(id: 'clyde', name: 'Clyde', votes: 2)
          ], userVotes: const UserVotes.fromSet({'bonnie', 'carrie', 'clyde'}))
        ],
        verify: (NameVotesBloc bloc) async {
          final state = NameVotesLoaded(nameVotes: const [
            NameVote(id: 'bonnie', name: 'Bonnie', votes: 5),
            NameVote(id: 'carrie', name: 'Carrie', votes: 1),
            NameVote(id: 'clyde', name: 'Clyde', votes: 2)
          ], userVotes: const UserVotes.fromSet({'bonnie', 'carrie', 'clyde'}));
          expect(bloc.state == state, isTrue);
        });
  });
}
