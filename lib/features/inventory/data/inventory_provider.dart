import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../data/inventory_service.dart';

final inventoryServiceProvider = Provider<InventoryService>((ref) {
  final database = ref.watch(databaseProvider).requireValue;
  return InventoryService(database);
});
