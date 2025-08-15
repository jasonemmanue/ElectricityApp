import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RenovationInfoScreen extends StatelessWidget {
  const RenovationInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('renovationServiceTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'renovationHeader'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'renovationText'.tr(),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.flash_on, color: Colors.orange),
              title: Text('renovationListItem1'.tr()),
            ),
            ListTile(
              leading: const Icon(Icons.cable, color: Colors.orange),
              title: Text('renovationListItem2'.tr()),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
              title: Text('renovationListItem3'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
