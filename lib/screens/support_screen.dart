import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('supportTitle'.tr()),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'contactUs'.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text('byPhone'.tr()),
                subtitle: const Text('+237 698 452 376'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: Text('byEmail'.tr()),
                subtitle: const Text('Kammeugnejulio41@gmail.com'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text('address'.tr()),
                subtitle: const Text('407 Rue ESSOMBA, YAOUNDE CAMEROUN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
