import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/pages/name_list_page.dart';

// we're mocking the bloc, but we could have more of an integration test by not mocking the bloc, rather the firestore stream
class MockNameVotesBloc extends MockBloc<NameVotesEvent, NameVotesState>
    implements NameVotesBloc {}

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
    testWidgets('render a loader when the bloc is in NameVotesLoading state',
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
  });
}
