import 'package:flutter/material.dart';
import 'package:flutter_application_4/homePage.dart'; // Importe o HomePage aqui
import 'package:flutter_application_4/login_page.dart';
import 'package:flutter_application_4/register_page.dart';
import 'package:flutter_application_4/restaurant_home_page.dart';
import 'package:flutter_application_4/restaurant_settings_page.dart';
import 'package:flutter_application_4/all_restaurants_page.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Reserve',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartAppButton(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/restaurantHome': (context) => const RestaurantHomePage(),
        '/restaurantSettings': (context) => const RestaurantSettingsPage(),
        '/allRestaurants': (context) => const AllRestaurantsPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class StartAppButton extends StatelessWidget {
  const StartAppButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao The Reserve'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Iniciar App'),
        ),
      ),
    );
  }
}
