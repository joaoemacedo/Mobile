import 'package:flutter/material.dart';
import 'package:flutter_application_4/all_restaurants_page.dart';
import 'package:flutter_application_4/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Reserve'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () {
              Navigator.pushNamed(context, '/restaurantSettings');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF7D0A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/allRestaurants');
              },
              child: const Text('Fazer Reserva'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7D0A0A),
                side: const BorderSide(color: Color(0xFF7D0A0A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Seu Restaurante'),
            ),
          ],
        ),
      ),
    );
  }
}
