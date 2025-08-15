import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

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

  String? _selectedPaymentMethod = 'Orange Money';
  final List<String> _paymentMethods = ['Orange Money', 'Mobile Money', 'Carte Bancaire'];
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timeController.text.isEmpty) {
      _timeController.text = TimeOfDay.now().format(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: context.locale,
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

  void _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Utilisateur non connecté.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user.uid,
        'userEmail': user.email,
        'service': _selectedService,
        'date': _dateController.text,
        'time': _timeController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'createdAt': Timestamp.now(),
        'status': 'En attente',
        'methode_paiement': _selectedPaymentMethod,
        'montant_total': double.tryParse(_totalAmountController.text) ?? 0,
        'montant_envoye': double.tryParse(_paidAmountController.text) ?? 0,
      });

      await FirebaseFirestore.instance.collection('chats').doc(user.uid).set({
        'lastMessageAt': Timestamp.now(),
        'userEmail': user.email,
        'userId': user.uid,
        'unreadAppointmentCountAdmin': FieldValue.increment(1),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rendez-vous confirmé et envoyé !')),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('takeAppointmentTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('serviceRequested'.tr()),
                _buildServiceDropdown(),
                const SizedBox(height: 16),
                _buildSectionTitle('dateAndTime'.tr()),
                Row(
                  children: [
                    Expanded(child: _buildDateField()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTimeField()),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('problemDescription'.tr()),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildSectionTitle('interventionAddress'.tr()),
                _buildAddressField(),
                const SizedBox(height: 24),
                _buildSectionTitle('advancePayment'.tr()),
                _buildPaymentDropdown(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTotalAmountField()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildPaidAmountField()),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
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
        labelText: 'date'.tr(),
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
        labelText: 'time'.tr(),
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
        hintText: 'describeRequest'.tr(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.trim().isEmpty ? 'pleaseDescribeProblem'.tr() : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        hintText: 'yourFullAddress'.tr(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.trim().isEmpty ? 'pleaseEnterAddress'.tr() : null,
    );
  }

  Widget _buildPaymentDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMethod,
      decoration: InputDecoration(
        labelText: 'paymentMethod'.tr(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      onChanged: (String? newValue) {
        setState(() { _selectedPaymentMethod = newValue; });
      },
      items: _paymentMethods.map((method) => DropdownMenuItem(value: method, child: Text(method))).toList(),
    );
  }

  Widget _buildTotalAmountField() {
    return TextFormField(
      controller: _totalAmountController,
      decoration: InputDecoration(
        labelText: 'totalAmount'.tr(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'required'.tr() : null,
    );
  }

  Widget _buildPaidAmountField() {
    return TextFormField(
      controller: _paidAmountController,
      decoration: InputDecoration(
        labelText: 'advanceAmount'.tr(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'required'.tr() : null,
    );
  }


  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _submitAppointment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text('confirmAppointment'.tr()),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _totalAmountController.dispose();
    _paidAmountController.dispose();
    super.dispose();
  }
}
