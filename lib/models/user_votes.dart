import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserVotes extends Equatable {
  final Set<String> votedNames;

  UserVotes({Set<String> votedNames}) : votedNames = votedNames ?? {};

  bool hasVote(String name) {
    return votedNames.contains(name);
  }

  const UserVotes.fromSet(this.votedNames);

  UserVotes.fromSnapshot(QuerySnapshot snapshot)
      : this.fromSet(snapshot.documents.map((doc) => doc.documentID).toSet());

  UserVotes copyWithout(String name) {
    return UserVotes(votedNames: {
      ...votedNames.where((element) => element != name).toSet()
    });
  }

  @override
  List<Object> get props => [votedNames];
}
