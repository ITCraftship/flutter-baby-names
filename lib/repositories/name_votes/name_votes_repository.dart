import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:name_voter/models/name_vote_model.dart';

abstract class NameVotesRepository {
  Stream<List<NameVote>> all();
  Future<void> recordVote(String userId, String name);
}

class FirestoreNameVotesRepository extends NameVotesRepository {
  Firestore _firestore = Firestore.instance;
  @override
  Stream<List<NameVote>> all() {
    return _firestore.collection('baby').snapshots().map((event) =>
        event.documents.map((doc) => NameVote.fromSnapshot(doc)).toList());
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
