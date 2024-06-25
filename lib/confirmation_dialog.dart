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
    super.key,
    required this.restaurant,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.time,
    required this.observations,
  });

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
            _confirmReservation(context); // Confirmar a reserva
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

  void _confirmReservation(BuildContext context) {
    // Aqui você pode adicionar lógica para confirmar a reserva (enviar para API, salvar no banco de dados, etc.)
    // Exemplo simples: exibir diálogo de sucesso e fechar o diálogo de reserva
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserva Realizada com Sucesso'),
        content: const Text('Sua reserva foi confirmada.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst); // Fechar todos os diálogos e voltar para a primeira tela
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
