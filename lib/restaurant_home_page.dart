import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/models/reservation.dart'; // Importe o modelo Reservation
import 'package:provider/provider.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({Key? key}) : super(key: key);

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Reservation> _pendingReservations = [];
  List<Reservation> _confirmedReservations = [];
  List<Reservation> _closedReservations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final reservations = await authProvider.getReservations();

      setState(() {
        _pendingReservations = reservations
            .where((reservation) => reservation.status == 'Pendente')
            .toList();
        _confirmedReservations = reservations
            .where((reservation) => reservation.status == 'Confirmado')
            .toList();
        _closedReservations = reservations
            .where((reservation) => reservation.status == 'Encerrado')
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar reservas: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final restaurantName = authProvider.restaurant?.name ?? 'Nome do Restaurante';

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendentes'),
            Tab(text: 'Confirmadas'),
            Tab(text: 'Encerradas'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/restaurantSettings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReservationsList(_pendingReservations),
                _buildReservationsList(_confirmedReservations),
                _buildReservationsList(_closedReservations),
              ],
            ),
    );
  }

  Widget _buildReservationsList(List<Reservation> reservations) {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          color: const Color(0xFF7D0A0A), // Cor de fundo do card
          child: ListTile(
            title: Text(
              reservations[index].userEmail, // Exemplo de atributo a ser mostrado, ajuste conforme seu modelo Reservation
              style: const TextStyle(color: Colors.white), // Cor do texto
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${reservations[index].status}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Número de Pessoas: ${reservations[index].numberOfPeople}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                _showReservationDetailsDialog(reservations[index]);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF7D0A0A),
                side: const BorderSide(color: Color(0xFF7D0A0A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Visualizar',
                style: TextStyle(color: Color(0xFF7D0A0A)),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showReservationDetailsDialog(Reservation reservation) {
    String newStatus = reservation.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Detalhes da Reserva'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Email do Cliente: ${reservation.userEmail}'),
                  const Text('Status:'),
                  DropdownButton<String>(
                    value: newStatus,
                    items: <String>[
                      'Pendente',
                      'Confirmado',
                      'Encerrado'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                  ),
                  Text('Número de Pessoas: ${reservation.numberOfPeople}'),
                  Text('Data: ${reservation.date.toString()}'),
                  Text('Hora: ${reservation.time.toString()}'),
                  Text('Observações: ${reservation.observations}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateReservationStatus(reservation, newStatus);
                      Navigator.of(context).pop();
                      _navigateToTab(newStatus);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF7D0A0A),
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF7D0A0A),
                  ),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateReservationStatus(Reservation reservation, String newStatus) {
    setState(() {
      reservation.status = newStatus;
    });
    // Aqui você pode implementar a lógica para atualizar o status da reserva no backend
  }

  void _navigateToTab(String status) {
    int tabIndex = 0;
    switch (status) {
      case 'Pendente':
        tabIndex = 0;
        break;
      case 'Confirmado':
        tabIndex = 1;
        break;
      case 'Encerrado':
        tabIndex = 2;
        break;
    }
    _tabController.animateTo(tabIndex);
  }
}
