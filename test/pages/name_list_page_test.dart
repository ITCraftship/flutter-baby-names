import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/pages/name_list_page.dart';

class MockNameVotesBloc extends MockBloc<NameVotesEvent, NameVotesState>
    implements NameVotesBloc {}

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
  });
}
