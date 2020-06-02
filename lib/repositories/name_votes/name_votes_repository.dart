import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:name_voter/models/name_vote_model.dart';
import 'package:name_voter/models/user_votes.dart';

abstract class NameVotesRepository {
  Stream<List<NameVote>> all();
  Stream<UserVotes> my();
  Future<void> recordVote(String name);
  Future<void> withdrawVote(String name);
}

// TODO: we can implement more repositories using for example:
// GraphQL, REST, AWS Amplify – this will help determine whether the BloC we implemented
// is abstract enough to support different integration patterns

class FirestoreNameVotesRepository extends NameVotesRepository {
  final String _userId;
  Firestore _firestore = Firestore.instance;

  FirestoreNameVotesRepository(this._userId);

  @override
  Stream<List<NameVote>> all() {
    return _firestore.collection('baby').snapshots().map((event) =>
        event.documents.map((doc) => NameVote.fromSnapshot(doc)).toList());
  }

  @override
  Stream<UserVotes> my() {
    return _firestore
        .collection('votes')
        .document(_userId)
        .collection('names')
        .snapshots()
        .map((event) => UserVotes.fromSnapshot(event));
  }

  @override
  Future<void> recordVote(String name) async {
    await _firestore
        .collection('votes')
        .document(_userId)
        .collection('names')
        .document(name)
        .setData({'vote': true});
  }

  @override
  Future<void> withdrawVote(String name) async {
    await _firestore
        .collection('votes')
        .document(_userId)
        .collection('names')
        .document(name)
        .delete();
  }
}
