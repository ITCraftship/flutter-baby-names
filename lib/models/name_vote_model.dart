import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NameVote extends Equatable {
  final String id;
  final String name;
  final int votes;
  final DocumentReference reference;

  const NameVote({this.id, this.name, this.votes, this.reference});

  NameVote.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'] as String,
        votes = map['votes'] as int,
        id = reference.documentID;

  NameVote.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  NameVote copyWith({String name, int votes}) => NameVote(
      id: id,
      name: name ?? this.name,
      votes: votes ?? this.votes,
      reference: reference);

  @override
  String toString() => "Record<$name:$votes>";

  @override
  List<Object> get props => [id, name, votes];
}
