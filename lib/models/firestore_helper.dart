import 'package:cloud_firestore/cloud_firestore.dart';

void addNationalAssemblyVote(int index) async {
  final DocumentReference postRef =
      Firestore.instance.document('polls/NationalAssemblyPoll');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);

    postSnapshot.data['pollOptions'][index]['numberOfVotes'] += 1;

    if (postSnapshot.exists) {
      await tx.update(postRef,
          <String, dynamic>{'pollOptions': postSnapshot.data['pollOptions']});
    }
  });
}
