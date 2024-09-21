import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<String>> getUserGreenhousesStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      return List<String>.from(doc.data()?['greenhouses'] ?? []);
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getGreenHouseInfoStream(String greenhouseId) {
    return _db.collection('greehouses').doc(greenhouseId).snapshots();
  }

  Stream<List<Map<String, dynamic>>> getAlertsStream(String greenhouseId) {
    return _db.collection('greehouses').doc(greenhouseId).collection('alerts & logs').orderBy(FieldPath.documentId, descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(doc.id) * 1000, isUtc: true).add(const Duration(hours: 5, minutes: 30));
        final formattedTimestamp = DateFormat('🗓️ yyyy-MM-dd ⌚ HH:mm').format(timestamp);
        return {
          'message': doc.data()['msg'],
          'timestamp': formattedTimestamp,
        };
      }).toList();
    });
  }

  Future<void> updateForcedLight(String greenhouseId, bool forcedLight) async {
    await _db.collection('greehouses').doc(greenhouseId).update({
      'forced light': forcedLight,
    });
  }

Future<void> updateEnvironmentLimits(String greenhouseId, int temperature, int humidity) async {
  final docRef = _db.collection('greehouses').doc(greenhouseId);
  await docRef.update({
    'environment limits.temperature': temperature,
    'environment limits.humidity': humidity,
  });
}

  Future<void> updatePlantMoistureLimit(String greenhouseId, String plantName, int moistureLimit) async {
    await _db.collection('greehouses').doc(greenhouseId).update({
      'environment limits.moisture.$plantName': moistureLimit,
    });
  }

}