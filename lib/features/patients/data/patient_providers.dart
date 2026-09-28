import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/database_provider.dart';
import 'patient_repository.dart';

final patientRepositoryProvider = Provider<PatientRepository>(
  (ref) => PatientRepository(ref.watch(databaseProvider).requireValue),
);
final patientsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(patientRepositoryProvider).list(),
);
