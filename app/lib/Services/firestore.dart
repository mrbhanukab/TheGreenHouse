import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final CollectionReference greenhouses =
      FirebaseFirestore.instance.collection('greenhouses');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Greenhouse>> getGreenhouses() {
    return greenhouses.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Greenhouse.fromFirestore(doc)).toList());
  }

  Stream<List<User>> getUsers() {
    return users.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromFirestore(doc)).toList());
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}

class Greenhouse {
  final String id;
  final String name;
  final int temperature;
  final int humidity;

  Greenhouse({
    required this.id,
    required this.name,
    required this.temperature,
    required this.humidity,
  });

  factory Greenhouse.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Greenhouse(
      id: doc.id,
      name: data['name'] ?? '',
      temperature: data['temperature'] ?? 0,
      humidity: data['humidity'] ?? 0,
    );
  }
}