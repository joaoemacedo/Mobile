import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulação de dados de reservas
  List<Map<String, dynamic>> reservations = [
    {
      'name': 'João Silva',
      'status': 'Pendente',
      'people': 4,
      'date': '2024-06-30',
      'time': '19:00',
      'observations': 'Nenhuma'
    },
    {
      'name': 'Maria Souza',
      'status': 'Confirmado',
      'people': 2,
      'date': '2024-07-01',
      'time': '20:00',
      'observations': 'Preferência por mesa perto da janela'
    },
    // Adicione mais dados de reserva conforme necessário
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final restaurant = authProvider.restaurant;
    final restaurantName = restaurant?.name ?? 'Nome do Restaurante';
    final restaurantId = authProvider.loggedInUserEmail;

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
              // Navegar para a tela de configurações do restaurante
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList(status: 'Pendente'),
          _buildReservationsList(status: 'Confirmado'),
          _buildReservationsList(status: 'Encerrado'),
        ],
      ),
    );
  }

  Widget _buildReservationsList({required String status}) {
    List<Map<String, dynamic>> filteredReservations = reservations
        .where((reservation) => reservation['status'] == status)
        .toList();

    return ListView.builder(
      itemCount: filteredReservations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          color: const Color(0xFF7D0A0A), // Cor de fundo do card
          child: ListTile(
            title: Text(
              filteredReservations[index]['name'],
              style: const TextStyle(color: Colors.white), // Cor do texto
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${filteredReservations[index]['status']}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Número de Pessoas: ${filteredReservations[index]['people']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Ação ao visualizar a reserva
                _showReservationDetailsDialog(
                    filteredReservations[index], status);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF7D0A0A),
                side: const BorderSide(color: Color(0xFF7D0A0A)),
                // Borda do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // Cantos levemente arredondados
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

  void _showReservationDetailsDialog(
      Map<String, dynamic> reservation, String currentStatus) {
    String newName = reservation['name'];
    String newStatus = reservation['status'];
    int newPeople = reservation['people'];
    String newDate = reservation['date'];
    String newTime = reservation['time'];
    String newObservations = reservation['observations'];

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
                  Text('Nome: $newName'),
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
                  Text('Número de Pessoas: $newPeople'),
                  Text('Data: $newDate'),
                  Text('Hora: $newTime'),
                  Text('Observações: $newObservations'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateReservationStatus(reservation, newStatus);
                      Navigator.of(context).pop();
                      // Navegar para o tab correspondente ao novo status
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
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF7D0A0A),
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

  void _updateReservationStatus(Map<String, dynamic> reservation, String newStatus) {
    setState(() {
      reservation['status'] = newStatus;
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
