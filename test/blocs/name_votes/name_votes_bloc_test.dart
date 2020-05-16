import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

class MockNameVotesRepository extends Mock implements NameVotesRepository {}

void main() {
  NameVotesBloc bloc;
  MockNameVotesRepository nameVotesRepository;

  setUp(() {
    nameVotesRepository = MockNameVotesRepository();
    bloc = NameVotesBloc(nameVotesRepository: nameVotesRepository);
  });

  tearDown(() {
    bloc?.close();
  });

  group('NameVotesBloc', () {
    test('should have correct initial state', () {
      expect(bloc.initialState, NameVotesLoading());
    });
  });
}
