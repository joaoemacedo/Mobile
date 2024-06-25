import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/models/restaurant.dart';
import 'package:provider/provider.dart';

class RestaurantSettingsPage extends StatefulWidget {
  const RestaurantSettingsPage({Key? key}) : super(key: key);

  @override
  _RestaurantSettingsPageState createState() => _RestaurantSettingsPageState();
}

class _RestaurantSettingsPageState extends State<RestaurantSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _restaurantNameController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _imageUrlController;

  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  int tables = 0;
  int maxPeoplePerReservation = 0;

  @override
  void initState() {
    super.initState();
    _restaurantNameController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Carregar as informações do restaurante ao iniciar a tela
    loadRestaurantInfo();
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void loadRestaurantInfo() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.restaurant != null) {
      setState(() {
        _restaurantNameController.text = authProvider.restaurant!.name;
        _stateController.text = authProvider.restaurant!.state;
        _cityController.text = authProvider.restaurant!.city;
        _imageUrlController.text = authProvider.restaurant!.imageUrl ?? '';

        sunday = authProvider.restaurant!.operatingDays.contains('sunday');
        monday = authProvider.restaurant!.operatingDays.contains('monday');
        tuesday = authProvider.restaurant!.operatingDays.contains('tuesday');
        wednesday = authProvider.restaurant!.operatingDays.contains('wednesday');
        thursday = authProvider.restaurant!.operatingDays.contains('thursday');
        friday = authProvider.restaurant!.operatingDays.contains('friday');
        saturday = authProvider.restaurant!.operatingDays.contains('saturday');

        openingTime = authProvider.restaurant!.openingTime;
        closingTime = authProvider.restaurant!.closingTime;
        tables = authProvider.restaurant!.tables ?? 0;
        maxPeoplePerReservation = authProvider.restaurant!.maxPeoplePerReservation ?? 0;
      });
    }
  }

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Informe o $fieldName';
    }
    return null;
  }

  void showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Restaurante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10),
              const Text(
                'Informações Básicas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _restaurantNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Restaurante',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                validator: (value) => validateField(value, 'nome do restaurante'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                validator: (value) => validateField(value, 'estado'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                validator: (value) => validateField(value, 'cidade'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                validator: (value) => validateField(value, 'URL da Imagem'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Configurações de Reserva',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Domingo'),
                value: sunday,
                onChanged: (value) {
                  setState(() {
                    sunday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Segunda-feira'),
                value: monday,
                onChanged: (value) {
                  setState(() {
                    monday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Terça-feira'),
                value: tuesday,
                onChanged: (value) {
                  setState(() {
                    tuesday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Quarta-feira'),
                value: wednesday,
                onChanged: (value) {
                  setState(() {
                    wednesday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Quinta-feira'),
                value: thursday,
                onChanged: (value) {
                  setState(() {
                    thursday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Sexta-feira'),
                value: friday,
                onChanged: (value) {
                  setState(() {
                    friday = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Sábado'),
                value: saturday,
                onChanged: (value) {
                  setState(() {
                    saturday = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Hora de Abertura'),
                trailing: Text(openingTime != null ? openingTime!.format(context) : 'Selecione'),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: openingTime ?? TimeOfDay.now(),
                  );
                  if (picked != null && picked != openingTime) {
                    setState(() {
                      openingTime = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Hora de Fechamento'),
                trailing: Text(closingTime != null ? closingTime!.format(context) : 'Selecione'),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: closingTime ?? TimeOfDay.now(),
                  );
                  if (picked != null && picked != closingTime) {
                    setState(() {
                      closingTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: tables.toString(),
                decoration: const InputDecoration(
                  labelText: 'Quantidade de Mesas',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => validateField(value, 'quantidade de mesas'),
                onChanged: (value) {
                  setState(() {
                    tables = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: maxPeoplePerReservation.toString(),
                decoration: const InputDecoration(
                  labelText: 'Quantidade Máxima de Pessoas por Reserva',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => validateField(value, 'quantidade máxima de pessoas por reserva'),
                onChanged: (value) {
                  setState(() {
                    maxPeoplePerReservation = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF7D0A0A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.updateRestaurantInfo(
                      _restaurantNameController.text,
                      _stateController.text,
                      _cityController.text,
                      openingTime,
                      closingTime,
                      tables,
                      maxPeoplePerReservation,
                      [
                        if (sunday) 'sunday',
                        if (monday) 'monday',
                        if (tuesday) 'tuesday',
                        if (wednesday) 'wednesday',
                        if (thursday) 'thursday',
                        if (friday) 'friday',
                        if (saturday) 'saturday',
                      ],
                      _imageUrlController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configurações salvas com sucesso!')),
                    );
                    Navigator.pop(context); // Fecha a tela após salvar
                  } else {
                    showValidationMessage('Por favor, preencha todos os campos corretamente.');
                  }
                },
                child: const Text('Salvar Configurações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
