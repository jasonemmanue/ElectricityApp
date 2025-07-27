import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedService = 'Dépannage - Électricité Bâtiment';
  final List<String> _services = [
    'Dépannage - Électricité Bâtiment',
    'Dépannage - Électricité Réseau',
    'Rénovation - Électricité BT',
    'Rénovation - Pose en apparent',
    'Conception - Installation NF C100',
    'Conception - Pose inverseur'
  ];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isInit = true; // Flag pour l'initialisation

  @override
  void initState() {
    super.initState();
    // On initialise seulement la date ici
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On initialise l'heure ici, car cela dépend du context
    if (_isInit) {
      _timeController.text = TimeOfDay.now().format(context);
      _isInit = false; // On s'assure que cela ne se reproduit pas
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSectionTitle('Service demandé'),
              _buildServiceDropdown(),
              const SizedBox(height: 16),
              _buildSectionTitle('Date souhaitée'),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildSectionTitle('Heure préférée'),
              _buildTimeField(),
              const SizedBox(height: 16),
              _buildSectionTitle('Description du problème'),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildSectionTitle('Adresse d\'intervention'),
              _buildAddressField(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 48), // Spacer for centering
          const Spacer(),
          const Text(
            'Nouveau Rendez-vous',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Vous pouvez ajouter une action ici, comme revenir à l'accueil
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildServiceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedService,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedService = newValue;
        });
      },
      items: _services.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _timeController,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
        suffixIcon: const Icon(Icons.access_time),
      ),
      onTap: () => _selectTime(context),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Décrivez votre demande en détail...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'Votre adresse complète',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Logique de soumission du formulaire
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rendez-vous confirmé !')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text('Confirmer le rendez-vous'),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}