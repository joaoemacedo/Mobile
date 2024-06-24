import 'package:flutter_application_4/models/restaurant.dart';

class RestaurantService {
  // Simulação de um banco de dados local
  static Map<String, Restaurant> _restaurants = {};

  Restaurant? getRestaurant(String email) {
    return _restaurants[email];
  }

  void updateRestaurant(String email, Restaurant restaurant) {
    _restaurants[email] = restaurant;
  }
}
