import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class NameVote extends Equatable {
  final String id;
  final String name;
  final int votes;
  final DocumentReference reference;

  NameVote({this.id, this.name, this.votes, this.reference});

  NameVote.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'],
        id = reference.documentID;

  NameVote.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  NameVote copyWith({String name, int votes}) => NameVote(
      id: this.id,
      name: name ?? this.name,
      votes: votes ?? this.votes,
      reference: this.reference);

  @override
  String toString() => "Record<$name:$votes>";

  @override
  List<Object> get props => ['id', 'name', 'votes'];
}
