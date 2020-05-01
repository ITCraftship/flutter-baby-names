import 'package:flutter/material.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/services/auth/auth.dart';

class NameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final names = Provider.of<NameVotesRepository>(context);

    return StreamBuilder<List<NameVote>>(
      stream: names.all(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<NameVote> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
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
            final names =
                Provider.of<NameVotesRepository>(context, listen: false);
            final userId = await auth.currentUser();
            final name = record.id;
            await names.recordVote(userId, name);
          },
        ),
      ),
    );
  }
}
