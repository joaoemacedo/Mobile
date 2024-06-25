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
    required this.imageUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      operatingDays: List<String>.from(json['operatingDays'] ?? []),
      openingTime: _convertStringToTimeOfDay(json['openingTime']),
      closingTime: _convertStringToTimeOfDay(json['closingTime']),
      tables: json['tables'] ?? 0,
      maxPeoplePerReservation: json['maxPeoplePerReservation'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'operatingDays': operatingDays,
      'openingTime': _convertTimeOfDayToString(openingTime),
      'closingTime': _convertTimeOfDayToString(closingTime),
      'tables': tables,
      'maxPeoplePerReservation': maxPeoplePerReservation,
      'city': city,
      'state': state,
      'imageUrl': imageUrl,
    };
  }

  Restaurant copyWith({
    String? name,
    List<String>? operatingDays,
    TimeOfDay? openingTime,
    TimeOfDay? closingTime,
    int? tables,
    int? maxPeoplePerReservation,
    String? city,
    String? state,
    String? imageUrl,
  }) {
    return Restaurant(
      name: name ?? this.name,
      operatingDays: operatingDays ?? this.operatingDays,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      tables: tables ?? this.tables,
      maxPeoplePerReservation: maxPeoplePerReservation ?? this.maxPeoplePerReservation,
      city: city ?? this.city,
      state: state ?? this.state,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static TimeOfDay? _convertStringToTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String? _convertTimeOfDayToString(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return '';
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }
}
