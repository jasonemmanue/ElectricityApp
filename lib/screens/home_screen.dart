import 'package:flutter/material.dart';
import '../widgets/service_card.dart';
import 'appointment_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart'; // Importer le nouvel écran de profil

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des pages à afficher
  static const List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    AppointmentScreen(),
    ChatScreen(),
    ProfileScreen(), // Ajouter l'écran de profil ici
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    // AppBar pour la page de RDV
    if (_selectedIndex == 1) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Prise de Rendez-vous', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.calendar_month, color: Colors.white),
        elevation: 0,
      );
    }
    // AppBar pour la page de Chat
    if (_selectedIndex == 2) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Discussion en Ligne', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.chat_bubble, color: Colors.white),
        elevation: 0,
      );
    }
    // AppBar pour la page de Profil
    if (_selectedIndex == 3) {
      return AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Profil Utilisateur', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.person, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      );
    }

    // AppBar par défaut pour la page d'accueil
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


// Widget contenant le corps de la page d'accueil
class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          ServiceCard(
            icon: Icons.handyman,
            title: 'Service Dépannage',
            details: const ['Électricité Bâtiment', 'Électricité Réseau','Dépannage Industriel'],
            buttonText: 'Demander un devis',
            onPressed: () {},
          ),
          ServiceCard(
            icon: Icons.home_work,
            title: 'Service Rénovation',
            details: const ['Électricité BT', 'Pose en apparent avec goulotte'],
            buttonText: 'Prendre rendez-vous',
            onPressed: () {},
          ),
          ServiceCard(
            icon: Icons.design_services,
            title: 'Service Conception',
            details: const ['Installation selon NF C100', 'Pose inverseur semi/manuel'],
            buttonText: 'Consulter',
            onPressed: () {},
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}