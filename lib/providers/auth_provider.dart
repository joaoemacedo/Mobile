import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/restaurant.dart';
import 'package:flutter_application_4/services/restaurant_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _loggedInUserEmail = '';
  Restaurant? _restaurant;
  final RestaurantService _restaurantService = RestaurantService();

  // Simulação de banco de dados de usuários cadastrados
  final Map<String, Map<String, dynamic>> _registeredUsers = {
    'teste@teste.com': {
      'password': 'senha123',
      'restaurantName': 'Restaurante Teste',
      'city': 'São Paulo',
      'state': 'SP',
      'operatingDays': [],
      'openingTime': null,
      'closingTime': null,
      'tables': 0,
      'maxPeoplePerReservation': 0,
    },
    'usuario@teste.com': {
      'password': '123456',
      'restaurantName': 'Outro Restaurante',
      'city': 'Rio de Janeiro',
      'state': 'RJ',
      'operatingDays': [],
      'openingTime': null,
      'closingTime': null,
      'tables': 0,
      'maxPeoplePerReservation': 0,
    },
  };

  bool get isAuthenticated => _isAuthenticated;

  String get loggedInUserEmail => _loggedInUserEmail;

  Restaurant? get restaurant => _restaurant;

  List<Map<String, dynamic>> get userRestaurants {
    return _registeredUsers.values.toList();
  }

  void register(String email, String password, String restaurantName, String city, String state) {
    if (_registeredUsers.containsKey(email)) {
      throw Exception('Este email já está registrado. Por favor, use outro email.');
    }

    _registeredUsers[email] = {
      'password': password,
      'restaurantName': restaurantName,
      'city': city,
      'state': state,
      'operatingDays': [],
      'openingTime': null,
      'closingTime': null,
      'tables': 0,
      'maxPeoplePerReservation': 0,
    };

    _isAuthenticated = true;
    _loggedInUserEmail = email;
    _restaurant = Restaurant(
      name: restaurantName,
      city: city,
      state: state,
      openingDays: [],
      openingTime: null,
      closingTime: null,
      tables: 0,
      maxPeoplePerReservation: 0,
      imageUrl: '',
      operatingDays: [],
    );

    // Salvar no serviço de restaurante
    _restaurantService.updateRestaurant(email, _restaurant!);

    notifyListeners();
  }

  void login(String email, String password) {
    if (_registeredUsers.containsKey(email) && _registeredUsers[email]!['password'] == password) {
      _isAuthenticated = true;
      _loggedInUserEmail = email;
      _restaurant = _restaurantService.getRestaurant(email);

      if (_restaurant == null) {
        // Caso não exista restaurante no serviço, criar um novo
        _restaurant = Restaurant(
          name: _registeredUsers[email]!['restaurantName'],
          city: _registeredUsers[email]!['city'],
          state: _registeredUsers[email]!['state'],
          openingDays: List<String>.from(_registeredUsers[email]!['operatingDays']),
          openingTime: _registeredUsers[email]!['openingTime'],
          closingTime: _registeredUsers[email]!['closingTime'],
          tables: _registeredUsers[email]!['tables'],
          maxPeoplePerReservation: _registeredUsers[email]!['maxPeoplePerReservation'],
          imageUrl: '',
          operatingDays: [],
        );
        _restaurantService.updateRestaurant(email, _restaurant!);
      }

      notifyListeners();
    } else {
      throw Exception('Credenciais inválidas. Por favor, verifique seu email e senha.');
    }
  }

  void logout() {
    _isAuthenticated = false;
    _loggedInUserEmail = '';
    _restaurant = null;
    notifyListeners();
  }

  void updateRestaurantInfo(
    String newRestaurantName,
    String newState,
    String newCity,
    TimeOfDay? newOpeningTime,
    TimeOfDay? newClosingTime,
    int newTables,
    int newMaxPeoplePerReservation,
    List<String> newOperatingDays,
  ) {
    if (_restaurant != null) {
      _restaurant = _restaurant!.copyWith(
        name: newRestaurantName,
        state: newState,
        city: newCity,
        openingDays: newOperatingDays,
        openingTime: newOpeningTime,
        closingTime: newClosingTime,
        tables: newTables,
        maxPeoplePerReservation: newMaxPeoplePerReservation,
      );

      // Atualiza também os dados do usuário registrado
      final updatedUserData = {
        'password': _registeredUsers[_loggedInUserEmail]!['password'],
        'restaurantName': newRestaurantName,
        'city': newCity,
        'state': newState,
        'operatingDays': newOperatingDays,
        'openingTime': newOpeningTime,
        'closingTime': newClosingTime,
        'tables': newTables,
        'maxPeoplePerReservation': newMaxPeoplePerReservation,
      };
      _registeredUsers[_loggedInUserEmail] = updatedUserData;

      // Salvar no serviço de restaurante
      _restaurantService.updateRestaurant(_loggedInUserEmail, _restaurant!);

      notifyListeners();
    }
  }

  Map<String, dynamic> getRegisteredUserData(String email) {
    return _registeredUsers[email] ?? {};
  }

  bool isRestaurantDefined() {
    return _restaurant != null;
  }

  bool isAuthenticatedUser() {
    return _isAuthenticated;
  }
}
