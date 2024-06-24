import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/restaurant.dart'; // Importe o modelo Restaurant

class ConfirmationDialog extends StatelessWidget {
  final Restaurant restaurant;
  final String name;
  final String email;
  final String phone;
  final DateTime date;
  final TimeOfDay time;
  final String observations;

  const ConfirmationDialog({
    Key? key,
    required this.restaurant,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.time,
    required this.observations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmação de Reserva'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Restaurante: ${restaurant.name}'),
            Text('Data: ${date.day}/${date.month}/${date.year}'),
            Text('Horário: ${time.hour}:${time.minute}'),
            Text('Nome: $name'),
            Text('Email: $email'),
            Text('Telefone: $phone'),
            Text('Observações: $observations'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo de confirmação
            _showReservationSuccessDialog(context); // Chamar método para exibir diálogo de sucesso
          },
          child: const Text('Confirmar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo de confirmação
          },
          child: const Text('Editar'),
        ),
      ],
    );
  }

  void _showReservationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserva Realizada com Sucesso'),
        content: const Text('Sua reserva foi confirmada.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o diálogo de sucesso
              Navigator.of(context).pop(); // Fechar o diálogo de reserva
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
