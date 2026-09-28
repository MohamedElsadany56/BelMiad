import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/database_provider.dart';
import 'medication_repository.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => MedicationRepository(ref.watch(databaseProvider).requireValue),
);
final medicationsForPatientProvider = FutureProvider.autoDispose.family(
  (ref, String patientId) =>
      ref.watch(medicationRepositoryProvider).listForPatient(patientId),
);
