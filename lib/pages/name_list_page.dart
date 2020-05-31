import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:name_voter/models/user_votes.dart';

class NameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameVotesBloc, NameVotesState>(
      builder: (context, state) {
        if (state is NameVotesLoading) {
          return LinearProgressIndicator();
        }
        if (state is NameVotesLoaded) {
          return _buildList(context, state.nameVotes, state.userVotes);
        }
        return Text('Uknown state');
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<NameVote> votes, UserVotes userVotes) {
    return votes.length > 0
        ? buildVotesPage(context, votes, userVotes)
        : Center(
            child: Text('No names available to vote'),
          );
  }

  Widget buildVotesPage(
      BuildContext context, List<NameVote> votes, UserVotes userVotes) {
    return Column(
      children: [
        Expanded(
            child: ListView(
                padding: const EdgeInsets.only(top: 20.0),
                children: votes
                    .map((data) => _buildListItem(
                        context, data, userVotes.hasVote(data.id)))
                    .toList())),
        buildProposeButton(context),
      ],
    );
  }

  Widget buildProposeButton(BuildContext context) {
    final proposeNameHandler = (String name) {
      BlocProvider.of<NameVotesBloc>(context).add(SubmitNameVote(
          NameVote(id: name.toLowerCase(), name: name, votes: 0)));
    };

    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RaisedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return NewNameDialog(
                    onNamePropose: proposeNameHandler,
                  );
                },
              );
            },
            child: Text('Propose a new name'),
          ),
        ))
      ],
    );
  }

  Widget _buildListItem(
      BuildContext context, NameVote record, bool alreadyVoted) {
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: alreadyVoted ? Icon(Icons.star_border) : null,
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () async {
            BlocProvider.of<NameVotesBloc>(context).add(SubmitNameVote(record));
          },
        ),
      ),
    );
  }
}

class NewNameDialog extends StatefulWidget {
  final Function(String) onNamePropose;
  final Function onCancel;

  const NewNameDialog({Key key, this.onNamePropose, this.onCancel})
      : super(key: key);

  @override
  _NewNameDialogState createState() =>
      _NewNameDialogState(onCancel: onCancel, onNamePropose: onNamePropose);
}

class _NewNameDialogState extends State<NewNameDialog> {
  final Function(String) onNamePropose;
  final Function onCancel;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final newNameTextController = TextEditingController();

  _NewNameDialogState({this.onNamePropose, this.onCancel});

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Propose new name'),
      content: TextField(
        controller: newNameTextController,
      ),
      actions: [
        FlatButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        RaisedButton(
          onPressed: () {
            onNamePropose?.call(newNameTextController.text);
            Navigator.of(context).pop();
          },
          child: Text('Propose'),
        )
      ],
    );
  }
}
