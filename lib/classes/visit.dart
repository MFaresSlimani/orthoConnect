import 'package:flutter/material.dart';

class Visit {
  final String visitDate; // Changed type to String
  final String visitTime; // Changed type to String
  final String illnessType;
  final String notes;
  final String cardId;

  Visit({
    required this.visitDate,
    required this.visitTime,
    required this.illnessType,
    required this.notes,
    required this.cardId,
  });

  Map<String, dynamic> toMap(String patientCardId) {
    return {
      'visitDate': visitDate,
      'visitTime': visitTime,
      'illnessType': illnessType,
      'notes': notes,
      'cardId': patientCardId,
    };
  }

  factory Visit.fromMap(Map<String, dynamic> map) {
    return Visit(
      visitDate: map['visitDate'],
      visitTime: map['visitTime'],
      illnessType: map['illnessType'],
      notes: map['notes'],
      cardId: map['cardId'],
    );
  }
}
