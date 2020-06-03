import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/models/user_votes.dart';
import 'package:name_voter/pages/name_list_page.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

// we're mocking the bloc, but we could have more of an integration test by not mocking the bloc, rather the firestore stream
class MockNameVotesBloc extends MockBloc<NameVotesEvent, NameVotesState>
    implements NameVotesBloc {}

// TODO: we can even go a layer deeper here and mock Firebase dependency of the NameVotesRepository
// however since we want to treat the repository as an abstraction, that can just as well be hooked up
// to something like AWS Amplify, a GraphQL or REST back-end, we'll not do it
class MockNameVotesRepository extends Mock implements NameVotesRepository {}

// TODO: mock firestore and create tests through the BloC layer

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name List Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        body: NameListPage(),
      ),
    );
  }
}

void main() {
  group('NameListPage', () {
    testWidgets('renders a loader when the bloc is in NameVotesLoading state',
        (WidgetTester tester) async {
      final MockNameVotesBloc bloc = MockNameVotesBloc();
      whenListen(bloc, Stream.value(NameVotesLoading()));
      when(bloc.state).thenAnswer((_) => NameVotesLoading());

      await tester.pumpWidget(BlocProvider<NameVotesBloc>(
        create: (context) => bloc,
        child: TestWidget(),
      ));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders an empty list of names properly',
        (WidgetTester tester) async {
      final MockNameVotesBloc bloc = MockNameVotesBloc();
      whenListen(bloc, Stream.value(NameVotesLoaded()));
      when(bloc.state).thenAnswer((_) => NameVotesLoaded());

      await tester.pumpWidget(BlocProvider<NameVotesBloc>(
        create: (context) => bloc,
        child: TestWidget(),
      ));
      expect(find.text('No names available to vote'), findsOneWidget);
    });

    testWidgets('renders 2 names with vote counts properly',
        (WidgetTester tester) async {
      final nameVotes = [
        NameVote(id: '123', name: 'Julie', votes: 0),
        NameVote(id: '234', name: 'Anne', votes: 3)
      ];
      final MockNameVotesBloc bloc = MockNameVotesBloc();
      whenListen(bloc, Stream.value(NameVotesLoaded(nameVotes: nameVotes)));
      when(bloc.state).thenAnswer((_) => NameVotesLoaded(nameVotes: nameVotes));

      await tester.pumpWidget(BlocProvider<NameVotesBloc>(
        create: (context) => bloc,
        child: TestWidget(),
      ));
      expect(find.text('Julie'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Anne'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets(
        'renders a checkmark icon next to a name that we already voted for',
        (WidgetTester tester) async {
      final nameVotes = [
        NameVote(id: 'julie', name: 'Julie', votes: 0),
        NameVote(id: 'anne', name: 'Anne', votes: 3),
        NameVote(id: 'jenny', name: 'Jenny', votes: 5)
      ];
      final userVotes = UserVotes(votedNames: {'jenny'});
      final MockNameVotesBloc bloc = MockNameVotesBloc();
      whenListen(
          bloc,
          Stream.value(
              NameVotesLoaded(nameVotes: nameVotes, userVotes: userVotes)));
      when(bloc.state).thenAnswer(
          (_) => NameVotesLoaded(nameVotes: nameVotes, userVotes: userVotes));

      await tester.pumpWidget(BlocProvider<NameVotesBloc>(
        create: (context) => bloc,
        child: TestWidget(),
      ));
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(
          find.byWidgetPredicate(
              (Widget widget) => widget is ListTile && widget.leading != null),
          findsNWidgets(1));
    });

    group('integration tests', () {
      testWidgets(
          'after making a vote, the list displays a star next to an item with user\'s vote',
          (WidgetTester tester) async {
        final nameVotes = [
          NameVote(id: 'julie', name: 'Julie', votes: 0),
          NameVote(id: 'anne', name: 'Anne', votes: 3),
          NameVote(id: 'jenny', name: 'Jenny', votes: 5)
        ];
        final nameVotesRepository = MockNameVotesRepository();
        when(nameVotesRepository.all())
            .thenAnswer((realInvocation) => Stream.value(nameVotes));
        when(nameVotesRepository.my())
            .thenAnswer((realInvocation) => Stream.empty());
        when(nameVotesRepository.recordVote(argThat(anything)))
            .thenAnswer((_) => Future.value());

        final bloc = NameVotesBloc(nameVotesRepository: nameVotesRepository)
          ..add(LoadNameVotes());

        await tester.pumpWidget(BlocProvider<NameVotesBloc>(
          create: (context) => bloc,
          child: TestWidget(),
        ));

        expect(find.byType(ListTile), findsNWidgets(3));
        expect(
            find.byWidgetPredicate((Widget widget) =>
                widget is ListTile && widget.leading != null),
            findsNothing);

        await tester.tap(find.byWidgetPredicate((widget) =>
            widget is ListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Anne'));

        await tester.pump();

        expect(
            find.byWidgetPredicate((Widget widget) =>
                widget is ListTile && widget.leading != null),
            findsNWidgets(1));

        bloc.close();
      });

      // test(
      //     'shows a checkmark icon next to the names the current user has voted on',
      //     () {});
    });
  });
}
