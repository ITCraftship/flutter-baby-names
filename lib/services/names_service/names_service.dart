import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:name_voter/models/name_record_model.dart';

abstract class NamesServiceBase {
  Stream<List<NameRecord>> all();
  Future<void> recordVote(String userId, String name);
}

class NamesService extends NamesServiceBase {
  Firestore _firestore = Firestore.instance;
  @override
  Stream<List<NameRecord>> all() {
    return _firestore.collection('baby').snapshots().map((event) =>
        event.documents.map((doc) => NameRecord.fromSnapshot(doc)).toList());
  }

  @override
  Future<void> recordVote(String userId, String name) async {
    await _firestore
        .collection('votes')
        .document(userId)
        .collection('names')
        .document(name)
        .setData({'vote': true});
  }
}
