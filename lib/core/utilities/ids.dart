import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generates a new random, globally unique identifier.
String newId() => _uuid.v4();
