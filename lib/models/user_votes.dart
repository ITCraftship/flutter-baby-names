import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserVotes extends Equatable {
  final Set<String> votedNames;

  UserVotes({votedNames}) : this.votedNames = votedNames ?? {};

  hasVote(String name) {
    return votedNames.contains(name);
  }

  UserVotes.fromSet(this.votedNames);

  UserVotes.fromSnapshot(QuerySnapshot snapshot)
      : this.fromSet(snapshot.documents.map((doc) => doc.documentID).toSet());

  @override
  List<Object> get props => [votedNames];
}
