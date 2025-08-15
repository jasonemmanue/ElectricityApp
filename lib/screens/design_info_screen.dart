import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DesignInfoScreen extends StatelessWidget {
  const DesignInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('designServiceTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'designHeader'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'designText'.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('designListItem1'.tr()),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('designListItem2'.tr()),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('designListItem3'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
