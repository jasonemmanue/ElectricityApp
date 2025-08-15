import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
    String title;
    IconData leadingIcon;

    switch (_selectedIndex) {
      case 1:
        title = 'myAppointments'.tr();
        leadingIcon = Icons.history;
        break;
      case 2:
        title = 'onlineChat'.tr();
        leadingIcon = Icons.chat_bubble;
        break;
      case 3:
        title = 'userProfile'.tr();
        leadingIcon = Icons.person;
        break;
      default:
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
          title: Text(
            'homeTitle'.tr(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

    return AppBar(
      backgroundColor: Colors.blue.shade800,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      leading: Icon(leadingIcon, color: Colors.white),
      actions: _selectedIndex == 3 ? [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ] : null,
      elevation: 0,
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
        label: Text('takeAppointment'.tr()),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.orange.shade700,
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'home'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.calendar_today), label: 'appointments'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline), label: 'chat'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: 'profile'.tr()),
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
            title: 'breakdownService'.tr(),
            details: [
              'breakdownDetail1'.tr(),
              'breakdownDetail2'.tr(),
              'breakdownDetail3'.tr()
            ],
            buttonText: 'requestQuote'.tr(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuoteRequestScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.home_work,
            title: 'renovationService'.tr(),
            details: ['renovationDetail1'.tr(), 'renovationDetail2'.tr()],
            buttonText: 'consult'.tr(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RenovationInfoScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.design_services,
            title: 'designService'.tr(),
            details: ['designDetail1'.tr(), 'designDetail2'.tr()],
            buttonText: 'consult'.tr(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DesignInfoScreen()),
              );
            },
          ),
          ServiceCard(
            icon: Icons.construction,
            title: 'taskService'.tr(),
            details: [
              'taskDetail1'.tr(),
              'taskDetail2'.tr(),
              'taskDetail3'.tr()
            ],
            buttonText: 'requestService'.tr(),
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
