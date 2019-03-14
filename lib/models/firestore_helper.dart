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


void addProvincialAssemblyVote(int index) async{
    final DocumentReference postRef =
      Firestore.instance.document('polls/ProvincialAssemblyPoll');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);

    postSnapshot.data['pollOptionsSindh'][index]['numberOfVotes'] += 1;

    if (postSnapshot.exists) {
      await tx.update(postRef,
          <String, dynamic>{'pollOptionsSindh': postSnapshot.data['pollOptionsSindh']});
    }
  });
}

class FirebaseResponse {
  final String color;
  final String flag;
  final String fullName;
  final String initials;
  final int numberOfVoters;
  final DocumentReference reference;

  FirebaseResponse.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['color'] != null),
        assert(map['flag'] != null),
        assert(map['fullName'] != null),
        assert(map['initials'] != null),
        color = map['color'],
        flag = map['flag'],
        fullName = map['fullName'],
        initials = map['initials'],
        numberOfVoters = map['numberOfVoters'];
}