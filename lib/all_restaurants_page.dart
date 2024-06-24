import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/models/restaurant.dart';
import 'package:flutter_application_4/screens/reservation_dialog.dart';
import 'package:provider/provider.dart';

class AllRestaurantsPage extends StatelessWidget {
  const AllRestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    List<Restaurant> userRestaurants = authProvider.isAuthenticated
        ? authProvider.userRestaurants.map((userData) => Restaurant(
            name: userData['restaurantName'] ?? 'Não especificado',
            operatingDays: List<String>.from(userData['operatingDays'] ?? []),
            openingTime: userData['openingTime'] != null ? TimeOfDay.fromDateTime(DateTime.parse(userData['openingTime'])) : null,
            closingTime: userData['closingTime'] != null ? TimeOfDay.fromDateTime(DateTime.parse(userData['closingTime'])) : null,
            tables: userData['tables'] ?? 0,
            maxPeoplePerReservation: userData['maxPeoplePerReservation'] ?? 0,
            city: userData['city'] ?? '',
            state: userData['state'] ?? '',
            imageUrl: userData['imageUrl'] ?? '', openingDays: [], // URL da imagem do restaurante
          )).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Restaurantes'),
      ),
      body: userRestaurants.isEmpty
          ? const Center(
              child: Text(
                'Nenhum restaurante cadastrado',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: userRestaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantCard(context, userRestaurants[index]);
              },
            ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            restaurant.imageUrl,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Dias de Funcionamento: ${restaurant.operatingDays.isNotEmpty ? restaurant.operatingDays.join(', ') : 'Não especificado'}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Horário de Funcionamento: ${restaurant.openingTime != null && restaurant.closingTime != null ? '${restaurant.openingTime!.format(context)} - ${restaurant.closingTime!.format(context)}' : 'Não especificado'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ReservationDialog(restaurant: restaurant),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF7D0A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Realizar Reserva'),
            ),
          ),
        ],
      ),
    );
  }
}
