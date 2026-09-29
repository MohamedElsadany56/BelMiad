import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/app_scaffold.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../data/inventory_service.dart';

final inventoryBatchesProvider = FutureProvider.autoDispose((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.select(db.inventoryBatches).get();
});

final inventoryMedicineNamesProvider = FutureProvider.autoDispose((ref) async {
    final db = await ref.watch(databaseProvider.future);
    final medicines = await db.select(db.medications).get();
    return {for (final medicine in medicines) medicine.id: medicine.nameEn};
});

final inventoryAlertsProvider = FutureProvider.autoDispose((ref) async {
    final batches = await ref.watch(inventoryBatchesProvider.future);
    final now = DateTime.now();
    final expiring = batches.where((batch) {
        final expiry = batch.expirationDate;
        return !batch.isDepleted &&
                expiry != null &&
                expiry.isAfter(now) &&
                expiry.isBefore(now.add(const Duration(days: 30)));
    }).length;
    final lowStock = batches.where((batch) {
        return !batch.isDepleted && batch.availableQuantityScaled <= batch.quantityScale;
    }).length;
    return (lowStock: lowStock, expiring: expiring);
});

Future<void> _editBatch(
    BuildContext context,
    WidgetRef ref,
    InventoryBatche? batch,
) async {
  final db = await ref.read(databaseProvider.future);
  final medicines = await db.select(db.medications).get();
  if (medicines.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create a medicine first')));
    }
    return;
  }
    String medicationId = batch?.medicationId ?? medicines.first.id;
    final quantity = TextEditingController(
            text: batch == null
                    ? ''
                    : (batch.availableQuantityScaled / batch.quantityScale).toString());
    final unit = TextEditingController(text: batch?.unit ?? 'tablets');
    final source = TextEditingController(text: batch?.source);
    final packaging = TextEditingController(text: batch?.packagingType);
    final packageCount = TextEditingController(
        text: batch?.packageCount?.toString());
    final unitsPerPackage = TextEditingController(
        text: batch?.unitsPerPackage?.toString());
    final purchasePrice = TextEditingController(
        text: batch?.purchasePrice?.toString());
    DateTime? expiry = batch?.expirationDate;
  final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                  title: Text(batch == null ? 'Add stock batch' : 'Edit stock batch'),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    DropdownButtonFormField<String>(
                        initialValue: medicationId,
                        items: medicines
                            .map((m) => DropdownMenuItem(
                                value: m.id, child: Text(m.nameEn)))
                            .toList(),
                        onChanged: (v) => setState(() => medicationId = v!),
                        decoration:
                            const InputDecoration(labelText: 'Medicine')),
                    TextField(
                        controller: quantity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Available quantity')),
                    TextField(
                        controller: unit,
                        decoration: const InputDecoration(labelText: 'Unit')),
                    TextField(
                        controller: source,
                        decoration:
                            const InputDecoration(labelText: 'From / source')),
                    TextField(
                        controller: packaging,
                        decoration: const InputDecoration(
                            labelText: 'Packaging type (box, strip, bottle)')),
                    Row(children: [
                      Expanded(
                        child: TextField(
                            controller: packageCount,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Packages')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                            controller: unitsPerPackage,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Units/package')),
                      ),
                    ]),
                    TextField(
                        controller: purchasePrice,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Purchase price (optional)')),
                    ListTile(
                        title: Text(expiry == null
                            ? 'Expiration date: optional'
                            : 'Expires: ${expiry!.toLocal().toString().split(' ').first}'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              initialDate:
                                  DateTime.now().add(const Duration(days: 30)));
                          if (picked != null) setState(() => expiry = picked);
                        })
                  ])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Save'))
                  ])));
  final amount = int.tryParse(quantity.text);
  if (saved == true && amount != null && amount >= 0) {
        final values = InventoryBatchesCompanion(
            medicationId: drift.Value(medicationId),
            availableQuantityScaled: drift.Value(amount * 1000),
            unit: drift.Value(unit.text.trim().isEmpty ? 'unit' : unit.text.trim()),
            packagingType: drift.Value(packaging.text.trim().isEmpty
                ? null
                : packaging.text.trim()),
            packageCount: drift.Value(int.tryParse(packageCount.text.trim())),
            unitsPerPackage:
                drift.Value(int.tryParse(unitsPerPackage.text.trim())),
            purchasePrice:
                drift.Value(double.tryParse(purchasePrice.text.trim())),
            expirationDate: drift.Value(expiry),
            source: drift.Value(source.text.trim().isEmpty ? null : source.text.trim()),
        );
        if (batch == null) {
            await db.into(db.inventoryBatches).insert(InventoryBatchesCompanion.insert(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    medicationId: medicationId,
                    availableQuantityScaled: amount * 1000,
                    unit: unit.text.trim().isEmpty ? 'unit' : unit.text.trim(),
                    packagingType: drift.Value(packaging.text.trim().isEmpty
                        ? null
                        : packaging.text.trim()),
                    packageCount:
                        drift.Value(int.tryParse(packageCount.text.trim())),
                    unitsPerPackage:
                        drift.Value(int.tryParse(unitsPerPackage.text.trim())),
                    purchasePrice:
                        drift.Value(double.tryParse(purchasePrice.text.trim())),
                    purchaseDate: DateTime.now(),
                    expirationDate: drift.Value(expiry),
                    source: drift.Value(
                            source.text.trim().isEmpty ? null : source.text.trim())));
        } else {
            await (db.update(db.inventoryBatches)..where((b) => b.id.equals(batch.id)))
                    .write(values);
        }
    ref.invalidate(inventoryBatchesProvider);
  }
}

