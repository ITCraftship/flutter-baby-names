import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:name_voter/models/name_record_model.dart';
import 'package:name_voter/services/auth/auth.dart';
import 'package:name_voter/services/auth/auth_provider.dart';

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
                  Auth auth = AuthProvider.of(context).auth;
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
    return StreamBuilder<QuerySnapshot>(
      // TODO: create the Firestore instance from the app:
      // https://stackoverflow.com/questions/57015539/flutter-firestore-authentication
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = NameRecord.fromSnapshot(data);

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
            Auth auth = AuthProvider.of(context).auth;
            final userId = await auth.currentUser();
            final name = record.id;
            // TODO: the votes are updated through functions hooks, so on the UI let's set the state
            // immediately and then wait for it to re-render (ex. someone else voted)
            // if the data coming from FB is the same, the UI won't update anyways
            await Firestore.instance
                .collection('votes')
                .document(userId)
                .collection('names')
                .document(name)
                .setData({'vote': true});
          },
        ),
      ),
    );
  }
}
