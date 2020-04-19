import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/services/names_service/names_service.dart';
import 'package:name_voter/models/name_record_model.dart';
import 'package:name_voter/services/auth/auth.dart';

class NameListPage extends StatefulWidget {
  @override
  _NameListPageState createState() {
    return _NameListPageState();
  }
}

class _NameListPageState extends State<NameListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baby Name Votes'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                try {
                  final auth = Provider.of<BaseAuth>(context, listen: false);
                  await auth.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Sign out'))
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final namesService = Provider.of<NamesServiceBase>(context);

    return StreamBuilder<List<NameRecord>>(
      stream: namesService.all(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<NameRecord> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, NameRecord record) {
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
            final namesService =
                Provider.of<NamesServiceBase>(context, listen: false);
            final userId = await auth.currentUser();
            final name = record.id;
            await namesService.recordVote(userId, name);
          },
        ),
      ),
    );
  }
}
