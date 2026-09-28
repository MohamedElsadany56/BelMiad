import 'package:flutter/material.dart';
import '../../../app/app_scaffold.dart';
class MedicationsScreen extends StatelessWidget { const MedicationsScreen({super.key}); @override Widget build(BuildContext context) => AppScaffold(title: 'Medications', child: ListView(padding: const EdgeInsets.all(24), children: [Text('Medications', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8), const Text('This feature is being built on the offline SQLite foundation.'), const SizedBox(height: 24), Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [const Icon(Icons.add_circle_outline), const SizedBox(width: 12), Expanded(child: Text('Add your first item from this section.')), OutlinedButton(onPressed: () {}, child: const Text('Add'))])))])); }
}
