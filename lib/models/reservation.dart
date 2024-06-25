import 'package:flutter/material.dart';

class Reservation {
  final String restaurantName;
  final String userEmail;
  final DateTime date;
  final TimeOfDay time;
  final int numberOfPeople;
  final String observations;
  String status; // Novo campo adicionado

  Reservation({
    required this.restaurantName,
    required this.userEmail,
    required this.date,
    required this.time,
    required this.numberOfPeople,
    required this.observations,
    required this.status, // Incluído no construtor
  });

  // Método para clonar uma reserva com novos valores opcionais
  Reservation copyWith({
    String? restaurantName,
    String? userEmail,
    DateTime? date,
    TimeOfDay? time,
    int? numberOfPeople,
    String? observations,
    String? status,
  }) {
    return Reservation(
      restaurantName: restaurantName ?? this.restaurantName,
      userEmail: userEmail ?? this.userEmail,
      date: date ?? this.date,
      time: time ?? this.time,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      observations: observations ?? this.observations,
      status: status ?? this.status,
    );
  }
}
