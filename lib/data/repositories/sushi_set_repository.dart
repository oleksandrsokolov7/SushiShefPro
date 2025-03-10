import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sushi_set_model.dart';

class SushiSetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SushiSet>> loadSets(
      {required String userId, required bool own}) async {
    QuerySnapshot snapshot;

    if (own) {
      snapshot = await _firestore
          .collection('sets')
          .where('owner', isEqualTo: userId)
          .get();
    } else {
      snapshot = await _firestore.collection('sets').get();
    }

    return snapshot.docs.map((doc) {
      return SushiSet.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> saveSet(SushiSet set) async {
    await _firestore.collection('sets').add(set.toFirestore());
  }
}
