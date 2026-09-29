import 'package:flutter/material.dart';
import '../../../app/app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const AppScaffold(
      title: 'Good morning, caregiver', child: _DashboardBody());
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        Text('Today at a glance',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        const Text(
            'Everything for your current patient, in one calm view.'),
        const SizedBox(height: 24),
        const Wrap(spacing: 12, runSpacing: 12, children: [
          _Stat(label: 'Today’s doses', value: '3'),
          _Stat(label: 'In stock', value: '52'),
          _Stat(label: 'Low stock', value: '1'),
          _Stat(label: 'Expiring soon', value: '1')
        ]),
        const SizedBox(height: 24),
        const Card(
            child: const Padding(
                padding: const EdgeInsets.all(18),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Today’s medicine schedule',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ListTile(
                          leading: const CircleAvatar(
                              child: const Icon(Icons.medication_outlined)),
                          title: const Text('Panadol Extra'),
                          subtitle: const Text('08:00 · 1 tablet after breakfast'),
                          trailing: const Chip(label: const Text('Upcoming'))),
                      ListTile(
                          leading: const CircleAvatar(
                              child: const Icon(Icons.medication_outlined)),
                          title: const Text('Augmentin'),
                          subtitle: const Text('14:00 · 1 tablet after lunch'),
                          trailing: const Chip(label: const Text('Later')))
                    ])))
      ]);
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 165,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    const SizedBox(height: 8),
                    Text(value,
                        style: Theme.of(context).textTheme.headlineMedium)
                  ]))));
}

