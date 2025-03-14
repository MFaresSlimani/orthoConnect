import 'package:ortho_connect/classes/visit.dart';

class Patient {
  final String picture;
  final String name;
  final String cardId;
  final DateTime birthDate;
  final List<Visit> visits;

  Patient({
    required this.picture,
    required this.name,
    required this.cardId,
    required this.birthDate,
    this.visits = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'picture': picture,
      'name': name,
      'cardId': cardId,
      'birthDate': birthDate.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      picture: map['picture'],
      name: map['name'],
      cardId: map['cardId'], // No need for parsing since it's already an int
      birthDate: DateTime.parse(map['birthDate']),
      visits: List<Visit>.from((map['visits'] ?? []).map((visit) => Visit.fromMap(visit))),
    );
  }
}
