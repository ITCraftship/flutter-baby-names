import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/services/auth/auth.dart';

class NameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameVotesBloc, NameVotesState>(
      builder: (context, state) {
        if (state is NameVotesLoading) {
          return LinearProgressIndicator();
        }
        if (state is NameVotesLoaded) {
          return _buildList(context, state.votes);
        }
        return Text('Uknown state');
      },
    );
  }

  Widget _buildList(BuildContext context, List<NameVote> votes) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: votes.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, NameVote record) {
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () async {
            final auth = Provider.of<BaseAuth>(context, listen: false);
            final userId = await auth.currentUser();
            BlocProvider.of<NameVotesBloc>(context)
                .add(SubmitNameVote(userId, record));
          },
        ),
      ),
    );
  }
}
