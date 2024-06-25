import 'package:flutter_application_4/models/restaurant.dart';

class RestaurantService {
  // Simulação de um banco de dados local
  static Map<String, Restaurant> _restaurants = {};

  Restaurant? getRestaurant(String email) {
    return _restaurants[email];
  }

  List<Restaurant> getAllRestaurants() {
    return _restaurants.values.toList();
  }

  void addRestaurant(String email, Restaurant restaurant) {
    _restaurants[email] = restaurant;
  }

  void updateRestaurant(String email, Restaurant restaurant) {
    if (_restaurants.containsKey(email)) {
      _restaurants[email] = restaurant;
    }
  }
}
