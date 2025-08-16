import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class AppointmentsHistoryScreen extends StatelessWidget {
  const AppointmentsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text("pleaseLogin".tr()));
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'noAppointments'.tr(),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appt = appointments[index].data() as Map<String, dynamic>;
              String status = appt['status'] ?? 'En attente';
              Color statusColor;
              switch (status) {
                case 'Accepté':
                  statusColor = Colors.green;
                  break;
                case 'Refusé':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.orange;
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt['service'] ?? 'service'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text('${appt['date']} à ${appt['time']}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.receipt_long,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                              '${'total'.tr()}: ${appt['montant_total'] ?? 'N/A'} FCFA'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payment,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                              '${'advance'.tr()}: ${appt['montant_envoye'] ?? 'N/A'} FCFA (${appt['methode_paiement'] ?? 'N/A'})'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('STATUT: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            status,
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}