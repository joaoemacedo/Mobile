import 'package:flutter/material.dart';

class Restaurant {
  final String name;
  final List<String> operatingDays;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;
  final int tables;
  final int maxPeoplePerReservation;
  final String city;
  final String state;
  final String imageUrl;

  Restaurant({
    required this.name,
    required this.operatingDays,
    required this.openingTime,
    required this.closingTime,
    required this.tables,
    required this.maxPeoplePerReservation,
    required this.city,
    required this.state,
    required this.imageUrl, required List openingDays,
  });

  Restaurant? copyWith({required String name, required String state, required String city, required List<String> openingDays, TimeOfDay? openingTime, TimeOfDay? closingTime, required int tables, required int maxPeoplePerReservation}) {
    return null;
  }
}
