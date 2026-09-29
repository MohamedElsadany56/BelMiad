import '../../../core/database/app_database.dart';

/// A patient joined with its person record.
class PatientProfile {
  const PatientProfile({required this.person, required this.patient});

  final Person person;
  final Patient patient;

  String get id => patient.patientId;
  String get name => person.fullName;
  String get timezone => patient.timezone;
}
