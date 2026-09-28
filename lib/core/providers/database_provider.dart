import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = await openAppDatabase();
  ref.onDispose(database.close);
  return database;
});