Future<void> _adjustBatch(
    BuildContext context,
    WidgetRef ref,
    InventoryBatche batch,
) async {
    final quantity = TextEditingController();
    final reason = TextEditingController();
    final saved = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
            title: const Text('Adjust stock'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    TextField(
                        controller: quantity,
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        decoration: const InputDecoration(
                            labelText: 'Change in units (+ add, - remove)',
                        ),
                    ),
                    TextField(
                        controller: reason,
                        decoration: const InputDecoration(labelText: 'Reason'),
                    ),
                ],
            ),
            actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                ),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Apply'),
                ),
            ],
        ),
    );
    final delta = int.tryParse(quantity.text.trim());
    if (saved == true && delta != null && delta != 0 && reason.text.trim().isNotEmpty) {
        final db = await ref.read(databaseProvider.future);
        await InventoryService(db).adjustQuantity(
            batchId: batch.id,
            deltaScaled: delta * batch.quantityScale,
            reason: reason.text.trim(),
        );
        ref.invalidate(inventoryBatchesProvider);
        ref.invalidate(inventoryAlertsProvider);
    }
}

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(inventoryBatchesProvider);
    final alerts = ref.watch(inventoryAlertsProvider);
    final medicineNames = ref.watch(inventoryMedicineNamesProvider);
    return AppScaffold(
        title: 'Stock & batches',
        child: batches.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Unable to load stock: $e')),
          data: (items) =>
              ListView(padding: const EdgeInsets.all(24), children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Stock & batches',
                  style: Theme.of(context).textTheme.headlineMedium),
              FilledButton.icon(
                  onPressed: () => _editBatch(context, ref, null),
                  icon: const Icon(Icons.add),
                  label: const Text('Add stock'))
            ]),
            const SizedBox(height: 18),
                        alerts.when(
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (summary) => Row(
                                children: [
                                    Expanded(
                                        child: Card(
                                            child: ListTile(
                                                leading: const Icon(Icons.trending_down),
                                                title: Text('${summary.lowStock} low-stock batches'),
                                                subtitle: const Text('At or below one unit'),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Card(
                                            child: ListTile(
                                                leading: const Icon(Icons.event_busy),
                                                title: Text('${summary.expiring} expiring soon'),
                                                subtitle: const Text('Within the next 30 days'),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        const SizedBox(height: 8),
            if (items.isEmpty)
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                          'No stock batches recorded. Medicines can remain active without inventory.'))),
            ...items.map((batch) => Card(
                child: ListTile(
                    leading: const CircleAvatar(
                        child: Icon(Icons.inventory_2_outlined)),
                    title: Text(
                        '${medicineNames.value?[batch.medicationId] ?? 'Medicine'} · ${batch.availableQuantityScaled / batch.quantityScale} ${batch.unit}'),
                    subtitle: Text(
                        'Purchased ${batch.purchaseDate.toLocal().toString().split(' ').first}'),
                                        trailing: PopupMenuButton<String>(
                                            onSelected: (action) {
                                                if (action == 'edit') _editBatch(context, ref, batch);
                                                if (action == 'adjust') _adjustBatch(context, ref, batch);
                                            },
                                            itemBuilder: (_) => const [
                                                PopupMenuItem(value: 'edit', child: Text('Edit batch')),
                                                PopupMenuItem(
                                                        value: 'adjust', child: Text('Adjust quantity')),
                                            ],
                                        )))),
          ]),
        ));
  }
}
