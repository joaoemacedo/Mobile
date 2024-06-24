import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/restaurant.dart';
import '../confirmation_dialog.dart'; 

class ReservationDialog extends StatefulWidget {
  final Restaurant restaurant;

  const ReservationDialog({super.key, required this.restaurant});

  @override
  _ReservationDialogState createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Realizar Reserva em ${widget.restaurant.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data da Reserva',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Horário da Reserva',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedTime.hour}:${_selectedTime.minute}',
                          ),
                          const Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              controller: _observationsController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Informe suas preferências...',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            // Mostrar diálogo de confirmação com os dados preenchidos
            showDialog(
              context: context,
              builder: (context) => ConfirmationDialog(
                restaurant: widget.restaurant,
                name: _nameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                date: _selectedDate,
                time: _selectedTime,
                observations: _observationsController.text,
              ),
            );
          },
          child: const Text('Reservar'),
        ),
      ],
    );
  }
}
