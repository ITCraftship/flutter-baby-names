import 'package:cloud_firestore/cloud_firestore.dart';

class NameRecord {
  final String id;
  final String name;
  final int votes;
  final DocumentReference reference;

  NameRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'],
        id = reference.documentID;

  NameRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
