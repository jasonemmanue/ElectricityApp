// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/service_card.dart';
import 'appointment_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'design_info_screen.dart';
import 'renovation_info_screen.dart';
import 'appointments_history_screen.dart';
import 'quote_request_screen.dart';
import 'task_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    AppointmentsHistoryScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    if (_selectedIndex == 1) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Mes Rendez-vous', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.history, color: Colors.white),
        elevation: 0,
      );
    }
    if (_selectedIndex == 2) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Discussion en Ligne', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.chat_bubble, color: Colors.white),
        elevation: 0,
      );
    }
    if (_selectedIndex == 3) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Profil Utilisateur', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.person, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        elevation: 0,
      );
    }

    return AppBar(
      backgroundColor: Colors.blue.shade800,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.orange.shade700,
          child: const Text('I', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      title: const Text(
        'SOS_ELECTRICITY',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentScreen()),
          );
        },
        label: const Text('Prendre RDV'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.orange.shade700,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'RDV'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
        children: [
          const SizedBox(height: 10),
          ServiceCard(
            icon: Icons.handyman,
            title: 'Service Dépannage',
            details: const ['Électricité Bâtiment', 'Électricité Réseau','Dépannage Industriel'],
            buttonText: 'Demander un devis',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuoteRequestScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.home_work,
            title: 'Service Rénovation',
            details: const ['Électricité BT', 'Pose en apparent avec goulotte'],
            buttonText: 'Consulter',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RenovationInfoScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.design_services,
            title: 'Service Conception',
            details: const ['Installation selon NF C100', 'Pose inverseur semi/manuel'],
            buttonText: 'Consulter',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DesignInfoScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.construction,
            title: 'Prestation des services\n(travaux à la tâche)',
            details: const ['Installation de prises', 'Montage de luminaires', 'Petits travaux électriques'],
            buttonText: 'Demander un service',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskRequestScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}