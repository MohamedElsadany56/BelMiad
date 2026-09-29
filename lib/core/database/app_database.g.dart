// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredLanguageMeta =
      const VerificationMeta('preferredLanguage');
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>('preferred_language', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        personId,
        fullName,
        phone,
        email,
        preferredLanguage,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
          _preferredLanguageMeta,
          preferredLanguage.isAcceptableOrUnknown(
              data['preferred_language']!, _preferredLanguageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {personId};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      preferredLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_language']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final String personId;
  final String fullName;
  final String? phone;
  final String? email;
  final String? preferredLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Person(
      {required this.personId,
      required this.fullName,
      this.phone,
      this.email,
      this.preferredLanguage,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['person_id'] = Variable<String>(personId);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || preferredLanguage != null) {
      map['preferred_language'] = Variable<String>(preferredLanguage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      personId: Value(personId),
      fullName: Value(fullName),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      preferredLanguage: preferredLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredLanguage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      personId: serializer.fromJson<String>(json['personId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      preferredLanguage:
          serializer.fromJson<String?>(json['preferredLanguage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'personId': serializer.toJson<String>(personId),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'preferredLanguage': serializer.toJson<String?>(preferredLanguage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Person copyWith(
          {String? personId,
          String? fullName,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> preferredLanguage = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Person(
        personId: personId ?? this.personId,
        fullName: fullName ?? this.fullName,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        preferredLanguage: preferredLanguage.present
            ? preferredLanguage.value
            : this.preferredLanguage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      personId: data.personId.present ? data.personId.value : this.personId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('personId: $personId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(personId, fullName, phone, email,
      preferredLanguage, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.personId == this.personId &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.preferredLanguage == this.preferredLanguage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<String> personId;
  final Value<String> fullName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> preferredLanguage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PersonsCompanion({
    this.personId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsCompanion.insert({
    required String personId,
    required String fullName,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : personId = Value(personId),
        fullName = Value(fullName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Person> custom({
    Expression<String>? personId,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? preferredLanguage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (personId != null) 'person_id': personId,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsCompanion copyWith(
      {Value<String>? personId,
      Value<String>? fullName,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? preferredLanguage,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return PersonsCompanion(
      personId: personId ?? this.personId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('personId: $personId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bloodTypeMeta =
      const VerificationMeta('bloodType');
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
      'blood_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyContactNameMeta =
      const VerificationMeta('emergencyContactName');
  @override
  late final GeneratedColumn<String> emergencyContactName =
      GeneratedColumn<String>('emergency_contact_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>('emergency_contact_phone', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timezoneMeta =
      const VerificationMeta('timezone');
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        patientId,
        dateOfBirth,
        sex,
        bloodType,
        emergencyContactName,
        emergencyContactPhone,
        notes,
        timezone,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    }
    if (data.containsKey('blood_type')) {
      context.handle(_bloodTypeMeta,
          bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta));
    }
    if (data.containsKey('emergency_contact_name')) {
      context.handle(
          _emergencyContactNameMeta,
          emergencyContactName.isAcceptableOrUnknown(
              data['emergency_contact_name']!, _emergencyContactNameMeta));
    }
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
          _emergencyContactPhoneMeta,
          emergencyContactPhone.isAcceptableOrUnknown(
              data['emergency_contact_phone']!, _emergencyContactPhoneMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('timezone')) {
      context.handle(_timezoneMeta,
          timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta));
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {patientId};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_of_birth']),
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex']),
      bloodType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_type']),
      emergencyContactName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_name']),
      emergencyContactPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_phone']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String patientId;
  final String? dateOfBirth;
  final String? sex;
  final String? bloodType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? notes;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Patient(
      {required this.patientId,
      this.dateOfBirth,
      this.sex,
      this.bloodType,
      this.emergencyContactName,
      this.emergencyContactPhone,
      this.notes,
      required this.timezone,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || bloodType != null) {
      map['blood_type'] = Variable<String>(bloodType);
    }
    if (!nullToAbsent || emergencyContactName != null) {
      map['emergency_contact_name'] = Variable<String>(emergencyContactName);
    }
    if (!nullToAbsent || emergencyContactPhone != null) {
      map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['timezone'] = Variable<String>(timezone);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      patientId: Value(patientId),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      bloodType: bloodType == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodType),
      emergencyContactName: emergencyContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactName),
      emergencyContactPhone: emergencyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactPhone),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      timezone: Value(timezone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      patientId: serializer.fromJson<String>(json['patientId']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      sex: serializer.fromJson<String?>(json['sex']),
      bloodType: serializer.fromJson<String?>(json['bloodType']),
      emergencyContactName:
          serializer.fromJson<String?>(json['emergencyContactName']),
      emergencyContactPhone:
          serializer.fromJson<String?>(json['emergencyContactPhone']),
      notes: serializer.fromJson<String?>(json['notes']),
      timezone: serializer.fromJson<String>(json['timezone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'patientId': serializer.toJson<String>(patientId),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'sex': serializer.toJson<String?>(sex),
      'bloodType': serializer.toJson<String?>(bloodType),
      'emergencyContactName': serializer.toJson<String?>(emergencyContactName),
      'emergencyContactPhone':
          serializer.toJson<String?>(emergencyContactPhone),
      'notes': serializer.toJson<String?>(notes),
      'timezone': serializer.toJson<String>(timezone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Patient copyWith(
          {String? patientId,
          Value<String?> dateOfBirth = const Value.absent(),
          Value<String?> sex = const Value.absent(),
          Value<String?> bloodType = const Value.absent(),
          Value<String?> emergencyContactName = const Value.absent(),
          Value<String?> emergencyContactPhone = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? timezone,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Patient(
        patientId: patientId ?? this.patientId,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        sex: sex.present ? sex.value : this.sex,
        bloodType: bloodType.present ? bloodType.value : this.bloodType,
        emergencyContactName: emergencyContactName.present
            ? emergencyContactName.value
            : this.emergencyContactName,
        emergencyContactPhone: emergencyContactPhone.present
            ? emergencyContactPhone.value
            : this.emergencyContactPhone,
        notes: notes.present ? notes.value : this.notes,
        timezone: timezone ?? this.timezone,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      sex: data.sex.present ? data.sex.value : this.sex,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      emergencyContactName: data.emergencyContactName.present
          ? data.emergencyContactName.value
          : this.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
      notes: data.notes.present ? data.notes.value : this.notes,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('patientId: $patientId, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('bloodType: $bloodType, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('notes: $notes, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      patientId,
      dateOfBirth,
      sex,
      bloodType,
      emergencyContactName,
      emergencyContactPhone,
      notes,
      timezone,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.patientId == this.patientId &&
          other.dateOfBirth == this.dateOfBirth &&
          other.sex == this.sex &&
          other.bloodType == this.bloodType &&
          other.emergencyContactName == this.emergencyContactName &&
          other.emergencyContactPhone == this.emergencyContactPhone &&
          other.notes == this.notes &&
          other.timezone == this.timezone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> patientId;
  final Value<String?> dateOfBirth;
  final Value<String?> sex;
  final Value<String?> bloodType;
  final Value<String?> emergencyContactName;
  final Value<String?> emergencyContactPhone;
  final Value<String?> notes;
  final Value<String> timezone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PatientsCompanion({
    this.patientId = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.sex = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.notes = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String patientId,
    this.dateOfBirth = const Value.absent(),
    this.sex = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.notes = const Value.absent(),
    required String timezone,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : patientId = Value(patientId),
        timezone = Value(timezone),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Patient> custom({
    Expression<String>? patientId,
    Expression<String>? dateOfBirth,
    Expression<String>? sex,
    Expression<String>? bloodType,
    Expression<String>? emergencyContactName,
    Expression<String>? emergencyContactPhone,
    Expression<String>? notes,
    Expression<String>? timezone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (patientId != null) 'patient_id': patientId,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (sex != null) 'sex': sex,
      if (bloodType != null) 'blood_type': bloodType,
      if (emergencyContactName != null)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (notes != null) 'notes': notes,
      if (timezone != null) 'timezone': timezone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? patientId,
      Value<String?>? dateOfBirth,
      Value<String?>? sex,
      Value<String?>? bloodType,
      Value<String?>? emergencyContactName,
      Value<String?>? emergencyContactPhone,
      Value<String?>? notes,
      Value<String>? timezone,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return PatientsCompanion(
      patientId: patientId ?? this.patientId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      bloodType: bloodType ?? this.bloodType,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      notes: notes ?? this.notes,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (emergencyContactName.present) {
      map['emergency_contact_name'] =
          Variable<String>(emergencyContactName.value);
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] =
          Variable<String>(emergencyContactPhone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('patientId: $patientId, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('bloodType: $bloodType, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('notes: $notes, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaregiverAssignmentsTable extends CaregiverAssignments
    with TableInfo<$CaregiverAssignmentsTable, CaregiverAssignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaregiverAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assignmentIdMeta =
      const VerificationMeta('assignmentId');
  @override
  late final GeneratedColumn<String> assignmentId = GeneratedColumn<String>(
      'assignment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caregiverPersonIdMeta =
      const VerificationMeta('caregiverPersonId');
  @override
  late final GeneratedColumn<String> caregiverPersonId =
      GeneratedColumn<String>('caregiver_person_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationshipMeta =
      const VerificationMeta('relationship');
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
      'relationship', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _removedAtMeta =
      const VerificationMeta('removedAt');
  @override
  late final GeneratedColumn<DateTime> removedAt = GeneratedColumn<DateTime>(
      'removed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        assignmentId,
        patientId,
        caregiverPersonId,
        relationship,
        createdAt,
        updatedAt,
        removedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caregiver_assignments';
  @override
  VerificationContext validateIntegrity(
      Insertable<CaregiverAssignment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('assignment_id')) {
      context.handle(
          _assignmentIdMeta,
          assignmentId.isAcceptableOrUnknown(
              data['assignment_id']!, _assignmentIdMeta));
    } else if (isInserting) {
      context.missing(_assignmentIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('caregiver_person_id')) {
      context.handle(
          _caregiverPersonIdMeta,
          caregiverPersonId.isAcceptableOrUnknown(
              data['caregiver_person_id']!, _caregiverPersonIdMeta));
    } else if (isInserting) {
      context.missing(_caregiverPersonIdMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
          _relationshipMeta,
          relationship.isAcceptableOrUnknown(
              data['relationship']!, _relationshipMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('removed_at')) {
      context.handle(_removedAtMeta,
          removedAt.isAcceptableOrUnknown(data['removed_at']!, _removedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assignmentId};
  @override
  CaregiverAssignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaregiverAssignment(
      assignmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assignment_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      caregiverPersonId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}caregiver_person_id'])!,
      relationship: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relationship']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      removedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}removed_at']),
    );
  }

  @override
  $CaregiverAssignmentsTable createAlias(String alias) {
    return $CaregiverAssignmentsTable(attachedDatabase, alias);
  }
}

class CaregiverAssignment extends DataClass
    implements Insertable<CaregiverAssignment> {
  final String assignmentId;
  final String patientId;
  final String caregiverPersonId;
  final String? relationship;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? removedAt;
  const CaregiverAssignment(
      {required this.assignmentId,
      required this.patientId,
      required this.caregiverPersonId,
      this.relationship,
      required this.createdAt,
      required this.updatedAt,
      this.removedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['assignment_id'] = Variable<String>(assignmentId);
    map['patient_id'] = Variable<String>(patientId);
    map['caregiver_person_id'] = Variable<String>(caregiverPersonId);
    if (!nullToAbsent || relationship != null) {
      map['relationship'] = Variable<String>(relationship);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || removedAt != null) {
      map['removed_at'] = Variable<DateTime>(removedAt);
    }
    return map;
  }

  CaregiverAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return CaregiverAssignmentsCompanion(
      assignmentId: Value(assignmentId),
      patientId: Value(patientId),
      caregiverPersonId: Value(caregiverPersonId),
      relationship: relationship == null && nullToAbsent
          ? const Value.absent()
          : Value(relationship),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      removedAt: removedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(removedAt),
    );
  }

  factory CaregiverAssignment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaregiverAssignment(
      assignmentId: serializer.fromJson<String>(json['assignmentId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      caregiverPersonId: serializer.fromJson<String>(json['caregiverPersonId']),
      relationship: serializer.fromJson<String?>(json['relationship']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      removedAt: serializer.fromJson<DateTime?>(json['removedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assignmentId': serializer.toJson<String>(assignmentId),
      'patientId': serializer.toJson<String>(patientId),
      'caregiverPersonId': serializer.toJson<String>(caregiverPersonId),
      'relationship': serializer.toJson<String?>(relationship),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'removedAt': serializer.toJson<DateTime?>(removedAt),
    };
  }

  CaregiverAssignment copyWith(
          {String? assignmentId,
          String? patientId,
          String? caregiverPersonId,
          Value<String?> relationship = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> removedAt = const Value.absent()}) =>
      CaregiverAssignment(
        assignmentId: assignmentId ?? this.assignmentId,
        patientId: patientId ?? this.patientId,
        caregiverPersonId: caregiverPersonId ?? this.caregiverPersonId,
        relationship:
            relationship.present ? relationship.value : this.relationship,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        removedAt: removedAt.present ? removedAt.value : this.removedAt,
      );
  CaregiverAssignment copyWithCompanion(CaregiverAssignmentsCompanion data) {
    return CaregiverAssignment(
      assignmentId: data.assignmentId.present
          ? data.assignmentId.value
          : this.assignmentId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      caregiverPersonId: data.caregiverPersonId.present
          ? data.caregiverPersonId.value
          : this.caregiverPersonId,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      removedAt: data.removedAt.present ? data.removedAt.value : this.removedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverAssignment(')
          ..write('assignmentId: $assignmentId, ')
          ..write('patientId: $patientId, ')
          ..write('caregiverPersonId: $caregiverPersonId, ')
          ..write('relationship: $relationship, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('removedAt: $removedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assignmentId, patientId, caregiverPersonId,
      relationship, createdAt, updatedAt, removedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaregiverAssignment &&
          other.assignmentId == this.assignmentId &&
          other.patientId == this.patientId &&
          other.caregiverPersonId == this.caregiverPersonId &&
          other.relationship == this.relationship &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.removedAt == this.removedAt);
}

class CaregiverAssignmentsCompanion
    extends UpdateCompanion<CaregiverAssignment> {
  final Value<String> assignmentId;
  final Value<String> patientId;
  final Value<String> caregiverPersonId;
  final Value<String?> relationship;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> removedAt;
  final Value<int> rowid;
  const CaregiverAssignmentsCompanion({
    this.assignmentId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.caregiverPersonId = const Value.absent(),
    this.relationship = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.removedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaregiverAssignmentsCompanion.insert({
    required String assignmentId,
    required String patientId,
    required String caregiverPersonId,
    this.relationship = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.removedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : assignmentId = Value(assignmentId),
        patientId = Value(patientId),
        caregiverPersonId = Value(caregiverPersonId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CaregiverAssignment> custom({
    Expression<String>? assignmentId,
    Expression<String>? patientId,
    Expression<String>? caregiverPersonId,
    Expression<String>? relationship,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? removedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assignmentId != null) 'assignment_id': assignmentId,
      if (patientId != null) 'patient_id': patientId,
      if (caregiverPersonId != null) 'caregiver_person_id': caregiverPersonId,
      if (relationship != null) 'relationship': relationship,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (removedAt != null) 'removed_at': removedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaregiverAssignmentsCompanion copyWith(
      {Value<String>? assignmentId,
      Value<String>? patientId,
      Value<String>? caregiverPersonId,
      Value<String?>? relationship,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? removedAt,
      Value<int>? rowid}) {
    return CaregiverAssignmentsCompanion(
      assignmentId: assignmentId ?? this.assignmentId,
      patientId: patientId ?? this.patientId,
      caregiverPersonId: caregiverPersonId ?? this.caregiverPersonId,
      relationship: relationship ?? this.relationship,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      removedAt: removedAt ?? this.removedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assignmentId.present) {
      map['assignment_id'] = Variable<String>(assignmentId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (caregiverPersonId.present) {
      map['caregiver_person_id'] = Variable<String>(caregiverPersonId.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (removedAt.present) {
      map['removed_at'] = Variable<DateTime>(removedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaregiverAssignmentsCompanion(')
          ..write('assignmentId: $assignmentId, ')
          ..write('patientId: $patientId, ')
          ..write('caregiverPersonId: $caregiverPersonId, ')
          ..write('relationship: $relationship, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('removedAt: $removedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatientIllnessesTable extends PatientIllnesses
    with TableInfo<$PatientIllnessesTable, Illness> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientIllnessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _illnessIdMeta =
      const VerificationMeta('illnessId');
  @override
  late final GeneratedColumn<String> illnessId = GeneratedColumn<String>(
      'illness_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conditionNameMeta =
      const VerificationMeta('conditionName');
  @override
  late final GeneratedColumn<String> conditionName = GeneratedColumn<String>(
      'condition_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diagnosedDateMeta =
      const VerificationMeta('diagnosedDate');
  @override
  late final GeneratedColumn<String> diagnosedDate = GeneratedColumn<String>(
      'diagnosed_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        illnessId,
        patientId,
        conditionName,
        diagnosedDate,
        notes,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_illnesses';
  @override
  VerificationContext validateIntegrity(Insertable<Illness> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('illness_id')) {
      context.handle(_illnessIdMeta,
          illnessId.isAcceptableOrUnknown(data['illness_id']!, _illnessIdMeta));
    } else if (isInserting) {
      context.missing(_illnessIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('condition_name')) {
      context.handle(
          _conditionNameMeta,
          conditionName.isAcceptableOrUnknown(
              data['condition_name']!, _conditionNameMeta));
    } else if (isInserting) {
      context.missing(_conditionNameMeta);
    }
    if (data.containsKey('diagnosed_date')) {
      context.handle(
          _diagnosedDateMeta,
          diagnosedDate.isAcceptableOrUnknown(
              data['diagnosed_date']!, _diagnosedDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {illnessId};
  @override
  Illness map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Illness(
      illnessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}illness_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      conditionName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condition_name'])!,
      diagnosedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagnosed_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $PatientIllnessesTable createAlias(String alias) {
    return $PatientIllnessesTable(attachedDatabase, alias);
  }
}

class Illness extends DataClass implements Insertable<Illness> {
  final String illnessId;
  final String patientId;
  final String conditionName;
  final String? diagnosedDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Illness(
      {required this.illnessId,
      required this.patientId,
      required this.conditionName,
      this.diagnosedDate,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['illness_id'] = Variable<String>(illnessId);
    map['patient_id'] = Variable<String>(patientId);
    map['condition_name'] = Variable<String>(conditionName);
    if (!nullToAbsent || diagnosedDate != null) {
      map['diagnosed_date'] = Variable<String>(diagnosedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PatientIllnessesCompanion toCompanion(bool nullToAbsent) {
    return PatientIllnessesCompanion(
      illnessId: Value(illnessId),
      patientId: Value(patientId),
      conditionName: Value(conditionName),
      diagnosedDate: diagnosedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosedDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Illness.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Illness(
      illnessId: serializer.fromJson<String>(json['illnessId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      conditionName: serializer.fromJson<String>(json['conditionName']),
      diagnosedDate: serializer.fromJson<String?>(json['diagnosedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'illnessId': serializer.toJson<String>(illnessId),
      'patientId': serializer.toJson<String>(patientId),
      'conditionName': serializer.toJson<String>(conditionName),
      'diagnosedDate': serializer.toJson<String?>(diagnosedDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Illness copyWith(
          {String? illnessId,
          String? patientId,
          String? conditionName,
          Value<String?> diagnosedDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Illness(
        illnessId: illnessId ?? this.illnessId,
        patientId: patientId ?? this.patientId,
        conditionName: conditionName ?? this.conditionName,
        diagnosedDate:
            diagnosedDate.present ? diagnosedDate.value : this.diagnosedDate,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Illness copyWithCompanion(PatientIllnessesCompanion data) {
    return Illness(
      illnessId: data.illnessId.present ? data.illnessId.value : this.illnessId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      conditionName: data.conditionName.present
          ? data.conditionName.value
          : this.conditionName,
      diagnosedDate: data.diagnosedDate.present
          ? data.diagnosedDate.value
          : this.diagnosedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Illness(')
          ..write('illnessId: $illnessId, ')
          ..write('patientId: $patientId, ')
          ..write('conditionName: $conditionName, ')
          ..write('diagnosedDate: $diagnosedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(illnessId, patientId, conditionName,
      diagnosedDate, notes, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Illness &&
          other.illnessId == this.illnessId &&
          other.patientId == this.patientId &&
          other.conditionName == this.conditionName &&
          other.diagnosedDate == this.diagnosedDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PatientIllnessesCompanion extends UpdateCompanion<Illness> {
  final Value<String> illnessId;
  final Value<String> patientId;
  final Value<String> conditionName;
  final Value<String?> diagnosedDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PatientIllnessesCompanion({
    this.illnessId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.conditionName = const Value.absent(),
    this.diagnosedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientIllnessesCompanion.insert({
    required String illnessId,
    required String patientId,
    required String conditionName,
    this.diagnosedDate = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : illnessId = Value(illnessId),
        patientId = Value(patientId),
        conditionName = Value(conditionName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Illness> custom({
    Expression<String>? illnessId,
    Expression<String>? patientId,
    Expression<String>? conditionName,
    Expression<String>? diagnosedDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (illnessId != null) 'illness_id': illnessId,
      if (patientId != null) 'patient_id': patientId,
      if (conditionName != null) 'condition_name': conditionName,
      if (diagnosedDate != null) 'diagnosed_date': diagnosedDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientIllnessesCompanion copyWith(
      {Value<String>? illnessId,
      Value<String>? patientId,
      Value<String>? conditionName,
      Value<String?>? diagnosedDate,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return PatientIllnessesCompanion(
      illnessId: illnessId ?? this.illnessId,
      patientId: patientId ?? this.patientId,
      conditionName: conditionName ?? this.conditionName,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (illnessId.present) {
      map['illness_id'] = Variable<String>(illnessId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (conditionName.present) {
      map['condition_name'] = Variable<String>(conditionName.value);
    }
    if (diagnosedDate.present) {
      map['diagnosed_date'] = Variable<String>(diagnosedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientIllnessesCompanion(')
          ..write('illnessId: $illnessId, ')
          ..write('patientId: $patientId, ')
          ..write('conditionName: $conditionName, ')
          ..write('diagnosedDate: $diagnosedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _catalogIdMeta =
      const VerificationMeta('catalogId');
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
      'catalog_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _strengthMeta =
      const VerificationMeta('strength');
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
      'strength', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dosageFormMeta =
      const VerificationMeta('dosageForm');
  @override
  late final GeneratedColumn<String> dosageForm = GeneratedColumn<String>(
      'dosage_form', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
      'route', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _doseUnitMeta =
      const VerificationMeta('doseUnit');
  @override
  late final GeneratedColumn<String> doseUnit = GeneratedColumn<String>(
      'dose_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsEnMeta =
      const VerificationMeta('instructionsEn');
  @override
  late final GeneratedColumn<String> instructionsEn = GeneratedColumn<String>(
      'instructions_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instructionsArMeta =
      const VerificationMeta('instructionsAr');
  @override
  late final GeneratedColumn<String> instructionsAr = GeneratedColumn<String>(
      'instructions_ar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPrnMeta = const VerificationMeta('isPrn');
  @override
  late final GeneratedColumn<bool> isPrn = GeneratedColumn<bool>(
      'is_prn', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_prn" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _maximumDailyQuantityScaledMeta =
      const VerificationMeta('maximumDailyQuantityScaled');
  @override
  late final GeneratedColumn<int> maximumDailyQuantityScaled =
      GeneratedColumn<int>('maximum_daily_quantity_scaled', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _catalogPriceEgpMeta =
      const VerificationMeta('catalogPriceEgp');
  @override
  late final GeneratedColumn<double> catalogPriceEgp = GeneratedColumn<double>(
      'catalog_price_egp', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _storageOnlyMeta =
      const VerificationMeta('storageOnly');
  @override
  late final GeneratedColumn<bool> storageOnly = GeneratedColumn<bool>(
      'storage_only', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("storage_only" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        medicationId,
        patientId,
        catalogId,
        nameEn,
        nameAr,
        scientificName,
        strength,
        dosageForm,
        route,
        doseUnit,
        instructionsEn,
        instructionsAr,
        startDate,
        endDate,
        isPrn,
        maximumDailyQuantityScaled,
        catalogPriceEgp,
        storageOnly,
        status,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('catalog_id')) {
      context.handle(_catalogIdMeta,
          catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    }
    if (data.containsKey('strength')) {
      context.handle(_strengthMeta,
          strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta));
    }
    if (data.containsKey('dosage_form')) {
      context.handle(
          _dosageFormMeta,
          dosageForm.isAcceptableOrUnknown(
              data['dosage_form']!, _dosageFormMeta));
    }
    if (data.containsKey('route')) {
      context.handle(
          _routeMeta, route.isAcceptableOrUnknown(data['route']!, _routeMeta));
    }
    if (data.containsKey('dose_unit')) {
      context.handle(_doseUnitMeta,
          doseUnit.isAcceptableOrUnknown(data['dose_unit']!, _doseUnitMeta));
    } else if (isInserting) {
      context.missing(_doseUnitMeta);
    }
    if (data.containsKey('instructions_en')) {
      context.handle(
          _instructionsEnMeta,
          instructionsEn.isAcceptableOrUnknown(
              data['instructions_en']!, _instructionsEnMeta));
    }
    if (data.containsKey('instructions_ar')) {
      context.handle(
          _instructionsArMeta,
          instructionsAr.isAcceptableOrUnknown(
              data['instructions_ar']!, _instructionsArMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('is_prn')) {
      context.handle(
          _isPrnMeta, isPrn.isAcceptableOrUnknown(data['is_prn']!, _isPrnMeta));
    }
    if (data.containsKey('maximum_daily_quantity_scaled')) {
      context.handle(
          _maximumDailyQuantityScaledMeta,
          maximumDailyQuantityScaled.isAcceptableOrUnknown(
              data['maximum_daily_quantity_scaled']!,
              _maximumDailyQuantityScaledMeta));
    }
    if (data.containsKey('catalog_price_egp')) {
      context.handle(
          _catalogPriceEgpMeta,
          catalogPriceEgp.isAcceptableOrUnknown(
              data['catalog_price_egp']!, _catalogPriceEgpMeta));
    }
    if (data.containsKey('storage_only')) {
      context.handle(
          _storageOnlyMeta,
          storageOnly.isAcceptableOrUnknown(
              data['storage_only']!, _storageOnlyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicationId};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      catalogId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}catalog_id']),
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
      scientificName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scientific_name']),
      strength: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength']),
      dosageForm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_form']),
      route: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route']),
      doseUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose_unit'])!,
      instructionsEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions_en']),
      instructionsAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions_ar']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      isPrn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_prn'])!,
      maximumDailyQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}maximum_daily_quantity_scaled']),
      catalogPriceEgp: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}catalog_price_egp']),
      storageOnly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}storage_only'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String medicationId;
  final String patientId;
  final String? catalogId;
  final String nameEn;
  final String? nameAr;
  final String? scientificName;
  final String? strength;
  final String? dosageForm;
  final String? route;
  final String doseUnit;
  final String? instructionsEn;
  final String? instructionsAr;
  final String? startDate;
  final String? endDate;
  final bool isPrn;
  final int? maximumDailyQuantityScaled;
  final double? catalogPriceEgp;

  /// Stock kept in storage without being part of the patient's treatment.
  final bool storageOnly;

  /// `active` or `archived`.
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Medication(
      {required this.medicationId,
      required this.patientId,
      this.catalogId,
      required this.nameEn,
      this.nameAr,
      this.scientificName,
      this.strength,
      this.dosageForm,
      this.route,
      required this.doseUnit,
      this.instructionsEn,
      this.instructionsAr,
      this.startDate,
      this.endDate,
      required this.isPrn,
      this.maximumDailyQuantityScaled,
      this.catalogPriceEgp,
      required this.storageOnly,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medication_id'] = Variable<String>(medicationId);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    if (!nullToAbsent || scientificName != null) {
      map['scientific_name'] = Variable<String>(scientificName);
    }
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || dosageForm != null) {
      map['dosage_form'] = Variable<String>(dosageForm);
    }
    if (!nullToAbsent || route != null) {
      map['route'] = Variable<String>(route);
    }
    map['dose_unit'] = Variable<String>(doseUnit);
    if (!nullToAbsent || instructionsEn != null) {
      map['instructions_en'] = Variable<String>(instructionsEn);
    }
    if (!nullToAbsent || instructionsAr != null) {
      map['instructions_ar'] = Variable<String>(instructionsAr);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['is_prn'] = Variable<bool>(isPrn);
    if (!nullToAbsent || maximumDailyQuantityScaled != null) {
      map['maximum_daily_quantity_scaled'] =
          Variable<int>(maximumDailyQuantityScaled);
    }
    if (!nullToAbsent || catalogPriceEgp != null) {
      map['catalog_price_egp'] = Variable<double>(catalogPriceEgp);
    }
    map['storage_only'] = Variable<bool>(storageOnly);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      medicationId: Value(medicationId),
      patientId: Value(patientId),
      catalogId: catalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogId),
      nameEn: Value(nameEn),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      scientificName: scientificName == null && nullToAbsent
          ? const Value.absent()
          : Value(scientificName),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      dosageForm: dosageForm == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageForm),
      route:
          route == null && nullToAbsent ? const Value.absent() : Value(route),
      doseUnit: Value(doseUnit),
      instructionsEn: instructionsEn == null && nullToAbsent
          ? const Value.absent()
          : Value(instructionsEn),
      instructionsAr: instructionsAr == null && nullToAbsent
          ? const Value.absent()
          : Value(instructionsAr),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isPrn: Value(isPrn),
      maximumDailyQuantityScaled:
          maximumDailyQuantityScaled == null && nullToAbsent
              ? const Value.absent()
              : Value(maximumDailyQuantityScaled),
      catalogPriceEgp: catalogPriceEgp == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogPriceEgp),
      storageOnly: Value(storageOnly),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      medicationId: serializer.fromJson<String>(json['medicationId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      scientificName: serializer.fromJson<String?>(json['scientificName']),
      strength: serializer.fromJson<String?>(json['strength']),
      dosageForm: serializer.fromJson<String?>(json['dosageForm']),
      route: serializer.fromJson<String?>(json['route']),
      doseUnit: serializer.fromJson<String>(json['doseUnit']),
      instructionsEn: serializer.fromJson<String?>(json['instructionsEn']),
      instructionsAr: serializer.fromJson<String?>(json['instructionsAr']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      isPrn: serializer.fromJson<bool>(json['isPrn']),
      maximumDailyQuantityScaled:
          serializer.fromJson<int?>(json['maximumDailyQuantityScaled']),
      catalogPriceEgp: serializer.fromJson<double?>(json['catalogPriceEgp']),
      storageOnly: serializer.fromJson<bool>(json['storageOnly']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicationId': serializer.toJson<String>(medicationId),
      'patientId': serializer.toJson<String>(patientId),
      'catalogId': serializer.toJson<String?>(catalogId),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String?>(nameAr),
      'scientificName': serializer.toJson<String?>(scientificName),
      'strength': serializer.toJson<String?>(strength),
      'dosageForm': serializer.toJson<String?>(dosageForm),
      'route': serializer.toJson<String?>(route),
      'doseUnit': serializer.toJson<String>(doseUnit),
      'instructionsEn': serializer.toJson<String?>(instructionsEn),
      'instructionsAr': serializer.toJson<String?>(instructionsAr),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'isPrn': serializer.toJson<bool>(isPrn),
      'maximumDailyQuantityScaled':
          serializer.toJson<int?>(maximumDailyQuantityScaled),
      'catalogPriceEgp': serializer.toJson<double?>(catalogPriceEgp),
      'storageOnly': serializer.toJson<bool>(storageOnly),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Medication copyWith(
          {String? medicationId,
          String? patientId,
          Value<String?> catalogId = const Value.absent(),
          String? nameEn,
          Value<String?> nameAr = const Value.absent(),
          Value<String?> scientificName = const Value.absent(),
          Value<String?> strength = const Value.absent(),
          Value<String?> dosageForm = const Value.absent(),
          Value<String?> route = const Value.absent(),
          String? doseUnit,
          Value<String?> instructionsEn = const Value.absent(),
          Value<String?> instructionsAr = const Value.absent(),
          Value<String?> startDate = const Value.absent(),
          Value<String?> endDate = const Value.absent(),
          bool? isPrn,
          Value<int?> maximumDailyQuantityScaled = const Value.absent(),
          Value<double?> catalogPriceEgp = const Value.absent(),
          bool? storageOnly,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Medication(
        medicationId: medicationId ?? this.medicationId,
        patientId: patientId ?? this.patientId,
        catalogId: catalogId.present ? catalogId.value : this.catalogId,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
        scientificName:
            scientificName.present ? scientificName.value : this.scientificName,
        strength: strength.present ? strength.value : this.strength,
        dosageForm: dosageForm.present ? dosageForm.value : this.dosageForm,
        route: route.present ? route.value : this.route,
        doseUnit: doseUnit ?? this.doseUnit,
        instructionsEn:
            instructionsEn.present ? instructionsEn.value : this.instructionsEn,
        instructionsAr:
            instructionsAr.present ? instructionsAr.value : this.instructionsAr,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        isPrn: isPrn ?? this.isPrn,
        maximumDailyQuantityScaled: maximumDailyQuantityScaled.present
            ? maximumDailyQuantityScaled.value
            : this.maximumDailyQuantityScaled,
        catalogPriceEgp: catalogPriceEgp.present
            ? catalogPriceEgp.value
            : this.catalogPriceEgp,
        storageOnly: storageOnly ?? this.storageOnly,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      strength: data.strength.present ? data.strength.value : this.strength,
      dosageForm:
          data.dosageForm.present ? data.dosageForm.value : this.dosageForm,
      route: data.route.present ? data.route.value : this.route,
      doseUnit: data.doseUnit.present ? data.doseUnit.value : this.doseUnit,
      instructionsEn: data.instructionsEn.present
          ? data.instructionsEn.value
          : this.instructionsEn,
      instructionsAr: data.instructionsAr.present
          ? data.instructionsAr.value
          : this.instructionsAr,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isPrn: data.isPrn.present ? data.isPrn.value : this.isPrn,
      maximumDailyQuantityScaled: data.maximumDailyQuantityScaled.present
          ? data.maximumDailyQuantityScaled.value
          : this.maximumDailyQuantityScaled,
      catalogPriceEgp: data.catalogPriceEgp.present
          ? data.catalogPriceEgp.value
          : this.catalogPriceEgp,
      storageOnly:
          data.storageOnly.present ? data.storageOnly.value : this.storageOnly,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('medicationId: $medicationId, ')
          ..write('patientId: $patientId, ')
          ..write('catalogId: $catalogId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('scientificName: $scientificName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('route: $route, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructionsEn: $instructionsEn, ')
          ..write('instructionsAr: $instructionsAr, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isPrn: $isPrn, ')
          ..write('maximumDailyQuantityScaled: $maximumDailyQuantityScaled, ')
          ..write('catalogPriceEgp: $catalogPriceEgp, ')
          ..write('storageOnly: $storageOnly, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        medicationId,
        patientId,
        catalogId,
        nameEn,
        nameAr,
        scientificName,
        strength,
        dosageForm,
        route,
        doseUnit,
        instructionsEn,
        instructionsAr,
        startDate,
        endDate,
        isPrn,
        maximumDailyQuantityScaled,
        catalogPriceEgp,
        storageOnly,
        status,
        createdAt,
        updatedAt,
        deletedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.medicationId == this.medicationId &&
          other.patientId == this.patientId &&
          other.catalogId == this.catalogId &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.scientificName == this.scientificName &&
          other.strength == this.strength &&
          other.dosageForm == this.dosageForm &&
          other.route == this.route &&
          other.doseUnit == this.doseUnit &&
          other.instructionsEn == this.instructionsEn &&
          other.instructionsAr == this.instructionsAr &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isPrn == this.isPrn &&
          other.maximumDailyQuantityScaled == this.maximumDailyQuantityScaled &&
          other.catalogPriceEgp == this.catalogPriceEgp &&
          other.storageOnly == this.storageOnly &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> medicationId;
  final Value<String> patientId;
  final Value<String?> catalogId;
  final Value<String> nameEn;
  final Value<String?> nameAr;
  final Value<String?> scientificName;
  final Value<String?> strength;
  final Value<String?> dosageForm;
  final Value<String?> route;
  final Value<String> doseUnit;
  final Value<String?> instructionsEn;
  final Value<String?> instructionsAr;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<bool> isPrn;
  final Value<int?> maximumDailyQuantityScaled;
  final Value<double?> catalogPriceEgp;
  final Value<bool> storageOnly;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.medicationId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.route = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructionsEn = const Value.absent(),
    this.instructionsAr = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.maximumDailyQuantityScaled = const Value.absent(),
    this.catalogPriceEgp = const Value.absent(),
    this.storageOnly = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String medicationId,
    required String patientId,
    this.catalogId = const Value.absent(),
    required String nameEn,
    this.nameAr = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.route = const Value.absent(),
    required String doseUnit,
    this.instructionsEn = const Value.absent(),
    this.instructionsAr = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.maximumDailyQuantityScaled = const Value.absent(),
    this.catalogPriceEgp = const Value.absent(),
    this.storageOnly = const Value.absent(),
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : medicationId = Value(medicationId),
        patientId = Value(patientId),
        nameEn = Value(nameEn),
        doseUnit = Value(doseUnit),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Medication> custom({
    Expression<String>? medicationId,
    Expression<String>? patientId,
    Expression<String>? catalogId,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? scientificName,
    Expression<String>? strength,
    Expression<String>? dosageForm,
    Expression<String>? route,
    Expression<String>? doseUnit,
    Expression<String>? instructionsEn,
    Expression<String>? instructionsAr,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<bool>? isPrn,
    Expression<int>? maximumDailyQuantityScaled,
    Expression<double>? catalogPriceEgp,
    Expression<bool>? storageOnly,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicationId != null) 'medication_id': medicationId,
      if (patientId != null) 'patient_id': patientId,
      if (catalogId != null) 'catalog_id': catalogId,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (scientificName != null) 'scientific_name': scientificName,
      if (strength != null) 'strength': strength,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (route != null) 'route': route,
      if (doseUnit != null) 'dose_unit': doseUnit,
      if (instructionsEn != null) 'instructions_en': instructionsEn,
      if (instructionsAr != null) 'instructions_ar': instructionsAr,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isPrn != null) 'is_prn': isPrn,
      if (maximumDailyQuantityScaled != null)
        'maximum_daily_quantity_scaled': maximumDailyQuantityScaled,
      if (catalogPriceEgp != null) 'catalog_price_egp': catalogPriceEgp,
      if (storageOnly != null) 'storage_only': storageOnly,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith(
      {Value<String>? medicationId,
      Value<String>? patientId,
      Value<String?>? catalogId,
      Value<String>? nameEn,
      Value<String?>? nameAr,
      Value<String?>? scientificName,
      Value<String?>? strength,
      Value<String?>? dosageForm,
      Value<String?>? route,
      Value<String>? doseUnit,
      Value<String?>? instructionsEn,
      Value<String?>? instructionsAr,
      Value<String?>? startDate,
      Value<String?>? endDate,
      Value<bool>? isPrn,
      Value<int?>? maximumDailyQuantityScaled,
      Value<double?>? catalogPriceEgp,
      Value<bool>? storageOnly,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return MedicationsCompanion(
      medicationId: medicationId ?? this.medicationId,
      patientId: patientId ?? this.patientId,
      catalogId: catalogId ?? this.catalogId,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      scientificName: scientificName ?? this.scientificName,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      route: route ?? this.route,
      doseUnit: doseUnit ?? this.doseUnit,
      instructionsEn: instructionsEn ?? this.instructionsEn,
      instructionsAr: instructionsAr ?? this.instructionsAr,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isPrn: isPrn ?? this.isPrn,
      maximumDailyQuantityScaled:
          maximumDailyQuantityScaled ?? this.maximumDailyQuantityScaled,
      catalogPriceEgp: catalogPriceEgp ?? this.catalogPriceEgp,
      storageOnly: storageOnly ?? this.storageOnly,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (dosageForm.present) {
      map['dosage_form'] = Variable<String>(dosageForm.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (doseUnit.present) {
      map['dose_unit'] = Variable<String>(doseUnit.value);
    }
    if (instructionsEn.present) {
      map['instructions_en'] = Variable<String>(instructionsEn.value);
    }
    if (instructionsAr.present) {
      map['instructions_ar'] = Variable<String>(instructionsAr.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (isPrn.present) {
      map['is_prn'] = Variable<bool>(isPrn.value);
    }
    if (maximumDailyQuantityScaled.present) {
      map['maximum_daily_quantity_scaled'] =
          Variable<int>(maximumDailyQuantityScaled.value);
    }
    if (catalogPriceEgp.present) {
      map['catalog_price_egp'] = Variable<double>(catalogPriceEgp.value);
    }
    if (storageOnly.present) {
      map['storage_only'] = Variable<bool>(storageOnly.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('medicationId: $medicationId, ')
          ..write('patientId: $patientId, ')
          ..write('catalogId: $catalogId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('scientificName: $scientificName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('route: $route, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructionsEn: $instructionsEn, ')
          ..write('instructionsAr: $instructionsAr, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isPrn: $isPrn, ')
          ..write('maximumDailyQuantityScaled: $maximumDailyQuantityScaled, ')
          ..write('catalogPriceEgp: $catalogPriceEgp, ')
          ..write('storageOnly: $storageOnly, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationInventoryBatchesTable extends MedicationInventoryBatches
    with TableInfo<$MedicationInventoryBatchesTable, InventoryBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationInventoryBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _inventoryBatchIdMeta =
      const VerificationMeta('inventoryBatchId');
  @override
  late final GeneratedColumn<String> inventoryBatchId = GeneratedColumn<String>(
      'inventory_batch_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
      'purchase_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _expirationDateMeta =
      const VerificationMeta('expirationDate');
  @override
  late final GeneratedColumn<String> expirationDate = GeneratedColumn<String>(
      'expiration_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _packagingTypeMeta =
      const VerificationMeta('packagingType');
  @override
  late final GeneratedColumn<String> packagingType = GeneratedColumn<String>(
      'packaging_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitsPerPackageMeta =
      const VerificationMeta('unitsPerPackage');
  @override
  late final GeneratedColumn<int> unitsPerPackage = GeneratedColumn<int>(
      'units_per_package', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _packagesCountMeta =
      const VerificationMeta('packagesCount');
  @override
  late final GeneratedColumn<int> packagesCount = GeneratedColumn<int>(
      'packages_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subPackagingTypeMeta =
      const VerificationMeta('subPackagingType');
  @override
  late final GeneratedColumn<String> subPackagingType = GeneratedColumn<String>(
      'sub_packaging_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subPackagesPerPackageMeta =
      const VerificationMeta('subPackagesPerPackage');
  @override
  late final GeneratedColumn<int> subPackagesPerPackage = GeneratedColumn<int>(
      'sub_packages_per_package', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _looseQuantityScaledMeta =
      const VerificationMeta('looseQuantityScaled');
  @override
  late final GeneratedColumn<int> looseQuantityScaled = GeneratedColumn<int>(
      'loose_quantity_scaled', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _initialQuantityScaledMeta =
      const VerificationMeta('initialQuantityScaled');
  @override
  late final GeneratedColumn<int> initialQuantityScaled = GeneratedColumn<int>(
      'initial_quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _availableQuantityScaledMeta =
      const VerificationMeta('availableQuantityScaled');
  @override
  late final GeneratedColumn<int> availableQuantityScaled =
      GeneratedColumn<int>('available_quantity_scaled', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _isDepletedMeta =
      const VerificationMeta('isDepleted');
  @override
  late final GeneratedColumn<bool> isDepleted = GeneratedColumn<bool>(
      'is_depleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_depleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        inventoryBatchId,
        medicationId,
        purchaseDate,
        purchasePrice,
        expirationDate,
        packagingType,
        unitsPerPackage,
        packagesCount,
        subPackagingType,
        subPackagesPerPackage,
        looseQuantityScaled,
        initialQuantityScaled,
        availableQuantityScaled,
        quantityScale,
        isDepleted,
        notes,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_inventory_batches';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryBatch> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('inventory_batch_id')) {
      context.handle(
          _inventoryBatchIdMeta,
          inventoryBatchId.isAcceptableOrUnknown(
              data['inventory_batch_id']!, _inventoryBatchIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryBatchIdMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    }
    if (data.containsKey('expiration_date')) {
      context.handle(
          _expirationDateMeta,
          expirationDate.isAcceptableOrUnknown(
              data['expiration_date']!, _expirationDateMeta));
    }
    if (data.containsKey('packaging_type')) {
      context.handle(
          _packagingTypeMeta,
          packagingType.isAcceptableOrUnknown(
              data['packaging_type']!, _packagingTypeMeta));
    }
    if (data.containsKey('units_per_package')) {
      context.handle(
          _unitsPerPackageMeta,
          unitsPerPackage.isAcceptableOrUnknown(
              data['units_per_package']!, _unitsPerPackageMeta));
    }
    if (data.containsKey('packages_count')) {
      context.handle(
          _packagesCountMeta,
          packagesCount.isAcceptableOrUnknown(
              data['packages_count']!, _packagesCountMeta));
    }
    if (data.containsKey('sub_packaging_type')) {
      context.handle(
          _subPackagingTypeMeta,
          subPackagingType.isAcceptableOrUnknown(
              data['sub_packaging_type']!, _subPackagingTypeMeta));
    }
    if (data.containsKey('sub_packages_per_package')) {
      context.handle(
          _subPackagesPerPackageMeta,
          subPackagesPerPackage.isAcceptableOrUnknown(
              data['sub_packages_per_package']!, _subPackagesPerPackageMeta));
    }
    if (data.containsKey('loose_quantity_scaled')) {
      context.handle(
          _looseQuantityScaledMeta,
          looseQuantityScaled.isAcceptableOrUnknown(
              data['loose_quantity_scaled']!, _looseQuantityScaledMeta));
    }
    if (data.containsKey('initial_quantity_scaled')) {
      context.handle(
          _initialQuantityScaledMeta,
          initialQuantityScaled.isAcceptableOrUnknown(
              data['initial_quantity_scaled']!, _initialQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_initialQuantityScaledMeta);
    }
    if (data.containsKey('available_quantity_scaled')) {
      context.handle(
          _availableQuantityScaledMeta,
          availableQuantityScaled.isAcceptableOrUnknown(
              data['available_quantity_scaled']!,
              _availableQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_availableQuantityScaledMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('is_depleted')) {
      context.handle(
          _isDepletedMeta,
          isDepleted.isAcceptableOrUnknown(
              data['is_depleted']!, _isDepletedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {inventoryBatchId};
  @override
  InventoryBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBatch(
      inventoryBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_batch_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      purchaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_date']),
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price']),
      expirationDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expiration_date']),
      packagingType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}packaging_type']),
      unitsPerPackage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}units_per_package']),
      packagesCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}packages_count']),
      subPackagingType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sub_packaging_type']),
      subPackagesPerPackage: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}sub_packages_per_package']),
      looseQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}loose_quantity_scaled']),
      initialQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}initial_quantity_scaled'])!,
      availableQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}available_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      isDepleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_depleted'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $MedicationInventoryBatchesTable createAlias(String alias) {
    return $MedicationInventoryBatchesTable(attachedDatabase, alias);
  }
}

class InventoryBatch extends DataClass implements Insertable<InventoryBatch> {
  final String inventoryBatchId;
  final String medicationId;
  final String? purchaseDate;
  final double? purchasePrice;
  final String? expirationDate;
  final String? packagingType;

  /// Units per innermost pack (per package, or per sub-package when set).
  final int? unitsPerPackage;
  final int? packagesCount;

  /// Optional inner packaging, e.g. strips/blisters inside a box.
  final String? subPackagingType;
  final int? subPackagesPerPackage;

  /// Extra loose units added to the packaged quantity.
  final int? looseQuantityScaled;
  final int initialQuantityScaled;
  final int availableQuantityScaled;
  final int quantityScale;
  final bool isDepleted;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const InventoryBatch(
      {required this.inventoryBatchId,
      required this.medicationId,
      this.purchaseDate,
      this.purchasePrice,
      this.expirationDate,
      this.packagingType,
      this.unitsPerPackage,
      this.packagesCount,
      this.subPackagingType,
      this.subPackagesPerPackage,
      this.looseQuantityScaled,
      required this.initialQuantityScaled,
      required this.availableQuantityScaled,
      required this.quantityScale,
      required this.isDepleted,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['inventory_batch_id'] = Variable<String>(inventoryBatchId);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<String>(purchaseDate);
    }
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || expirationDate != null) {
      map['expiration_date'] = Variable<String>(expirationDate);
    }
    if (!nullToAbsent || packagingType != null) {
      map['packaging_type'] = Variable<String>(packagingType);
    }
    if (!nullToAbsent || unitsPerPackage != null) {
      map['units_per_package'] = Variable<int>(unitsPerPackage);
    }
    if (!nullToAbsent || packagesCount != null) {
      map['packages_count'] = Variable<int>(packagesCount);
    }
    if (!nullToAbsent || subPackagingType != null) {
      map['sub_packaging_type'] = Variable<String>(subPackagingType);
    }
    if (!nullToAbsent || subPackagesPerPackage != null) {
      map['sub_packages_per_package'] = Variable<int>(subPackagesPerPackage);
    }
    if (!nullToAbsent || looseQuantityScaled != null) {
      map['loose_quantity_scaled'] = Variable<int>(looseQuantityScaled);
    }
    map['initial_quantity_scaled'] = Variable<int>(initialQuantityScaled);
    map['available_quantity_scaled'] = Variable<int>(availableQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['is_depleted'] = Variable<bool>(isDepleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MedicationInventoryBatchesCompanion toCompanion(bool nullToAbsent) {
    return MedicationInventoryBatchesCompanion(
      inventoryBatchId: Value(inventoryBatchId),
      medicationId: Value(medicationId),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      expirationDate: expirationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expirationDate),
      packagingType: packagingType == null && nullToAbsent
          ? const Value.absent()
          : Value(packagingType),
      unitsPerPackage: unitsPerPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(unitsPerPackage),
      packagesCount: packagesCount == null && nullToAbsent
          ? const Value.absent()
          : Value(packagesCount),
      subPackagingType: subPackagingType == null && nullToAbsent
          ? const Value.absent()
          : Value(subPackagingType),
      subPackagesPerPackage: subPackagesPerPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(subPackagesPerPackage),
      looseQuantityScaled: looseQuantityScaled == null && nullToAbsent
          ? const Value.absent()
          : Value(looseQuantityScaled),
      initialQuantityScaled: Value(initialQuantityScaled),
      availableQuantityScaled: Value(availableQuantityScaled),
      quantityScale: Value(quantityScale),
      isDepleted: Value(isDepleted),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory InventoryBatch.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBatch(
      inventoryBatchId: serializer.fromJson<String>(json['inventoryBatchId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      purchaseDate: serializer.fromJson<String?>(json['purchaseDate']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      expirationDate: serializer.fromJson<String?>(json['expirationDate']),
      packagingType: serializer.fromJson<String?>(json['packagingType']),
      unitsPerPackage: serializer.fromJson<int?>(json['unitsPerPackage']),
      packagesCount: serializer.fromJson<int?>(json['packagesCount']),
      subPackagingType: serializer.fromJson<String?>(json['subPackagingType']),
      subPackagesPerPackage:
          serializer.fromJson<int?>(json['subPackagesPerPackage']),
      looseQuantityScaled:
          serializer.fromJson<int?>(json['looseQuantityScaled']),
      initialQuantityScaled:
          serializer.fromJson<int>(json['initialQuantityScaled']),
      availableQuantityScaled:
          serializer.fromJson<int>(json['availableQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      isDepleted: serializer.fromJson<bool>(json['isDepleted']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'inventoryBatchId': serializer.toJson<String>(inventoryBatchId),
      'medicationId': serializer.toJson<String>(medicationId),
      'purchaseDate': serializer.toJson<String?>(purchaseDate),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'expirationDate': serializer.toJson<String?>(expirationDate),
      'packagingType': serializer.toJson<String?>(packagingType),
      'unitsPerPackage': serializer.toJson<int?>(unitsPerPackage),
      'packagesCount': serializer.toJson<int?>(packagesCount),
      'subPackagingType': serializer.toJson<String?>(subPackagingType),
      'subPackagesPerPackage': serializer.toJson<int?>(subPackagesPerPackage),
      'looseQuantityScaled': serializer.toJson<int?>(looseQuantityScaled),
      'initialQuantityScaled': serializer.toJson<int>(initialQuantityScaled),
      'availableQuantityScaled':
          serializer.toJson<int>(availableQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'isDepleted': serializer.toJson<bool>(isDepleted),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  InventoryBatch copyWith(
          {String? inventoryBatchId,
          String? medicationId,
          Value<String?> purchaseDate = const Value.absent(),
          Value<double?> purchasePrice = const Value.absent(),
          Value<String?> expirationDate = const Value.absent(),
          Value<String?> packagingType = const Value.absent(),
          Value<int?> unitsPerPackage = const Value.absent(),
          Value<int?> packagesCount = const Value.absent(),
          Value<String?> subPackagingType = const Value.absent(),
          Value<int?> subPackagesPerPackage = const Value.absent(),
          Value<int?> looseQuantityScaled = const Value.absent(),
          int? initialQuantityScaled,
          int? availableQuantityScaled,
          int? quantityScale,
          bool? isDepleted,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      InventoryBatch(
        inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
        medicationId: medicationId ?? this.medicationId,
        purchaseDate:
            purchaseDate.present ? purchaseDate.value : this.purchaseDate,
        purchasePrice:
            purchasePrice.present ? purchasePrice.value : this.purchasePrice,
        expirationDate:
            expirationDate.present ? expirationDate.value : this.expirationDate,
        packagingType:
            packagingType.present ? packagingType.value : this.packagingType,
        unitsPerPackage: unitsPerPackage.present
            ? unitsPerPackage.value
            : this.unitsPerPackage,
        packagesCount:
            packagesCount.present ? packagesCount.value : this.packagesCount,
        subPackagingType: subPackagingType.present
            ? subPackagingType.value
            : this.subPackagingType,
        subPackagesPerPackage: subPackagesPerPackage.present
            ? subPackagesPerPackage.value
            : this.subPackagesPerPackage,
        looseQuantityScaled: looseQuantityScaled.present
            ? looseQuantityScaled.value
            : this.looseQuantityScaled,
        initialQuantityScaled:
            initialQuantityScaled ?? this.initialQuantityScaled,
        availableQuantityScaled:
            availableQuantityScaled ?? this.availableQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        isDepleted: isDepleted ?? this.isDepleted,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  InventoryBatch copyWithCompanion(MedicationInventoryBatchesCompanion data) {
    return InventoryBatch(
      inventoryBatchId: data.inventoryBatchId.present
          ? data.inventoryBatchId.value
          : this.inventoryBatchId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      expirationDate: data.expirationDate.present
          ? data.expirationDate.value
          : this.expirationDate,
      packagingType: data.packagingType.present
          ? data.packagingType.value
          : this.packagingType,
      unitsPerPackage: data.unitsPerPackage.present
          ? data.unitsPerPackage.value
          : this.unitsPerPackage,
      packagesCount: data.packagesCount.present
          ? data.packagesCount.value
          : this.packagesCount,
      subPackagingType: data.subPackagingType.present
          ? data.subPackagingType.value
          : this.subPackagingType,
      subPackagesPerPackage: data.subPackagesPerPackage.present
          ? data.subPackagesPerPackage.value
          : this.subPackagesPerPackage,
      looseQuantityScaled: data.looseQuantityScaled.present
          ? data.looseQuantityScaled.value
          : this.looseQuantityScaled,
      initialQuantityScaled: data.initialQuantityScaled.present
          ? data.initialQuantityScaled.value
          : this.initialQuantityScaled,
      availableQuantityScaled: data.availableQuantityScaled.present
          ? data.availableQuantityScaled.value
          : this.availableQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      isDepleted:
          data.isDepleted.present ? data.isDepleted.value : this.isDepleted,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatch(')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('packagingType: $packagingType, ')
          ..write('unitsPerPackage: $unitsPerPackage, ')
          ..write('packagesCount: $packagesCount, ')
          ..write('subPackagingType: $subPackagingType, ')
          ..write('subPackagesPerPackage: $subPackagesPerPackage, ')
          ..write('looseQuantityScaled: $looseQuantityScaled, ')
          ..write('initialQuantityScaled: $initialQuantityScaled, ')
          ..write('availableQuantityScaled: $availableQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('isDepleted: $isDepleted, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      inventoryBatchId,
      medicationId,
      purchaseDate,
      purchasePrice,
      expirationDate,
      packagingType,
      unitsPerPackage,
      packagesCount,
      subPackagingType,
      subPackagesPerPackage,
      looseQuantityScaled,
      initialQuantityScaled,
      availableQuantityScaled,
      quantityScale,
      isDepleted,
      notes,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBatch &&
          other.inventoryBatchId == this.inventoryBatchId &&
          other.medicationId == this.medicationId &&
          other.purchaseDate == this.purchaseDate &&
          other.purchasePrice == this.purchasePrice &&
          other.expirationDate == this.expirationDate &&
          other.packagingType == this.packagingType &&
          other.unitsPerPackage == this.unitsPerPackage &&
          other.packagesCount == this.packagesCount &&
          other.subPackagingType == this.subPackagingType &&
          other.subPackagesPerPackage == this.subPackagesPerPackage &&
          other.looseQuantityScaled == this.looseQuantityScaled &&
          other.initialQuantityScaled == this.initialQuantityScaled &&
          other.availableQuantityScaled == this.availableQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.isDepleted == this.isDepleted &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MedicationInventoryBatchesCompanion
    extends UpdateCompanion<InventoryBatch> {
  final Value<String> inventoryBatchId;
  final Value<String> medicationId;
  final Value<String?> purchaseDate;
  final Value<double?> purchasePrice;
  final Value<String?> expirationDate;
  final Value<String?> packagingType;
  final Value<int?> unitsPerPackage;
  final Value<int?> packagesCount;
  final Value<String?> subPackagingType;
  final Value<int?> subPackagesPerPackage;
  final Value<int?> looseQuantityScaled;
  final Value<int> initialQuantityScaled;
  final Value<int> availableQuantityScaled;
  final Value<int> quantityScale;
  final Value<bool> isDepleted;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MedicationInventoryBatchesCompanion({
    this.inventoryBatchId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.packagingType = const Value.absent(),
    this.unitsPerPackage = const Value.absent(),
    this.packagesCount = const Value.absent(),
    this.subPackagingType = const Value.absent(),
    this.subPackagesPerPackage = const Value.absent(),
    this.looseQuantityScaled = const Value.absent(),
    this.initialQuantityScaled = const Value.absent(),
    this.availableQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.isDepleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationInventoryBatchesCompanion.insert({
    required String inventoryBatchId,
    required String medicationId,
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.packagingType = const Value.absent(),
    this.unitsPerPackage = const Value.absent(),
    this.packagesCount = const Value.absent(),
    this.subPackagingType = const Value.absent(),
    this.subPackagesPerPackage = const Value.absent(),
    this.looseQuantityScaled = const Value.absent(),
    required int initialQuantityScaled,
    required int availableQuantityScaled,
    this.quantityScale = const Value.absent(),
    this.isDepleted = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : inventoryBatchId = Value(inventoryBatchId),
        medicationId = Value(medicationId),
        initialQuantityScaled = Value(initialQuantityScaled),
        availableQuantityScaled = Value(availableQuantityScaled),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<InventoryBatch> custom({
    Expression<String>? inventoryBatchId,
    Expression<String>? medicationId,
    Expression<String>? purchaseDate,
    Expression<double>? purchasePrice,
    Expression<String>? expirationDate,
    Expression<String>? packagingType,
    Expression<int>? unitsPerPackage,
    Expression<int>? packagesCount,
    Expression<String>? subPackagingType,
    Expression<int>? subPackagesPerPackage,
    Expression<int>? looseQuantityScaled,
    Expression<int>? initialQuantityScaled,
    Expression<int>? availableQuantityScaled,
    Expression<int>? quantityScale,
    Expression<bool>? isDepleted,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (inventoryBatchId != null) 'inventory_batch_id': inventoryBatchId,
      if (medicationId != null) 'medication_id': medicationId,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (expirationDate != null) 'expiration_date': expirationDate,
      if (packagingType != null) 'packaging_type': packagingType,
      if (unitsPerPackage != null) 'units_per_package': unitsPerPackage,
      if (packagesCount != null) 'packages_count': packagesCount,
      if (subPackagingType != null) 'sub_packaging_type': subPackagingType,
      if (subPackagesPerPackage != null)
        'sub_packages_per_package': subPackagesPerPackage,
      if (looseQuantityScaled != null)
        'loose_quantity_scaled': looseQuantityScaled,
      if (initialQuantityScaled != null)
        'initial_quantity_scaled': initialQuantityScaled,
      if (availableQuantityScaled != null)
        'available_quantity_scaled': availableQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (isDepleted != null) 'is_depleted': isDepleted,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationInventoryBatchesCompanion copyWith(
      {Value<String>? inventoryBatchId,
      Value<String>? medicationId,
      Value<String?>? purchaseDate,
      Value<double?>? purchasePrice,
      Value<String?>? expirationDate,
      Value<String?>? packagingType,
      Value<int?>? unitsPerPackage,
      Value<int?>? packagesCount,
      Value<String?>? subPackagingType,
      Value<int?>? subPackagesPerPackage,
      Value<int?>? looseQuantityScaled,
      Value<int>? initialQuantityScaled,
      Value<int>? availableQuantityScaled,
      Value<int>? quantityScale,
      Value<bool>? isDepleted,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return MedicationInventoryBatchesCompanion(
      inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
      medicationId: medicationId ?? this.medicationId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      expirationDate: expirationDate ?? this.expirationDate,
      packagingType: packagingType ?? this.packagingType,
      unitsPerPackage: unitsPerPackage ?? this.unitsPerPackage,
      packagesCount: packagesCount ?? this.packagesCount,
      subPackagingType: subPackagingType ?? this.subPackagingType,
      subPackagesPerPackage:
          subPackagesPerPackage ?? this.subPackagesPerPackage,
      looseQuantityScaled: looseQuantityScaled ?? this.looseQuantityScaled,
      initialQuantityScaled:
          initialQuantityScaled ?? this.initialQuantityScaled,
      availableQuantityScaled:
          availableQuantityScaled ?? this.availableQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      isDepleted: isDepleted ?? this.isDepleted,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (inventoryBatchId.present) {
      map['inventory_batch_id'] = Variable<String>(inventoryBatchId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (expirationDate.present) {
      map['expiration_date'] = Variable<String>(expirationDate.value);
    }
    if (packagingType.present) {
      map['packaging_type'] = Variable<String>(packagingType.value);
    }
    if (unitsPerPackage.present) {
      map['units_per_package'] = Variable<int>(unitsPerPackage.value);
    }
    if (packagesCount.present) {
      map['packages_count'] = Variable<int>(packagesCount.value);
    }
    if (subPackagingType.present) {
      map['sub_packaging_type'] = Variable<String>(subPackagingType.value);
    }
    if (subPackagesPerPackage.present) {
      map['sub_packages_per_package'] =
          Variable<int>(subPackagesPerPackage.value);
    }
    if (looseQuantityScaled.present) {
      map['loose_quantity_scaled'] = Variable<int>(looseQuantityScaled.value);
    }
    if (initialQuantityScaled.present) {
      map['initial_quantity_scaled'] =
          Variable<int>(initialQuantityScaled.value);
    }
    if (availableQuantityScaled.present) {
      map['available_quantity_scaled'] =
          Variable<int>(availableQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (isDepleted.present) {
      map['is_depleted'] = Variable<bool>(isDepleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationInventoryBatchesCompanion(')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('packagingType: $packagingType, ')
          ..write('unitsPerPackage: $unitsPerPackage, ')
          ..write('packagesCount: $packagesCount, ')
          ..write('subPackagingType: $subPackagingType, ')
          ..write('subPackagesPerPackage: $subPackagesPerPackage, ')
          ..write('looseQuantityScaled: $looseQuantityScaled, ')
          ..write('initialQuantityScaled: $initialQuantityScaled, ')
          ..write('availableQuantityScaled: $availableQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('isDepleted: $isDepleted, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryAdjustmentsTable extends InventoryAdjustments
    with TableInfo<$InventoryAdjustmentsTable, InventoryAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _adjustmentIdMeta =
      const VerificationMeta('adjustmentId');
  @override
  late final GeneratedColumn<String> adjustmentId = GeneratedColumn<String>(
      'adjustment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryBatchIdMeta =
      const VerificationMeta('inventoryBatchId');
  @override
  late final GeneratedColumn<String> inventoryBatchId = GeneratedColumn<String>(
      'inventory_batch_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousQuantityScaledMeta =
      const VerificationMeta('previousQuantityScaled');
  @override
  late final GeneratedColumn<int> previousQuantityScaled = GeneratedColumn<int>(
      'previous_quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deltaScaledMeta =
      const VerificationMeta('deltaScaled');
  @override
  late final GeneratedColumn<int> deltaScaled = GeneratedColumn<int>(
      'delta_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _newQuantityScaledMeta =
      const VerificationMeta('newQuantityScaled');
  @override
  late final GeneratedColumn<int> newQuantityScaled = GeneratedColumn<int>(
      'new_quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actorPersonIdMeta =
      const VerificationMeta('actorPersonId');
  @override
  late final GeneratedColumn<String> actorPersonId = GeneratedColumn<String>(
      'actor_person_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        adjustmentId,
        inventoryBatchId,
        medicationId,
        previousQuantityScaled,
        deltaScaled,
        newQuantityScaled,
        quantityScale,
        reason,
        notes,
        actorPersonId,
        occurredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_adjustments';
  @override
  VerificationContext validateIntegrity(
      Insertable<InventoryAdjustment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('adjustment_id')) {
      context.handle(
          _adjustmentIdMeta,
          adjustmentId.isAcceptableOrUnknown(
              data['adjustment_id']!, _adjustmentIdMeta));
    } else if (isInserting) {
      context.missing(_adjustmentIdMeta);
    }
    if (data.containsKey('inventory_batch_id')) {
      context.handle(
          _inventoryBatchIdMeta,
          inventoryBatchId.isAcceptableOrUnknown(
              data['inventory_batch_id']!, _inventoryBatchIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryBatchIdMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('previous_quantity_scaled')) {
      context.handle(
          _previousQuantityScaledMeta,
          previousQuantityScaled.isAcceptableOrUnknown(
              data['previous_quantity_scaled']!, _previousQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_previousQuantityScaledMeta);
    }
    if (data.containsKey('delta_scaled')) {
      context.handle(
          _deltaScaledMeta,
          deltaScaled.isAcceptableOrUnknown(
              data['delta_scaled']!, _deltaScaledMeta));
    } else if (isInserting) {
      context.missing(_deltaScaledMeta);
    }
    if (data.containsKey('new_quantity_scaled')) {
      context.handle(
          _newQuantityScaledMeta,
          newQuantityScaled.isAcceptableOrUnknown(
              data['new_quantity_scaled']!, _newQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_newQuantityScaledMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('actor_person_id')) {
      context.handle(
          _actorPersonIdMeta,
          actorPersonId.isAcceptableOrUnknown(
              data['actor_person_id']!, _actorPersonIdMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {adjustmentId};
  @override
  InventoryAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryAdjustment(
      adjustmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adjustment_id'])!,
      inventoryBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_batch_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      previousQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}previous_quantity_scaled'])!,
      deltaScaled: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delta_scaled'])!,
      newQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}new_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      actorPersonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_person_id']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $InventoryAdjustmentsTable createAlias(String alias) {
    return $InventoryAdjustmentsTable(attachedDatabase, alias);
  }
}

class InventoryAdjustment extends DataClass
    implements Insertable<InventoryAdjustment> {
  final String adjustmentId;
  final String inventoryBatchId;
  final String medicationId;
  final int previousQuantityScaled;
  final int deltaScaled;
  final int newQuantityScaled;
  final int quantityScale;
  final String reason;
  final String? notes;
  final String? actorPersonId;
  final DateTime occurredAt;
  const InventoryAdjustment(
      {required this.adjustmentId,
      required this.inventoryBatchId,
      required this.medicationId,
      required this.previousQuantityScaled,
      required this.deltaScaled,
      required this.newQuantityScaled,
      required this.quantityScale,
      required this.reason,
      this.notes,
      this.actorPersonId,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['adjustment_id'] = Variable<String>(adjustmentId);
    map['inventory_batch_id'] = Variable<String>(inventoryBatchId);
    map['medication_id'] = Variable<String>(medicationId);
    map['previous_quantity_scaled'] = Variable<int>(previousQuantityScaled);
    map['delta_scaled'] = Variable<int>(deltaScaled);
    map['new_quantity_scaled'] = Variable<int>(newQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || actorPersonId != null) {
      map['actor_person_id'] = Variable<String>(actorPersonId);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  InventoryAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return InventoryAdjustmentsCompanion(
      adjustmentId: Value(adjustmentId),
      inventoryBatchId: Value(inventoryBatchId),
      medicationId: Value(medicationId),
      previousQuantityScaled: Value(previousQuantityScaled),
      deltaScaled: Value(deltaScaled),
      newQuantityScaled: Value(newQuantityScaled),
      quantityScale: Value(quantityScale),
      reason: Value(reason),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      actorPersonId: actorPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorPersonId),
      occurredAt: Value(occurredAt),
    );
  }

  factory InventoryAdjustment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryAdjustment(
      adjustmentId: serializer.fromJson<String>(json['adjustmentId']),
      inventoryBatchId: serializer.fromJson<String>(json['inventoryBatchId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      previousQuantityScaled:
          serializer.fromJson<int>(json['previousQuantityScaled']),
      deltaScaled: serializer.fromJson<int>(json['deltaScaled']),
      newQuantityScaled: serializer.fromJson<int>(json['newQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      reason: serializer.fromJson<String>(json['reason']),
      notes: serializer.fromJson<String?>(json['notes']),
      actorPersonId: serializer.fromJson<String?>(json['actorPersonId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'adjustmentId': serializer.toJson<String>(adjustmentId),
      'inventoryBatchId': serializer.toJson<String>(inventoryBatchId),
      'medicationId': serializer.toJson<String>(medicationId),
      'previousQuantityScaled': serializer.toJson<int>(previousQuantityScaled),
      'deltaScaled': serializer.toJson<int>(deltaScaled),
      'newQuantityScaled': serializer.toJson<int>(newQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'reason': serializer.toJson<String>(reason),
      'notes': serializer.toJson<String?>(notes),
      'actorPersonId': serializer.toJson<String?>(actorPersonId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  InventoryAdjustment copyWith(
          {String? adjustmentId,
          String? inventoryBatchId,
          String? medicationId,
          int? previousQuantityScaled,
          int? deltaScaled,
          int? newQuantityScaled,
          int? quantityScale,
          String? reason,
          Value<String?> notes = const Value.absent(),
          Value<String?> actorPersonId = const Value.absent(),
          DateTime? occurredAt}) =>
      InventoryAdjustment(
        adjustmentId: adjustmentId ?? this.adjustmentId,
        inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
        medicationId: medicationId ?? this.medicationId,
        previousQuantityScaled:
            previousQuantityScaled ?? this.previousQuantityScaled,
        deltaScaled: deltaScaled ?? this.deltaScaled,
        newQuantityScaled: newQuantityScaled ?? this.newQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        reason: reason ?? this.reason,
        notes: notes.present ? notes.value : this.notes,
        actorPersonId:
            actorPersonId.present ? actorPersonId.value : this.actorPersonId,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  InventoryAdjustment copyWithCompanion(InventoryAdjustmentsCompanion data) {
    return InventoryAdjustment(
      adjustmentId: data.adjustmentId.present
          ? data.adjustmentId.value
          : this.adjustmentId,
      inventoryBatchId: data.inventoryBatchId.present
          ? data.inventoryBatchId.value
          : this.inventoryBatchId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      previousQuantityScaled: data.previousQuantityScaled.present
          ? data.previousQuantityScaled.value
          : this.previousQuantityScaled,
      deltaScaled:
          data.deltaScaled.present ? data.deltaScaled.value : this.deltaScaled,
      newQuantityScaled: data.newQuantityScaled.present
          ? data.newQuantityScaled.value
          : this.newQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      reason: data.reason.present ? data.reason.value : this.reason,
      notes: data.notes.present ? data.notes.value : this.notes,
      actorPersonId: data.actorPersonId.present
          ? data.actorPersonId.value
          : this.actorPersonId,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustment(')
          ..write('adjustmentId: $adjustmentId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('previousQuantityScaled: $previousQuantityScaled, ')
          ..write('deltaScaled: $deltaScaled, ')
          ..write('newQuantityScaled: $newQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('actorPersonId: $actorPersonId, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      adjustmentId,
      inventoryBatchId,
      medicationId,
      previousQuantityScaled,
      deltaScaled,
      newQuantityScaled,
      quantityScale,
      reason,
      notes,
      actorPersonId,
      occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryAdjustment &&
          other.adjustmentId == this.adjustmentId &&
          other.inventoryBatchId == this.inventoryBatchId &&
          other.medicationId == this.medicationId &&
          other.previousQuantityScaled == this.previousQuantityScaled &&
          other.deltaScaled == this.deltaScaled &&
          other.newQuantityScaled == this.newQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.reason == this.reason &&
          other.notes == this.notes &&
          other.actorPersonId == this.actorPersonId &&
          other.occurredAt == this.occurredAt);
}

class InventoryAdjustmentsCompanion
    extends UpdateCompanion<InventoryAdjustment> {
  final Value<String> adjustmentId;
  final Value<String> inventoryBatchId;
  final Value<String> medicationId;
  final Value<int> previousQuantityScaled;
  final Value<int> deltaScaled;
  final Value<int> newQuantityScaled;
  final Value<int> quantityScale;
  final Value<String> reason;
  final Value<String?> notes;
  final Value<String?> actorPersonId;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const InventoryAdjustmentsCompanion({
    this.adjustmentId = const Value.absent(),
    this.inventoryBatchId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.previousQuantityScaled = const Value.absent(),
    this.deltaScaled = const Value.absent(),
    this.newQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    this.actorPersonId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryAdjustmentsCompanion.insert({
    required String adjustmentId,
    required String inventoryBatchId,
    required String medicationId,
    required int previousQuantityScaled,
    required int deltaScaled,
    required int newQuantityScaled,
    this.quantityScale = const Value.absent(),
    required String reason,
    this.notes = const Value.absent(),
    this.actorPersonId = const Value.absent(),
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  })  : adjustmentId = Value(adjustmentId),
        inventoryBatchId = Value(inventoryBatchId),
        medicationId = Value(medicationId),
        previousQuantityScaled = Value(previousQuantityScaled),
        deltaScaled = Value(deltaScaled),
        newQuantityScaled = Value(newQuantityScaled),
        reason = Value(reason),
        occurredAt = Value(occurredAt);
  static Insertable<InventoryAdjustment> custom({
    Expression<String>? adjustmentId,
    Expression<String>? inventoryBatchId,
    Expression<String>? medicationId,
    Expression<int>? previousQuantityScaled,
    Expression<int>? deltaScaled,
    Expression<int>? newQuantityScaled,
    Expression<int>? quantityScale,
    Expression<String>? reason,
    Expression<String>? notes,
    Expression<String>? actorPersonId,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (adjustmentId != null) 'adjustment_id': adjustmentId,
      if (inventoryBatchId != null) 'inventory_batch_id': inventoryBatchId,
      if (medicationId != null) 'medication_id': medicationId,
      if (previousQuantityScaled != null)
        'previous_quantity_scaled': previousQuantityScaled,
      if (deltaScaled != null) 'delta_scaled': deltaScaled,
      if (newQuantityScaled != null) 'new_quantity_scaled': newQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (reason != null) 'reason': reason,
      if (notes != null) 'notes': notes,
      if (actorPersonId != null) 'actor_person_id': actorPersonId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryAdjustmentsCompanion copyWith(
      {Value<String>? adjustmentId,
      Value<String>? inventoryBatchId,
      Value<String>? medicationId,
      Value<int>? previousQuantityScaled,
      Value<int>? deltaScaled,
      Value<int>? newQuantityScaled,
      Value<int>? quantityScale,
      Value<String>? reason,
      Value<String?>? notes,
      Value<String?>? actorPersonId,
      Value<DateTime>? occurredAt,
      Value<int>? rowid}) {
    return InventoryAdjustmentsCompanion(
      adjustmentId: adjustmentId ?? this.adjustmentId,
      inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
      medicationId: medicationId ?? this.medicationId,
      previousQuantityScaled:
          previousQuantityScaled ?? this.previousQuantityScaled,
      deltaScaled: deltaScaled ?? this.deltaScaled,
      newQuantityScaled: newQuantityScaled ?? this.newQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      actorPersonId: actorPersonId ?? this.actorPersonId,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (adjustmentId.present) {
      map['adjustment_id'] = Variable<String>(adjustmentId.value);
    }
    if (inventoryBatchId.present) {
      map['inventory_batch_id'] = Variable<String>(inventoryBatchId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (previousQuantityScaled.present) {
      map['previous_quantity_scaled'] =
          Variable<int>(previousQuantityScaled.value);
    }
    if (deltaScaled.present) {
      map['delta_scaled'] = Variable<int>(deltaScaled.value);
    }
    if (newQuantityScaled.present) {
      map['new_quantity_scaled'] = Variable<int>(newQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (actorPersonId.present) {
      map['actor_person_id'] = Variable<String>(actorPersonId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustmentsCompanion(')
          ..write('adjustmentId: $adjustmentId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('previousQuantityScaled: $previousQuantityScaled, ')
          ..write('deltaScaled: $deltaScaled, ')
          ..write('newQuantityScaled: $newQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('actorPersonId: $actorPersonId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultTimeMeta =
      const VerificationMeta('defaultTime');
  @override
  late final GeneratedColumn<String> defaultTime = GeneratedColumn<String>(
      'default_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeModeMeta =
      const VerificationMeta('timeMode');
  @override
  late final GeneratedColumn<String> timeMode = GeneratedColumn<String>(
      'time_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('daily'));
  static const VerificationMeta _weekdayTimesMeta =
      const VerificationMeta('weekdayTimes');
  @override
  late final GeneratedColumn<String> weekdayTimes = GeneratedColumn<String>(
      'weekday_times', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        mealId,
        patientId,
        nameEn,
        nameAr,
        mealType,
        defaultTime,
        timeMode,
        weekdayTimes,
        isActive,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(Insertable<Meal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('default_time')) {
      context.handle(
          _defaultTimeMeta,
          defaultTime.isAcceptableOrUnknown(
              data['default_time']!, _defaultTimeMeta));
    }
    if (data.containsKey('time_mode')) {
      context.handle(_timeModeMeta,
          timeMode.isAcceptableOrUnknown(data['time_mode']!, _timeModeMeta));
    }
    if (data.containsKey('weekday_times')) {
      context.handle(
          _weekdayTimesMeta,
          weekdayTimes.isAcceptableOrUnknown(
              data['weekday_times']!, _weekdayTimesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mealId};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      defaultTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_time']),
      timeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_mode'])!,
      weekdayTimes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekday_times']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final String mealId;
  final String patientId;
  final String nameEn;
  final String nameAr;

  /// breakfast, lunch, dinner, snack or custom.
  final String mealType;

  /// Local wall-clock `HH:mm`. When null the meal type default is used.
  final String? defaultTime;

  /// `daily` (same time every day) or `weekly` (per-weekday times).
  final String timeMode;

  /// JSON map of ISO weekday → `HH:mm`, used when [timeMode] is weekly.
  final String? weekdayTimes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Meal(
      {required this.mealId,
      required this.patientId,
      required this.nameEn,
      required this.nameAr,
      required this.mealType,
      this.defaultTime,
      required this.timeMode,
      this.weekdayTimes,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meal_id'] = Variable<String>(mealId);
    map['patient_id'] = Variable<String>(patientId);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || defaultTime != null) {
      map['default_time'] = Variable<String>(defaultTime);
    }
    map['time_mode'] = Variable<String>(timeMode);
    if (!nullToAbsent || weekdayTimes != null) {
      map['weekday_times'] = Variable<String>(weekdayTimes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      mealId: Value(mealId),
      patientId: Value(patientId),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      mealType: Value(mealType),
      defaultTime: defaultTime == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTime),
      timeMode: Value(timeMode),
      weekdayTimes: weekdayTimes == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdayTimes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      mealId: serializer.fromJson<String>(json['mealId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      mealType: serializer.fromJson<String>(json['mealType']),
      defaultTime: serializer.fromJson<String?>(json['defaultTime']),
      timeMode: serializer.fromJson<String>(json['timeMode']),
      weekdayTimes: serializer.fromJson<String?>(json['weekdayTimes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mealId': serializer.toJson<String>(mealId),
      'patientId': serializer.toJson<String>(patientId),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'mealType': serializer.toJson<String>(mealType),
      'defaultTime': serializer.toJson<String?>(defaultTime),
      'timeMode': serializer.toJson<String>(timeMode),
      'weekdayTimes': serializer.toJson<String?>(weekdayTimes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Meal copyWith(
          {String? mealId,
          String? patientId,
          String? nameEn,
          String? nameAr,
          String? mealType,
          Value<String?> defaultTime = const Value.absent(),
          String? timeMode,
          Value<String?> weekdayTimes = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Meal(
        mealId: mealId ?? this.mealId,
        patientId: patientId ?? this.patientId,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        mealType: mealType ?? this.mealType,
        defaultTime: defaultTime.present ? defaultTime.value : this.defaultTime,
        timeMode: timeMode ?? this.timeMode,
        weekdayTimes:
            weekdayTimes.present ? weekdayTimes.value : this.weekdayTimes,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      defaultTime:
          data.defaultTime.present ? data.defaultTime.value : this.defaultTime,
      timeMode: data.timeMode.present ? data.timeMode.value : this.timeMode,
      weekdayTimes: data.weekdayTimes.present
          ? data.weekdayTimes.value
          : this.weekdayTimes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('mealId: $mealId, ')
          ..write('patientId: $patientId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('mealType: $mealType, ')
          ..write('defaultTime: $defaultTime, ')
          ..write('timeMode: $timeMode, ')
          ..write('weekdayTimes: $weekdayTimes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      mealId,
      patientId,
      nameEn,
      nameAr,
      mealType,
      defaultTime,
      timeMode,
      weekdayTimes,
      isActive,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.mealId == this.mealId &&
          other.patientId == this.patientId &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.mealType == this.mealType &&
          other.defaultTime == this.defaultTime &&
          other.timeMode == this.timeMode &&
          other.weekdayTimes == this.weekdayTimes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<String> mealId;
  final Value<String> patientId;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<String> mealType;
  final Value<String?> defaultTime;
  final Value<String> timeMode;
  final Value<String?> weekdayTimes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MealsCompanion({
    this.mealId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.mealType = const Value.absent(),
    this.defaultTime = const Value.absent(),
    this.timeMode = const Value.absent(),
    this.weekdayTimes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String mealId,
    required String patientId,
    required String nameEn,
    required String nameAr,
    required String mealType,
    this.defaultTime = const Value.absent(),
    this.timeMode = const Value.absent(),
    this.weekdayTimes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : mealId = Value(mealId),
        patientId = Value(patientId),
        nameEn = Value(nameEn),
        nameAr = Value(nameAr),
        mealType = Value(mealType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Meal> custom({
    Expression<String>? mealId,
    Expression<String>? patientId,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? mealType,
    Expression<String>? defaultTime,
    Expression<String>? timeMode,
    Expression<String>? weekdayTimes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mealId != null) 'meal_id': mealId,
      if (patientId != null) 'patient_id': patientId,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (mealType != null) 'meal_type': mealType,
      if (defaultTime != null) 'default_time': defaultTime,
      if (timeMode != null) 'time_mode': timeMode,
      if (weekdayTimes != null) 'weekday_times': weekdayTimes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith(
      {Value<String>? mealId,
      Value<String>? patientId,
      Value<String>? nameEn,
      Value<String>? nameAr,
      Value<String>? mealType,
      Value<String?>? defaultTime,
      Value<String>? timeMode,
      Value<String?>? weekdayTimes,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return MealsCompanion(
      mealId: mealId ?? this.mealId,
      patientId: patientId ?? this.patientId,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      mealType: mealType ?? this.mealType,
      defaultTime: defaultTime ?? this.defaultTime,
      timeMode: timeMode ?? this.timeMode,
      weekdayTimes: weekdayTimes ?? this.weekdayTimes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (defaultTime.present) {
      map['default_time'] = Variable<String>(defaultTime.value);
    }
    if (timeMode.present) {
      map['time_mode'] = Variable<String>(timeMode.value);
    }
    if (weekdayTimes.present) {
      map['weekday_times'] = Variable<String>(weekdayTimes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('mealId: $mealId, ')
          ..write('patientId: $patientId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('mealType: $mealType, ')
          ..write('defaultTime: $defaultTime, ')
          ..write('timeMode: $timeMode, ')
          ..write('weekdayTimes: $weekdayTimes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationSchedulesTable extends MedicationSchedules
    with TableInfo<$MedicationSchedulesTable, MedicationSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fixedTimeMeta =
      const VerificationMeta('fixedTime');
  @override
  late final GeneratedColumn<String> fixedTime = GeneratedColumn<String>(
      'fixed_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
      'meal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timingRelationMeta =
      const VerificationMeta('timingRelation');
  @override
  late final GeneratedColumn<String> timingRelation = GeneratedColumn<String>(
      'timing_relation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _offsetMinutesMeta =
      const VerificationMeta('offsetMinutes');
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
      'offset_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _doseQuantityScaledMeta =
      const VerificationMeta('doseQuantityScaled');
  @override
  late final GeneratedColumn<int> doseQuantityScaled = GeneratedColumn<int>(
      'dose_quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _validFromMeta =
      const VerificationMeta('validFrom');
  @override
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
      'valid_from', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _validUntilMeta =
      const VerificationMeta('validUntil');
  @override
  late final GeneratedColumn<String> validUntil = GeneratedColumn<String>(
      'valid_until', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        scheduleId,
        medicationId,
        groupId,
        scheduleType,
        fixedTime,
        mealId,
        timingRelation,
        offsetMinutes,
        doseQuantityScaled,
        quantityScale,
        recurrenceRule,
        validFrom,
        validUntil,
        isActive,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<MedicationSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('fixed_time')) {
      context.handle(_fixedTimeMeta,
          fixedTime.isAcceptableOrUnknown(data['fixed_time']!, _fixedTimeMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    }
    if (data.containsKey('timing_relation')) {
      context.handle(
          _timingRelationMeta,
          timingRelation.isAcceptableOrUnknown(
              data['timing_relation']!, _timingRelationMeta));
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
          _offsetMinutesMeta,
          offsetMinutes.isAcceptableOrUnknown(
              data['offset_minutes']!, _offsetMinutesMeta));
    }
    if (data.containsKey('dose_quantity_scaled')) {
      context.handle(
          _doseQuantityScaledMeta,
          doseQuantityScaled.isAcceptableOrUnknown(
              data['dose_quantity_scaled']!, _doseQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_doseQuantityScaledMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    } else if (isInserting) {
      context.missing(_recurrenceRuleMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(_validFromMeta,
          validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta));
    }
    if (data.containsKey('valid_until')) {
      context.handle(
          _validUntilMeta,
          validUntil.isAcceptableOrUnknown(
              data['valid_until']!, _validUntilMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scheduleId};
  @override
  MedicationSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationSchedule(
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      fixedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fixed_time']),
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_id']),
      timingRelation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timing_relation']),
      offsetMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset_minutes']),
      doseQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dose_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      recurrenceRule: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_rule'])!,
      validFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valid_from']),
      validUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valid_until']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $MedicationSchedulesTable createAlias(String alias) {
    return $MedicationSchedulesTable(attachedDatabase, alias);
  }
}

class MedicationSchedule extends DataClass
    implements Insertable<MedicationSchedule> {
  final String scheduleId;
  final String medicationId;

  /// Schedules created together as one dose plan (e.g. 3 times a day after
  /// meals) share a group ID and are edited as a unit.
  final String? groupId;

  /// `fixed_time` or `meal_relative`.
  final String scheduleType;
  final String? fixedTime;
  final String? mealId;

  /// before, with or after.
  final String? timingRelation;
  final int? offsetMinutes;
  final int doseQuantityScaled;
  final int quantityScale;

  /// JSON encoded [RecurrenceRule].
  final String recurrenceRule;
  final String? validFrom;
  final String? validUntil;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const MedicationSchedule(
      {required this.scheduleId,
      required this.medicationId,
      this.groupId,
      required this.scheduleType,
      this.fixedTime,
      this.mealId,
      this.timingRelation,
      this.offsetMinutes,
      required this.doseQuantityScaled,
      required this.quantityScale,
      required this.recurrenceRule,
      this.validFrom,
      this.validUntil,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schedule_id'] = Variable<String>(scheduleId);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['schedule_type'] = Variable<String>(scheduleType);
    if (!nullToAbsent || fixedTime != null) {
      map['fixed_time'] = Variable<String>(fixedTime);
    }
    if (!nullToAbsent || mealId != null) {
      map['meal_id'] = Variable<String>(mealId);
    }
    if (!nullToAbsent || timingRelation != null) {
      map['timing_relation'] = Variable<String>(timingRelation);
    }
    if (!nullToAbsent || offsetMinutes != null) {
      map['offset_minutes'] = Variable<int>(offsetMinutes);
    }
    map['dose_quantity_scaled'] = Variable<int>(doseQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['recurrence_rule'] = Variable<String>(recurrenceRule);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<String>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<String>(validUntil);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MedicationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MedicationSchedulesCompanion(
      scheduleId: Value(scheduleId),
      medicationId: Value(medicationId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      scheduleType: Value(scheduleType),
      fixedTime: fixedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTime),
      mealId:
          mealId == null && nullToAbsent ? const Value.absent() : Value(mealId),
      timingRelation: timingRelation == null && nullToAbsent
          ? const Value.absent()
          : Value(timingRelation),
      offsetMinutes: offsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(offsetMinutes),
      doseQuantityScaled: Value(doseQuantityScaled),
      quantityScale: Value(quantityScale),
      recurrenceRule: Value(recurrenceRule),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory MedicationSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationSchedule(
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      fixedTime: serializer.fromJson<String?>(json['fixedTime']),
      mealId: serializer.fromJson<String?>(json['mealId']),
      timingRelation: serializer.fromJson<String?>(json['timingRelation']),
      offsetMinutes: serializer.fromJson<int?>(json['offsetMinutes']),
      doseQuantityScaled: serializer.fromJson<int>(json['doseQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      recurrenceRule: serializer.fromJson<String>(json['recurrenceRule']),
      validFrom: serializer.fromJson<String?>(json['validFrom']),
      validUntil: serializer.fromJson<String?>(json['validUntil']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scheduleId': serializer.toJson<String>(scheduleId),
      'medicationId': serializer.toJson<String>(medicationId),
      'groupId': serializer.toJson<String?>(groupId),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'fixedTime': serializer.toJson<String?>(fixedTime),
      'mealId': serializer.toJson<String?>(mealId),
      'timingRelation': serializer.toJson<String?>(timingRelation),
      'offsetMinutes': serializer.toJson<int?>(offsetMinutes),
      'doseQuantityScaled': serializer.toJson<int>(doseQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'recurrenceRule': serializer.toJson<String>(recurrenceRule),
      'validFrom': serializer.toJson<String?>(validFrom),
      'validUntil': serializer.toJson<String?>(validUntil),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  MedicationSchedule copyWith(
          {String? scheduleId,
          String? medicationId,
          Value<String?> groupId = const Value.absent(),
          String? scheduleType,
          Value<String?> fixedTime = const Value.absent(),
          Value<String?> mealId = const Value.absent(),
          Value<String?> timingRelation = const Value.absent(),
          Value<int?> offsetMinutes = const Value.absent(),
          int? doseQuantityScaled,
          int? quantityScale,
          String? recurrenceRule,
          Value<String?> validFrom = const Value.absent(),
          Value<String?> validUntil = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      MedicationSchedule(
        scheduleId: scheduleId ?? this.scheduleId,
        medicationId: medicationId ?? this.medicationId,
        groupId: groupId.present ? groupId.value : this.groupId,
        scheduleType: scheduleType ?? this.scheduleType,
        fixedTime: fixedTime.present ? fixedTime.value : this.fixedTime,
        mealId: mealId.present ? mealId.value : this.mealId,
        timingRelation:
            timingRelation.present ? timingRelation.value : this.timingRelation,
        offsetMinutes:
            offsetMinutes.present ? offsetMinutes.value : this.offsetMinutes,
        doseQuantityScaled: doseQuantityScaled ?? this.doseQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        recurrenceRule: recurrenceRule ?? this.recurrenceRule,
        validFrom: validFrom.present ? validFrom.value : this.validFrom,
        validUntil: validUntil.present ? validUntil.value : this.validUntil,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  MedicationSchedule copyWithCompanion(MedicationSchedulesCompanion data) {
    return MedicationSchedule(
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      fixedTime: data.fixedTime.present ? data.fixedTime.value : this.fixedTime,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      timingRelation: data.timingRelation.present
          ? data.timingRelation.value
          : this.timingRelation,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      doseQuantityScaled: data.doseQuantityScaled.present
          ? data.doseQuantityScaled.value
          : this.doseQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil:
          data.validUntil.present ? data.validUntil.value : this.validUntil,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedule(')
          ..write('scheduleId: $scheduleId, ')
          ..write('medicationId: $medicationId, ')
          ..write('groupId: $groupId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('mealId: $mealId, ')
          ..write('timingRelation: $timingRelation, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('doseQuantityScaled: $doseQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scheduleId,
      medicationId,
      groupId,
      scheduleType,
      fixedTime,
      mealId,
      timingRelation,
      offsetMinutes,
      doseQuantityScaled,
      quantityScale,
      recurrenceRule,
      validFrom,
      validUntil,
      isActive,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationSchedule &&
          other.scheduleId == this.scheduleId &&
          other.medicationId == this.medicationId &&
          other.groupId == this.groupId &&
          other.scheduleType == this.scheduleType &&
          other.fixedTime == this.fixedTime &&
          other.mealId == this.mealId &&
          other.timingRelation == this.timingRelation &&
          other.offsetMinutes == this.offsetMinutes &&
          other.doseQuantityScaled == this.doseQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.recurrenceRule == this.recurrenceRule &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MedicationSchedulesCompanion extends UpdateCompanion<MedicationSchedule> {
  final Value<String> scheduleId;
  final Value<String> medicationId;
  final Value<String?> groupId;
  final Value<String> scheduleType;
  final Value<String?> fixedTime;
  final Value<String?> mealId;
  final Value<String?> timingRelation;
  final Value<int?> offsetMinutes;
  final Value<int> doseQuantityScaled;
  final Value<int> quantityScale;
  final Value<String> recurrenceRule;
  final Value<String?> validFrom;
  final Value<String?> validUntil;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MedicationSchedulesCompanion({
    this.scheduleId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.fixedTime = const Value.absent(),
    this.mealId = const Value.absent(),
    this.timingRelation = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.doseQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    required String scheduleId,
    required String medicationId,
    this.groupId = const Value.absent(),
    required String scheduleType,
    this.fixedTime = const Value.absent(),
    this.mealId = const Value.absent(),
    this.timingRelation = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    required int doseQuantityScaled,
    this.quantityScale = const Value.absent(),
    required String recurrenceRule,
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scheduleId = Value(scheduleId),
        medicationId = Value(medicationId),
        scheduleType = Value(scheduleType),
        doseQuantityScaled = Value(doseQuantityScaled),
        recurrenceRule = Value(recurrenceRule),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MedicationSchedule> custom({
    Expression<String>? scheduleId,
    Expression<String>? medicationId,
    Expression<String>? groupId,
    Expression<String>? scheduleType,
    Expression<String>? fixedTime,
    Expression<String>? mealId,
    Expression<String>? timingRelation,
    Expression<int>? offsetMinutes,
    Expression<int>? doseQuantityScaled,
    Expression<int>? quantityScale,
    Expression<String>? recurrenceRule,
    Expression<String>? validFrom,
    Expression<String>? validUntil,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (medicationId != null) 'medication_id': medicationId,
      if (groupId != null) 'group_id': groupId,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (fixedTime != null) 'fixed_time': fixedTime,
      if (mealId != null) 'meal_id': mealId,
      if (timingRelation != null) 'timing_relation': timingRelation,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (doseQuantityScaled != null)
        'dose_quantity_scaled': doseQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationSchedulesCompanion copyWith(
      {Value<String>? scheduleId,
      Value<String>? medicationId,
      Value<String?>? groupId,
      Value<String>? scheduleType,
      Value<String?>? fixedTime,
      Value<String?>? mealId,
      Value<String?>? timingRelation,
      Value<int?>? offsetMinutes,
      Value<int>? doseQuantityScaled,
      Value<int>? quantityScale,
      Value<String>? recurrenceRule,
      Value<String?>? validFrom,
      Value<String?>? validUntil,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return MedicationSchedulesCompanion(
      scheduleId: scheduleId ?? this.scheduleId,
      medicationId: medicationId ?? this.medicationId,
      groupId: groupId ?? this.groupId,
      scheduleType: scheduleType ?? this.scheduleType,
      fixedTime: fixedTime ?? this.fixedTime,
      mealId: mealId ?? this.mealId,
      timingRelation: timingRelation ?? this.timingRelation,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      doseQuantityScaled: doseQuantityScaled ?? this.doseQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (fixedTime.present) {
      map['fixed_time'] = Variable<String>(fixedTime.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (timingRelation.present) {
      map['timing_relation'] = Variable<String>(timingRelation.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (doseQuantityScaled.present) {
      map['dose_quantity_scaled'] = Variable<int>(doseQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(validUntil.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedulesCompanion(')
          ..write('scheduleId: $scheduleId, ')
          ..write('medicationId: $medicationId, ')
          ..write('groupId: $groupId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('mealId: $mealId, ')
          ..write('timingRelation: $timingRelation, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('doseQuantityScaled: $doseQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseInstancesTable extends DoseInstances
    with TableInfo<$DoseInstancesTable, DoseInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _doseInstanceIdMeta =
      const VerificationMeta('doseInstanceId');
  @override
  late final GeneratedColumn<String> doseInstanceId = GeneratedColumn<String>(
      'dose_instance_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localDateMeta =
      const VerificationMeta('localDate');
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
      'local_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _requiredQuantityScaledMeta =
      const VerificationMeta('requiredQuantityScaled');
  @override
  late final GeneratedColumn<int> requiredQuantityScaled = GeneratedColumn<int>(
      'required_quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _actualQuantityScaledMeta =
      const VerificationMeta('actualQuantityScaled');
  @override
  late final GeneratedColumn<int> actualQuantityScaled = GeneratedColumn<int>(
      'actual_quantity_scaled', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _skippedAtMeta =
      const VerificationMeta('skippedAt');
  @override
  late final GeneratedColumn<DateTime> skippedAt = GeneratedColumn<DateTime>(
      'skipped_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _missedAtMeta =
      const VerificationMeta('missedAt');
  @override
  late final GeneratedColumn<DateTime> missedAt = GeneratedColumn<DateTime>(
      'missed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lateMinutesMeta =
      const VerificationMeta('lateMinutes');
  @override
  late final GeneratedColumn<int> lateMinutes = GeneratedColumn<int>(
      'late_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isPrnMeta = const VerificationMeta('isPrn');
  @override
  late final GeneratedColumn<bool> isPrn = GeneratedColumn<bool>(
      'is_prn', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_prn" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _loggedByPersonIdMeta =
      const VerificationMeta('loggedByPersonId');
  @override
  late final GeneratedColumn<String> loggedByPersonId = GeneratedColumn<String>(
      'logged_by_person_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        doseInstanceId,
        patientId,
        medicationId,
        scheduleId,
        localDate,
        scheduledAt,
        requiredQuantityScaled,
        quantityScale,
        actualQuantityScaled,
        status,
        takenAt,
        skippedAt,
        missedAt,
        lateMinutes,
        isPrn,
        loggedByPersonId,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_instances';
  @override
  VerificationContext validateIntegrity(Insertable<DoseInstance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dose_instance_id')) {
      context.handle(
          _doseInstanceIdMeta,
          doseInstanceId.isAcceptableOrUnknown(
              data['dose_instance_id']!, _doseInstanceIdMeta));
    } else if (isInserting) {
      context.missing(_doseInstanceIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    }
    if (data.containsKey('local_date')) {
      context.handle(_localDateMeta,
          localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta));
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('required_quantity_scaled')) {
      context.handle(
          _requiredQuantityScaledMeta,
          requiredQuantityScaled.isAcceptableOrUnknown(
              data['required_quantity_scaled']!, _requiredQuantityScaledMeta));
    } else if (isInserting) {
      context.missing(_requiredQuantityScaledMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('actual_quantity_scaled')) {
      context.handle(
          _actualQuantityScaledMeta,
          actualQuantityScaled.isAcceptableOrUnknown(
              data['actual_quantity_scaled']!, _actualQuantityScaledMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    }
    if (data.containsKey('skipped_at')) {
      context.handle(_skippedAtMeta,
          skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta));
    }
    if (data.containsKey('missed_at')) {
      context.handle(_missedAtMeta,
          missedAt.isAcceptableOrUnknown(data['missed_at']!, _missedAtMeta));
    }
    if (data.containsKey('late_minutes')) {
      context.handle(
          _lateMinutesMeta,
          lateMinutes.isAcceptableOrUnknown(
              data['late_minutes']!, _lateMinutesMeta));
    }
    if (data.containsKey('is_prn')) {
      context.handle(
          _isPrnMeta, isPrn.isAcceptableOrUnknown(data['is_prn']!, _isPrnMeta));
    }
    if (data.containsKey('logged_by_person_id')) {
      context.handle(
          _loggedByPersonIdMeta,
          loggedByPersonId.isAcceptableOrUnknown(
              data['logged_by_person_id']!, _loggedByPersonIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {doseInstanceId};
  @override
  DoseInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseInstance(
      doseInstanceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dose_instance_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id']),
      localDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_date'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      requiredQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}required_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      actualQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}actual_quantity_scaled']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      takenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}taken_at']),
      skippedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}skipped_at']),
      missedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}missed_at']),
      lateMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}late_minutes']),
      isPrn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_prn'])!,
      loggedByPersonId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}logged_by_person_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DoseInstancesTable createAlias(String alias) {
    return $DoseInstancesTable(attachedDatabase, alias);
  }
}

class DoseInstance extends DataClass implements Insertable<DoseInstance> {
  final String doseInstanceId;
  final String patientId;
  final String medicationId;
  final String? scheduleId;

  /// Local calendar date the dose belongs to (patient timezone).
  final String localDate;
  final DateTime scheduledAt;
  final int requiredQuantityScaled;
  final int quantityScale;
  final int? actualQuantityScaled;

  /// SCHEDULED, TAKEN, MISSED or SKIPPED.
  final String status;
  final DateTime? takenAt;
  final DateTime? skippedAt;
  final DateTime? missedAt;
  final int? lateMinutes;
  final bool isPrn;
  final String? loggedByPersonId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DoseInstance(
      {required this.doseInstanceId,
      required this.patientId,
      required this.medicationId,
      this.scheduleId,
      required this.localDate,
      required this.scheduledAt,
      required this.requiredQuantityScaled,
      required this.quantityScale,
      this.actualQuantityScaled,
      required this.status,
      this.takenAt,
      this.skippedAt,
      this.missedAt,
      this.lateMinutes,
      required this.isPrn,
      this.loggedByPersonId,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dose_instance_id'] = Variable<String>(doseInstanceId);
    map['patient_id'] = Variable<String>(patientId);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<String>(scheduleId);
    }
    map['local_date'] = Variable<String>(localDate);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['required_quantity_scaled'] = Variable<int>(requiredQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    if (!nullToAbsent || actualQuantityScaled != null) {
      map['actual_quantity_scaled'] = Variable<int>(actualQuantityScaled);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    if (!nullToAbsent || skippedAt != null) {
      map['skipped_at'] = Variable<DateTime>(skippedAt);
    }
    if (!nullToAbsent || missedAt != null) {
      map['missed_at'] = Variable<DateTime>(missedAt);
    }
    if (!nullToAbsent || lateMinutes != null) {
      map['late_minutes'] = Variable<int>(lateMinutes);
    }
    map['is_prn'] = Variable<bool>(isPrn);
    if (!nullToAbsent || loggedByPersonId != null) {
      map['logged_by_person_id'] = Variable<String>(loggedByPersonId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DoseInstancesCompanion toCompanion(bool nullToAbsent) {
    return DoseInstancesCompanion(
      doseInstanceId: Value(doseInstanceId),
      patientId: Value(patientId),
      medicationId: Value(medicationId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      localDate: Value(localDate),
      scheduledAt: Value(scheduledAt),
      requiredQuantityScaled: Value(requiredQuantityScaled),
      quantityScale: Value(quantityScale),
      actualQuantityScaled: actualQuantityScaled == null && nullToAbsent
          ? const Value.absent()
          : Value(actualQuantityScaled),
      status: Value(status),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      skippedAt: skippedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(skippedAt),
      missedAt: missedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(missedAt),
      lateMinutes: lateMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(lateMinutes),
      isPrn: Value(isPrn),
      loggedByPersonId: loggedByPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(loggedByPersonId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DoseInstance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseInstance(
      doseInstanceId: serializer.fromJson<String>(json['doseInstanceId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduleId: serializer.fromJson<String?>(json['scheduleId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      requiredQuantityScaled:
          serializer.fromJson<int>(json['requiredQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      actualQuantityScaled:
          serializer.fromJson<int?>(json['actualQuantityScaled']),
      status: serializer.fromJson<String>(json['status']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      skippedAt: serializer.fromJson<DateTime?>(json['skippedAt']),
      missedAt: serializer.fromJson<DateTime?>(json['missedAt']),
      lateMinutes: serializer.fromJson<int?>(json['lateMinutes']),
      isPrn: serializer.fromJson<bool>(json['isPrn']),
      loggedByPersonId: serializer.fromJson<String?>(json['loggedByPersonId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'doseInstanceId': serializer.toJson<String>(doseInstanceId),
      'patientId': serializer.toJson<String>(patientId),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduleId': serializer.toJson<String?>(scheduleId),
      'localDate': serializer.toJson<String>(localDate),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'requiredQuantityScaled': serializer.toJson<int>(requiredQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'actualQuantityScaled': serializer.toJson<int?>(actualQuantityScaled),
      'status': serializer.toJson<String>(status),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'skippedAt': serializer.toJson<DateTime?>(skippedAt),
      'missedAt': serializer.toJson<DateTime?>(missedAt),
      'lateMinutes': serializer.toJson<int?>(lateMinutes),
      'isPrn': serializer.toJson<bool>(isPrn),
      'loggedByPersonId': serializer.toJson<String?>(loggedByPersonId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DoseInstance copyWith(
          {String? doseInstanceId,
          String? patientId,
          String? medicationId,
          Value<String?> scheduleId = const Value.absent(),
          String? localDate,
          DateTime? scheduledAt,
          int? requiredQuantityScaled,
          int? quantityScale,
          Value<int?> actualQuantityScaled = const Value.absent(),
          String? status,
          Value<DateTime?> takenAt = const Value.absent(),
          Value<DateTime?> skippedAt = const Value.absent(),
          Value<DateTime?> missedAt = const Value.absent(),
          Value<int?> lateMinutes = const Value.absent(),
          bool? isPrn,
          Value<String?> loggedByPersonId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DoseInstance(
        doseInstanceId: doseInstanceId ?? this.doseInstanceId,
        patientId: patientId ?? this.patientId,
        medicationId: medicationId ?? this.medicationId,
        scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
        localDate: localDate ?? this.localDate,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        requiredQuantityScaled:
            requiredQuantityScaled ?? this.requiredQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        actualQuantityScaled: actualQuantityScaled.present
            ? actualQuantityScaled.value
            : this.actualQuantityScaled,
        status: status ?? this.status,
        takenAt: takenAt.present ? takenAt.value : this.takenAt,
        skippedAt: skippedAt.present ? skippedAt.value : this.skippedAt,
        missedAt: missedAt.present ? missedAt.value : this.missedAt,
        lateMinutes: lateMinutes.present ? lateMinutes.value : this.lateMinutes,
        isPrn: isPrn ?? this.isPrn,
        loggedByPersonId: loggedByPersonId.present
            ? loggedByPersonId.value
            : this.loggedByPersonId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DoseInstance copyWithCompanion(DoseInstancesCompanion data) {
    return DoseInstance(
      doseInstanceId: data.doseInstanceId.present
          ? data.doseInstanceId.value
          : this.doseInstanceId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      requiredQuantityScaled: data.requiredQuantityScaled.present
          ? data.requiredQuantityScaled.value
          : this.requiredQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      actualQuantityScaled: data.actualQuantityScaled.present
          ? data.actualQuantityScaled.value
          : this.actualQuantityScaled,
      status: data.status.present ? data.status.value : this.status,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      missedAt: data.missedAt.present ? data.missedAt.value : this.missedAt,
      lateMinutes:
          data.lateMinutes.present ? data.lateMinutes.value : this.lateMinutes,
      isPrn: data.isPrn.present ? data.isPrn.value : this.isPrn,
      loggedByPersonId: data.loggedByPersonId.present
          ? data.loggedByPersonId.value
          : this.loggedByPersonId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseInstance(')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('patientId: $patientId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('localDate: $localDate, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('requiredQuantityScaled: $requiredQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('actualQuantityScaled: $actualQuantityScaled, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('missedAt: $missedAt, ')
          ..write('lateMinutes: $lateMinutes, ')
          ..write('isPrn: $isPrn, ')
          ..write('loggedByPersonId: $loggedByPersonId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      doseInstanceId,
      patientId,
      medicationId,
      scheduleId,
      localDate,
      scheduledAt,
      requiredQuantityScaled,
      quantityScale,
      actualQuantityScaled,
      status,
      takenAt,
      skippedAt,
      missedAt,
      lateMinutes,
      isPrn,
      loggedByPersonId,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseInstance &&
          other.doseInstanceId == this.doseInstanceId &&
          other.patientId == this.patientId &&
          other.medicationId == this.medicationId &&
          other.scheduleId == this.scheduleId &&
          other.localDate == this.localDate &&
          other.scheduledAt == this.scheduledAt &&
          other.requiredQuantityScaled == this.requiredQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.actualQuantityScaled == this.actualQuantityScaled &&
          other.status == this.status &&
          other.takenAt == this.takenAt &&
          other.skippedAt == this.skippedAt &&
          other.missedAt == this.missedAt &&
          other.lateMinutes == this.lateMinutes &&
          other.isPrn == this.isPrn &&
          other.loggedByPersonId == this.loggedByPersonId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DoseInstancesCompanion extends UpdateCompanion<DoseInstance> {
  final Value<String> doseInstanceId;
  final Value<String> patientId;
  final Value<String> medicationId;
  final Value<String?> scheduleId;
  final Value<String> localDate;
  final Value<DateTime> scheduledAt;
  final Value<int> requiredQuantityScaled;
  final Value<int> quantityScale;
  final Value<int?> actualQuantityScaled;
  final Value<String> status;
  final Value<DateTime?> takenAt;
  final Value<DateTime?> skippedAt;
  final Value<DateTime?> missedAt;
  final Value<int?> lateMinutes;
  final Value<bool> isPrn;
  final Value<String?> loggedByPersonId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DoseInstancesCompanion({
    this.doseInstanceId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.requiredQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.actualQuantityScaled = const Value.absent(),
    this.status = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.missedAt = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.loggedByPersonId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseInstancesCompanion.insert({
    required String doseInstanceId,
    required String patientId,
    required String medicationId,
    this.scheduleId = const Value.absent(),
    required String localDate,
    required DateTime scheduledAt,
    required int requiredQuantityScaled,
    this.quantityScale = const Value.absent(),
    this.actualQuantityScaled = const Value.absent(),
    required String status,
    this.takenAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.missedAt = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.loggedByPersonId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : doseInstanceId = Value(doseInstanceId),
        patientId = Value(patientId),
        medicationId = Value(medicationId),
        localDate = Value(localDate),
        scheduledAt = Value(scheduledAt),
        requiredQuantityScaled = Value(requiredQuantityScaled),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DoseInstance> custom({
    Expression<String>? doseInstanceId,
    Expression<String>? patientId,
    Expression<String>? medicationId,
    Expression<String>? scheduleId,
    Expression<String>? localDate,
    Expression<DateTime>? scheduledAt,
    Expression<int>? requiredQuantityScaled,
    Expression<int>? quantityScale,
    Expression<int>? actualQuantityScaled,
    Expression<String>? status,
    Expression<DateTime>? takenAt,
    Expression<DateTime>? skippedAt,
    Expression<DateTime>? missedAt,
    Expression<int>? lateMinutes,
    Expression<bool>? isPrn,
    Expression<String>? loggedByPersonId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (doseInstanceId != null) 'dose_instance_id': doseInstanceId,
      if (patientId != null) 'patient_id': patientId,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (localDate != null) 'local_date': localDate,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (requiredQuantityScaled != null)
        'required_quantity_scaled': requiredQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (actualQuantityScaled != null)
        'actual_quantity_scaled': actualQuantityScaled,
      if (status != null) 'status': status,
      if (takenAt != null) 'taken_at': takenAt,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (missedAt != null) 'missed_at': missedAt,
      if (lateMinutes != null) 'late_minutes': lateMinutes,
      if (isPrn != null) 'is_prn': isPrn,
      if (loggedByPersonId != null) 'logged_by_person_id': loggedByPersonId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseInstancesCompanion copyWith(
      {Value<String>? doseInstanceId,
      Value<String>? patientId,
      Value<String>? medicationId,
      Value<String?>? scheduleId,
      Value<String>? localDate,
      Value<DateTime>? scheduledAt,
      Value<int>? requiredQuantityScaled,
      Value<int>? quantityScale,
      Value<int?>? actualQuantityScaled,
      Value<String>? status,
      Value<DateTime?>? takenAt,
      Value<DateTime?>? skippedAt,
      Value<DateTime?>? missedAt,
      Value<int?>? lateMinutes,
      Value<bool>? isPrn,
      Value<String?>? loggedByPersonId,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DoseInstancesCompanion(
      doseInstanceId: doseInstanceId ?? this.doseInstanceId,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      scheduleId: scheduleId ?? this.scheduleId,
      localDate: localDate ?? this.localDate,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      requiredQuantityScaled:
          requiredQuantityScaled ?? this.requiredQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      actualQuantityScaled: actualQuantityScaled ?? this.actualQuantityScaled,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
      skippedAt: skippedAt ?? this.skippedAt,
      missedAt: missedAt ?? this.missedAt,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      isPrn: isPrn ?? this.isPrn,
      loggedByPersonId: loggedByPersonId ?? this.loggedByPersonId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (doseInstanceId.present) {
      map['dose_instance_id'] = Variable<String>(doseInstanceId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (requiredQuantityScaled.present) {
      map['required_quantity_scaled'] =
          Variable<int>(requiredQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (actualQuantityScaled.present) {
      map['actual_quantity_scaled'] = Variable<int>(actualQuantityScaled.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<DateTime>(skippedAt.value);
    }
    if (missedAt.present) {
      map['missed_at'] = Variable<DateTime>(missedAt.value);
    }
    if (lateMinutes.present) {
      map['late_minutes'] = Variable<int>(lateMinutes.value);
    }
    if (isPrn.present) {
      map['is_prn'] = Variable<bool>(isPrn.value);
    }
    if (loggedByPersonId.present) {
      map['logged_by_person_id'] = Variable<String>(loggedByPersonId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseInstancesCompanion(')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('patientId: $patientId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('localDate: $localDate, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('requiredQuantityScaled: $requiredQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('actualQuantityScaled: $actualQuantityScaled, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('missedAt: $missedAt, ')
          ..write('lateMinutes: $lateMinutes, ')
          ..write('isPrn: $isPrn, ')
          ..write('loggedByPersonId: $loggedByPersonId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseInventoryConsumptionTable extends DoseInventoryConsumption
    with TableInfo<$DoseInventoryConsumptionTable, DoseConsumption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseInventoryConsumptionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _consumptionIdMeta =
      const VerificationMeta('consumptionId');
  @override
  late final GeneratedColumn<String> consumptionId = GeneratedColumn<String>(
      'consumption_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseInstanceIdMeta =
      const VerificationMeta('doseInstanceId');
  @override
  late final GeneratedColumn<String> doseInstanceId = GeneratedColumn<String>(
      'dose_instance_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inventoryBatchIdMeta =
      const VerificationMeta('inventoryBatchId');
  @override
  late final GeneratedColumn<String> inventoryBatchId = GeneratedColumn<String>(
      'inventory_batch_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaledMeta =
      const VerificationMeta('quantityScaled');
  @override
  late final GeneratedColumn<int> quantityScaled = GeneratedColumn<int>(
      'quantity_scaled', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _manuallySelectedMeta =
      const VerificationMeta('manuallySelected');
  @override
  late final GeneratedColumn<bool> manuallySelected = GeneratedColumn<bool>(
      'manually_selected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("manually_selected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reversedAtMeta =
      const VerificationMeta('reversedAt');
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
      'reversed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        consumptionId,
        doseInstanceId,
        inventoryBatchId,
        quantityScaled,
        quantityScale,
        manuallySelected,
        createdAt,
        reversedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_inventory_consumption';
  @override
  VerificationContext validateIntegrity(Insertable<DoseConsumption> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('consumption_id')) {
      context.handle(
          _consumptionIdMeta,
          consumptionId.isAcceptableOrUnknown(
              data['consumption_id']!, _consumptionIdMeta));
    } else if (isInserting) {
      context.missing(_consumptionIdMeta);
    }
    if (data.containsKey('dose_instance_id')) {
      context.handle(
          _doseInstanceIdMeta,
          doseInstanceId.isAcceptableOrUnknown(
              data['dose_instance_id']!, _doseInstanceIdMeta));
    } else if (isInserting) {
      context.missing(_doseInstanceIdMeta);
    }
    if (data.containsKey('inventory_batch_id')) {
      context.handle(
          _inventoryBatchIdMeta,
          inventoryBatchId.isAcceptableOrUnknown(
              data['inventory_batch_id']!, _inventoryBatchIdMeta));
    } else if (isInserting) {
      context.missing(_inventoryBatchIdMeta);
    }
    if (data.containsKey('quantity_scaled')) {
      context.handle(
          _quantityScaledMeta,
          quantityScaled.isAcceptableOrUnknown(
              data['quantity_scaled']!, _quantityScaledMeta));
    } else if (isInserting) {
      context.missing(_quantityScaledMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('manually_selected')) {
      context.handle(
          _manuallySelectedMeta,
          manuallySelected.isAcceptableOrUnknown(
              data['manually_selected']!, _manuallySelectedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
          _reversedAtMeta,
          reversedAt.isAcceptableOrUnknown(
              data['reversed_at']!, _reversedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {consumptionId};
  @override
  DoseConsumption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseConsumption(
      consumptionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}consumption_id'])!,
      doseInstanceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dose_instance_id'])!,
      inventoryBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_batch_id'])!,
      quantityScaled: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      manuallySelected: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}manually_selected'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      reversedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reversed_at']),
    );
  }

  @override
  $DoseInventoryConsumptionTable createAlias(String alias) {
    return $DoseInventoryConsumptionTable(attachedDatabase, alias);
  }
}

class DoseConsumption extends DataClass implements Insertable<DoseConsumption> {
  final String consumptionId;
  final String doseInstanceId;
  final String inventoryBatchId;
  final int quantityScaled;
  final int quantityScale;
  final bool manuallySelected;
  final DateTime createdAt;

  /// Set when the dose is undone; the quantity was restored to this batch.
  final DateTime? reversedAt;
  const DoseConsumption(
      {required this.consumptionId,
      required this.doseInstanceId,
      required this.inventoryBatchId,
      required this.quantityScaled,
      required this.quantityScale,
      required this.manuallySelected,
      required this.createdAt,
      this.reversedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['consumption_id'] = Variable<String>(consumptionId);
    map['dose_instance_id'] = Variable<String>(doseInstanceId);
    map['inventory_batch_id'] = Variable<String>(inventoryBatchId);
    map['quantity_scaled'] = Variable<int>(quantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['manually_selected'] = Variable<bool>(manuallySelected);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  DoseInventoryConsumptionCompanion toCompanion(bool nullToAbsent) {
    return DoseInventoryConsumptionCompanion(
      consumptionId: Value(consumptionId),
      doseInstanceId: Value(doseInstanceId),
      inventoryBatchId: Value(inventoryBatchId),
      quantityScaled: Value(quantityScaled),
      quantityScale: Value(quantityScale),
      manuallySelected: Value(manuallySelected),
      createdAt: Value(createdAt),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory DoseConsumption.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseConsumption(
      consumptionId: serializer.fromJson<String>(json['consumptionId']),
      doseInstanceId: serializer.fromJson<String>(json['doseInstanceId']),
      inventoryBatchId: serializer.fromJson<String>(json['inventoryBatchId']),
      quantityScaled: serializer.fromJson<int>(json['quantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      manuallySelected: serializer.fromJson<bool>(json['manuallySelected']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'consumptionId': serializer.toJson<String>(consumptionId),
      'doseInstanceId': serializer.toJson<String>(doseInstanceId),
      'inventoryBatchId': serializer.toJson<String>(inventoryBatchId),
      'quantityScaled': serializer.toJson<int>(quantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'manuallySelected': serializer.toJson<bool>(manuallySelected),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  DoseConsumption copyWith(
          {String? consumptionId,
          String? doseInstanceId,
          String? inventoryBatchId,
          int? quantityScaled,
          int? quantityScale,
          bool? manuallySelected,
          DateTime? createdAt,
          Value<DateTime?> reversedAt = const Value.absent()}) =>
      DoseConsumption(
        consumptionId: consumptionId ?? this.consumptionId,
        doseInstanceId: doseInstanceId ?? this.doseInstanceId,
        inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
        quantityScaled: quantityScaled ?? this.quantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        manuallySelected: manuallySelected ?? this.manuallySelected,
        createdAt: createdAt ?? this.createdAt,
        reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
      );
  DoseConsumption copyWithCompanion(DoseInventoryConsumptionCompanion data) {
    return DoseConsumption(
      consumptionId: data.consumptionId.present
          ? data.consumptionId.value
          : this.consumptionId,
      doseInstanceId: data.doseInstanceId.present
          ? data.doseInstanceId.value
          : this.doseInstanceId,
      inventoryBatchId: data.inventoryBatchId.present
          ? data.inventoryBatchId.value
          : this.inventoryBatchId,
      quantityScaled: data.quantityScaled.present
          ? data.quantityScaled.value
          : this.quantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      manuallySelected: data.manuallySelected.present
          ? data.manuallySelected.value
          : this.manuallySelected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      reversedAt:
          data.reversedAt.present ? data.reversedAt.value : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseConsumption(')
          ..write('consumptionId: $consumptionId, ')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('quantityScaled: $quantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('manuallySelected: $manuallySelected, ')
          ..write('createdAt: $createdAt, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      consumptionId,
      doseInstanceId,
      inventoryBatchId,
      quantityScaled,
      quantityScale,
      manuallySelected,
      createdAt,
      reversedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseConsumption &&
          other.consumptionId == this.consumptionId &&
          other.doseInstanceId == this.doseInstanceId &&
          other.inventoryBatchId == this.inventoryBatchId &&
          other.quantityScaled == this.quantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.manuallySelected == this.manuallySelected &&
          other.createdAt == this.createdAt &&
          other.reversedAt == this.reversedAt);
}

class DoseInventoryConsumptionCompanion
    extends UpdateCompanion<DoseConsumption> {
  final Value<String> consumptionId;
  final Value<String> doseInstanceId;
  final Value<String> inventoryBatchId;
  final Value<int> quantityScaled;
  final Value<int> quantityScale;
  final Value<bool> manuallySelected;
  final Value<DateTime> createdAt;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const DoseInventoryConsumptionCompanion({
    this.consumptionId = const Value.absent(),
    this.doseInstanceId = const Value.absent(),
    this.inventoryBatchId = const Value.absent(),
    this.quantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.manuallySelected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseInventoryConsumptionCompanion.insert({
    required String consumptionId,
    required String doseInstanceId,
    required String inventoryBatchId,
    required int quantityScaled,
    this.quantityScale = const Value.absent(),
    this.manuallySelected = const Value.absent(),
    required DateTime createdAt,
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : consumptionId = Value(consumptionId),
        doseInstanceId = Value(doseInstanceId),
        inventoryBatchId = Value(inventoryBatchId),
        quantityScaled = Value(quantityScaled),
        createdAt = Value(createdAt);
  static Insertable<DoseConsumption> custom({
    Expression<String>? consumptionId,
    Expression<String>? doseInstanceId,
    Expression<String>? inventoryBatchId,
    Expression<int>? quantityScaled,
    Expression<int>? quantityScale,
    Expression<bool>? manuallySelected,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (consumptionId != null) 'consumption_id': consumptionId,
      if (doseInstanceId != null) 'dose_instance_id': doseInstanceId,
      if (inventoryBatchId != null) 'inventory_batch_id': inventoryBatchId,
      if (quantityScaled != null) 'quantity_scaled': quantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (manuallySelected != null) 'manually_selected': manuallySelected,
      if (createdAt != null) 'created_at': createdAt,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseInventoryConsumptionCompanion copyWith(
      {Value<String>? consumptionId,
      Value<String>? doseInstanceId,
      Value<String>? inventoryBatchId,
      Value<int>? quantityScaled,
      Value<int>? quantityScale,
      Value<bool>? manuallySelected,
      Value<DateTime>? createdAt,
      Value<DateTime?>? reversedAt,
      Value<int>? rowid}) {
    return DoseInventoryConsumptionCompanion(
      consumptionId: consumptionId ?? this.consumptionId,
      doseInstanceId: doseInstanceId ?? this.doseInstanceId,
      inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
      quantityScaled: quantityScaled ?? this.quantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      manuallySelected: manuallySelected ?? this.manuallySelected,
      createdAt: createdAt ?? this.createdAt,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (consumptionId.present) {
      map['consumption_id'] = Variable<String>(consumptionId.value);
    }
    if (doseInstanceId.present) {
      map['dose_instance_id'] = Variable<String>(doseInstanceId.value);
    }
    if (inventoryBatchId.present) {
      map['inventory_batch_id'] = Variable<String>(inventoryBatchId.value);
    }
    if (quantityScaled.present) {
      map['quantity_scaled'] = Variable<int>(quantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (manuallySelected.present) {
      map['manually_selected'] = Variable<bool>(manuallySelected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseInventoryConsumptionCompanion(')
          ..write('consumptionId: $consumptionId, ')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('quantityScaled: $quantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('manuallySelected: $manuallySelected, ')
          ..write('createdAt: $createdAt, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
      'appointment_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doctorNameMeta =
      const VerificationMeta('doctorName');
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
      'doctor_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _specialtyMeta =
      const VerificationMeta('specialty');
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
      'specialty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<DateTime> scheduledTime =
      GeneratedColumn<DateTime>('scheduled_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        appointmentId,
        patientId,
        doctorName,
        specialty,
        scheduledTime,
        location,
        notes,
        status,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(Insertable<Appointment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
          _doctorNameMeta,
          doctorName.isAcceptableOrUnknown(
              data['doctor_name']!, _doctorNameMeta));
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(_specialtyMeta,
          specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta));
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appointmentId};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appointment_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      doctorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctor_name'])!,
      specialty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialty']),
      scheduledTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_time'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final String appointmentId;
  final String patientId;
  final String doctorName;
  final String? specialty;
  final DateTime scheduledTime;
  final String? location;
  final String? notes;

  /// scheduled, completed or cancelled.
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Appointment(
      {required this.appointmentId,
      required this.patientId,
      required this.doctorName,
      this.specialty,
      required this.scheduledTime,
      this.location,
      this.notes,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['appointment_id'] = Variable<String>(appointmentId);
    map['patient_id'] = Variable<String>(patientId);
    map['doctor_name'] = Variable<String>(doctorName);
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    map['scheduled_time'] = Variable<DateTime>(scheduledTime);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      appointmentId: Value(appointmentId),
      patientId: Value(patientId),
      doctorName: Value(doctorName),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      scheduledTime: Value(scheduledTime),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      scheduledTime: serializer.fromJson<DateTime>(json['scheduledTime']),
      location: serializer.fromJson<String?>(json['location']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appointmentId': serializer.toJson<String>(appointmentId),
      'patientId': serializer.toJson<String>(patientId),
      'doctorName': serializer.toJson<String>(doctorName),
      'specialty': serializer.toJson<String?>(specialty),
      'scheduledTime': serializer.toJson<DateTime>(scheduledTime),
      'location': serializer.toJson<String?>(location),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Appointment copyWith(
          {String? appointmentId,
          String? patientId,
          String? doctorName,
          Value<String?> specialty = const Value.absent(),
          DateTime? scheduledTime,
          Value<String?> location = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Appointment(
        appointmentId: appointmentId ?? this.appointmentId,
        patientId: patientId ?? this.patientId,
        doctorName: doctorName ?? this.doctorName,
        specialty: specialty.present ? specialty.value : this.specialty,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        location: location.present ? location.value : this.location,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorName:
          data.doctorName.present ? data.doctorName.value : this.doctorName,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      location: data.location.present ? data.location.value : this.location,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('appointmentId: $appointmentId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialty: $specialty, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      appointmentId,
      patientId,
      doctorName,
      specialty,
      scheduledTime,
      location,
      notes,
      status,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.appointmentId == this.appointmentId &&
          other.patientId == this.patientId &&
          other.doctorName == this.doctorName &&
          other.specialty == this.specialty &&
          other.scheduledTime == this.scheduledTime &&
          other.location == this.location &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<String> appointmentId;
  final Value<String> patientId;
  final Value<String> doctorName;
  final Value<String?> specialty;
  final Value<DateTime> scheduledTime;
  final Value<String?> location;
  final Value<String?> notes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const AppointmentsCompanion({
    this.appointmentId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.specialty = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    required String appointmentId,
    required String patientId,
    required String doctorName,
    this.specialty = const Value.absent(),
    required DateTime scheduledTime,
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : appointmentId = Value(appointmentId),
        patientId = Value(patientId),
        doctorName = Value(doctorName),
        scheduledTime = Value(scheduledTime),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Appointment> custom({
    Expression<String>? appointmentId,
    Expression<String>? patientId,
    Expression<String>? doctorName,
    Expression<String>? specialty,
    Expression<DateTime>? scheduledTime,
    Expression<String>? location,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (patientId != null) 'patient_id': patientId,
      if (doctorName != null) 'doctor_name': doctorName,
      if (specialty != null) 'specialty': specialty,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentsCompanion copyWith(
      {Value<String>? appointmentId,
      Value<String>? patientId,
      Value<String>? doctorName,
      Value<String?>? specialty,
      Value<DateTime>? scheduledTime,
      Value<String?>? location,
      Value<String?>? notes,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return AppointmentsCompanion(
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<DateTime>(scheduledTime.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('appointmentId: $appointmentId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialty: $specialty, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VitalsMeasurementsTable extends VitalsMeasurements
    with TableInfo<$VitalsMeasurementsTable, VitalMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalsMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _measurementIdMeta =
      const VerificationMeta('measurementId');
  @override
  late final GeneratedColumn<String> measurementId = GeneratedColumn<String>(
      'measurement_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _measurementTypeMeta =
      const VerificationMeta('measurementType');
  @override
  late final GeneratedColumn<String> measurementType = GeneratedColumn<String>(
      'measurement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _value1Meta = const VerificationMeta('value1');
  @override
  late final GeneratedColumn<double> value1 = GeneratedColumn<double>(
      'value_1', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _value2Meta = const VerificationMeta('value2');
  @override
  late final GeneratedColumn<double> value2 = GeneratedColumn<double>(
      'value_2', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contextMeta =
      const VerificationMeta('context');
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
      'context', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedMealIdMeta =
      const VerificationMeta('relatedMealId');
  @override
  late final GeneratedColumn<String> relatedMealId = GeneratedColumn<String>(
      'related_meal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relatedMedicationIdMeta =
      const VerificationMeta('relatedMedicationId');
  @override
  late final GeneratedColumn<String> relatedMedicationId =
      GeneratedColumn<String>('related_medication_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _minutesAfterMeta =
      const VerificationMeta('minutesAfter');
  @override
  late final GeneratedColumn<int> minutesAfter = GeneratedColumn<int>(
      'minutes_after', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _measuredAtMeta =
      const VerificationMeta('measuredAt');
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
      'measured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        measurementId,
        patientId,
        measurementType,
        value1,
        value2,
        unit,
        context,
        relatedMealId,
        relatedMedicationId,
        minutesAfter,
        measuredAt,
        notes,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vitals_measurements';
  @override
  VerificationContext validateIntegrity(Insertable<VitalMeasurement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('measurement_id')) {
      context.handle(
          _measurementIdMeta,
          measurementId.isAcceptableOrUnknown(
              data['measurement_id']!, _measurementIdMeta));
    } else if (isInserting) {
      context.missing(_measurementIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('measurement_type')) {
      context.handle(
          _measurementTypeMeta,
          measurementType.isAcceptableOrUnknown(
              data['measurement_type']!, _measurementTypeMeta));
    } else if (isInserting) {
      context.missing(_measurementTypeMeta);
    }
    if (data.containsKey('value_1')) {
      context.handle(_value1Meta,
          value1.isAcceptableOrUnknown(data['value_1']!, _value1Meta));
    }
    if (data.containsKey('value_2')) {
      context.handle(_value2Meta,
          value2.isAcceptableOrUnknown(data['value_2']!, _value2Meta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('context')) {
      context.handle(_contextMeta,
          this.context.isAcceptableOrUnknown(data['context']!, _contextMeta));
    }
    if (data.containsKey('related_meal_id')) {
      context.handle(
          _relatedMealIdMeta,
          relatedMealId.isAcceptableOrUnknown(
              data['related_meal_id']!, _relatedMealIdMeta));
    }
    if (data.containsKey('related_medication_id')) {
      context.handle(
          _relatedMedicationIdMeta,
          relatedMedicationId.isAcceptableOrUnknown(
              data['related_medication_id']!, _relatedMedicationIdMeta));
    }
    if (data.containsKey('minutes_after')) {
      context.handle(
          _minutesAfterMeta,
          minutesAfter.isAcceptableOrUnknown(
              data['minutes_after']!, _minutesAfterMeta));
    }
    if (data.containsKey('measured_at')) {
      context.handle(
          _measuredAtMeta,
          measuredAt.isAcceptableOrUnknown(
              data['measured_at']!, _measuredAtMeta));
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {measurementId};
  @override
  VitalMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalMeasurement(
      measurementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}measurement_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      measurementType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}measurement_type'])!,
      value1: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value_1']),
      value2: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value_2']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      context: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context']),
      relatedMealId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_meal_id']),
      relatedMedicationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}related_medication_id']),
      minutesAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes_after']),
      measuredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}measured_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $VitalsMeasurementsTable createAlias(String alias) {
    return $VitalsMeasurementsTable(attachedDatabase, alias);
  }
}

class VitalMeasurement extends DataClass
    implements Insertable<VitalMeasurement> {
  final String measurementId;
  final String patientId;
  final String measurementType;
  final double? value1;
  final double? value2;
  final String? unit;

  /// fasting, before_meal, after_meal, after_medication or random.
  final String? context;
  final String? relatedMealId;
  final String? relatedMedicationId;

  /// Minutes after the related meal or medication.
  final int? minutesAfter;
  final DateTime measuredAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const VitalMeasurement(
      {required this.measurementId,
      required this.patientId,
      required this.measurementType,
      this.value1,
      this.value2,
      this.unit,
      this.context,
      this.relatedMealId,
      this.relatedMedicationId,
      this.minutesAfter,
      required this.measuredAt,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['measurement_id'] = Variable<String>(measurementId);
    map['patient_id'] = Variable<String>(patientId);
    map['measurement_type'] = Variable<String>(measurementType);
    if (!nullToAbsent || value1 != null) {
      map['value_1'] = Variable<double>(value1);
    }
    if (!nullToAbsent || value2 != null) {
      map['value_2'] = Variable<double>(value2);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || context != null) {
      map['context'] = Variable<String>(context);
    }
    if (!nullToAbsent || relatedMealId != null) {
      map['related_meal_id'] = Variable<String>(relatedMealId);
    }
    if (!nullToAbsent || relatedMedicationId != null) {
      map['related_medication_id'] = Variable<String>(relatedMedicationId);
    }
    if (!nullToAbsent || minutesAfter != null) {
      map['minutes_after'] = Variable<int>(minutesAfter);
    }
    map['measured_at'] = Variable<DateTime>(measuredAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  VitalsMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return VitalsMeasurementsCompanion(
      measurementId: Value(measurementId),
      patientId: Value(patientId),
      measurementType: Value(measurementType),
      value1:
          value1 == null && nullToAbsent ? const Value.absent() : Value(value1),
      value2:
          value2 == null && nullToAbsent ? const Value.absent() : Value(value2),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      context: context == null && nullToAbsent
          ? const Value.absent()
          : Value(context),
      relatedMealId: relatedMealId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedMealId),
      relatedMedicationId: relatedMedicationId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedMedicationId),
      minutesAfter: minutesAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(minutesAfter),
      measuredAt: Value(measuredAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory VitalMeasurement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalMeasurement(
      measurementId: serializer.fromJson<String>(json['measurementId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      measurementType: serializer.fromJson<String>(json['measurementType']),
      value1: serializer.fromJson<double?>(json['value1']),
      value2: serializer.fromJson<double?>(json['value2']),
      unit: serializer.fromJson<String?>(json['unit']),
      context: serializer.fromJson<String?>(json['context']),
      relatedMealId: serializer.fromJson<String?>(json['relatedMealId']),
      relatedMedicationId:
          serializer.fromJson<String?>(json['relatedMedicationId']),
      minutesAfter: serializer.fromJson<int?>(json['minutesAfter']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'measurementId': serializer.toJson<String>(measurementId),
      'patientId': serializer.toJson<String>(patientId),
      'measurementType': serializer.toJson<String>(measurementType),
      'value1': serializer.toJson<double?>(value1),
      'value2': serializer.toJson<double?>(value2),
      'unit': serializer.toJson<String?>(unit),
      'context': serializer.toJson<String?>(context),
      'relatedMealId': serializer.toJson<String?>(relatedMealId),
      'relatedMedicationId': serializer.toJson<String?>(relatedMedicationId),
      'minutesAfter': serializer.toJson<int?>(minutesAfter),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  VitalMeasurement copyWith(
          {String? measurementId,
          String? patientId,
          String? measurementType,
          Value<double?> value1 = const Value.absent(),
          Value<double?> value2 = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> context = const Value.absent(),
          Value<String?> relatedMealId = const Value.absent(),
          Value<String?> relatedMedicationId = const Value.absent(),
          Value<int?> minutesAfter = const Value.absent(),
          DateTime? measuredAt,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      VitalMeasurement(
        measurementId: measurementId ?? this.measurementId,
        patientId: patientId ?? this.patientId,
        measurementType: measurementType ?? this.measurementType,
        value1: value1.present ? value1.value : this.value1,
        value2: value2.present ? value2.value : this.value2,
        unit: unit.present ? unit.value : this.unit,
        context: context.present ? context.value : this.context,
        relatedMealId:
            relatedMealId.present ? relatedMealId.value : this.relatedMealId,
        relatedMedicationId: relatedMedicationId.present
            ? relatedMedicationId.value
            : this.relatedMedicationId,
        minutesAfter:
            minutesAfter.present ? minutesAfter.value : this.minutesAfter,
        measuredAt: measuredAt ?? this.measuredAt,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  VitalMeasurement copyWithCompanion(VitalsMeasurementsCompanion data) {
    return VitalMeasurement(
      measurementId: data.measurementId.present
          ? data.measurementId.value
          : this.measurementId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      measurementType: data.measurementType.present
          ? data.measurementType.value
          : this.measurementType,
      value1: data.value1.present ? data.value1.value : this.value1,
      value2: data.value2.present ? data.value2.value : this.value2,
      unit: data.unit.present ? data.unit.value : this.unit,
      context: data.context.present ? data.context.value : this.context,
      relatedMealId: data.relatedMealId.present
          ? data.relatedMealId.value
          : this.relatedMealId,
      relatedMedicationId: data.relatedMedicationId.present
          ? data.relatedMedicationId.value
          : this.relatedMedicationId,
      minutesAfter: data.minutesAfter.present
          ? data.minutesAfter.value
          : this.minutesAfter,
      measuredAt:
          data.measuredAt.present ? data.measuredAt.value : this.measuredAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalMeasurement(')
          ..write('measurementId: $measurementId, ')
          ..write('patientId: $patientId, ')
          ..write('measurementType: $measurementType, ')
          ..write('value1: $value1, ')
          ..write('value2: $value2, ')
          ..write('unit: $unit, ')
          ..write('context: $context, ')
          ..write('relatedMealId: $relatedMealId, ')
          ..write('relatedMedicationId: $relatedMedicationId, ')
          ..write('minutesAfter: $minutesAfter, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      measurementId,
      patientId,
      measurementType,
      value1,
      value2,
      unit,
      context,
      relatedMealId,
      relatedMedicationId,
      minutesAfter,
      measuredAt,
      notes,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalMeasurement &&
          other.measurementId == this.measurementId &&
          other.patientId == this.patientId &&
          other.measurementType == this.measurementType &&
          other.value1 == this.value1 &&
          other.value2 == this.value2 &&
          other.unit == this.unit &&
          other.context == this.context &&
          other.relatedMealId == this.relatedMealId &&
          other.relatedMedicationId == this.relatedMedicationId &&
          other.minutesAfter == this.minutesAfter &&
          other.measuredAt == this.measuredAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class VitalsMeasurementsCompanion extends UpdateCompanion<VitalMeasurement> {
  final Value<String> measurementId;
  final Value<String> patientId;
  final Value<String> measurementType;
  final Value<double?> value1;
  final Value<double?> value2;
  final Value<String?> unit;
  final Value<String?> context;
  final Value<String?> relatedMealId;
  final Value<String?> relatedMedicationId;
  final Value<int?> minutesAfter;
  final Value<DateTime> measuredAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const VitalsMeasurementsCompanion({
    this.measurementId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.measurementType = const Value.absent(),
    this.value1 = const Value.absent(),
    this.value2 = const Value.absent(),
    this.unit = const Value.absent(),
    this.context = const Value.absent(),
    this.relatedMealId = const Value.absent(),
    this.relatedMedicationId = const Value.absent(),
    this.minutesAfter = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VitalsMeasurementsCompanion.insert({
    required String measurementId,
    required String patientId,
    required String measurementType,
    this.value1 = const Value.absent(),
    this.value2 = const Value.absent(),
    this.unit = const Value.absent(),
    this.context = const Value.absent(),
    this.relatedMealId = const Value.absent(),
    this.relatedMedicationId = const Value.absent(),
    this.minutesAfter = const Value.absent(),
    required DateTime measuredAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : measurementId = Value(measurementId),
        patientId = Value(patientId),
        measurementType = Value(measurementType),
        measuredAt = Value(measuredAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<VitalMeasurement> custom({
    Expression<String>? measurementId,
    Expression<String>? patientId,
    Expression<String>? measurementType,
    Expression<double>? value1,
    Expression<double>? value2,
    Expression<String>? unit,
    Expression<String>? context,
    Expression<String>? relatedMealId,
    Expression<String>? relatedMedicationId,
    Expression<int>? minutesAfter,
    Expression<DateTime>? measuredAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (measurementId != null) 'measurement_id': measurementId,
      if (patientId != null) 'patient_id': patientId,
      if (measurementType != null) 'measurement_type': measurementType,
      if (value1 != null) 'value_1': value1,
      if (value2 != null) 'value_2': value2,
      if (unit != null) 'unit': unit,
      if (context != null) 'context': context,
      if (relatedMealId != null) 'related_meal_id': relatedMealId,
      if (relatedMedicationId != null)
        'related_medication_id': relatedMedicationId,
      if (minutesAfter != null) 'minutes_after': minutesAfter,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VitalsMeasurementsCompanion copyWith(
      {Value<String>? measurementId,
      Value<String>? patientId,
      Value<String>? measurementType,
      Value<double?>? value1,
      Value<double?>? value2,
      Value<String?>? unit,
      Value<String?>? context,
      Value<String?>? relatedMealId,
      Value<String?>? relatedMedicationId,
      Value<int?>? minutesAfter,
      Value<DateTime>? measuredAt,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return VitalsMeasurementsCompanion(
      measurementId: measurementId ?? this.measurementId,
      patientId: patientId ?? this.patientId,
      measurementType: measurementType ?? this.measurementType,
      value1: value1 ?? this.value1,
      value2: value2 ?? this.value2,
      unit: unit ?? this.unit,
      context: context ?? this.context,
      relatedMealId: relatedMealId ?? this.relatedMealId,
      relatedMedicationId: relatedMedicationId ?? this.relatedMedicationId,
      minutesAfter: minutesAfter ?? this.minutesAfter,
      measuredAt: measuredAt ?? this.measuredAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (measurementId.present) {
      map['measurement_id'] = Variable<String>(measurementId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (measurementType.present) {
      map['measurement_type'] = Variable<String>(measurementType.value);
    }
    if (value1.present) {
      map['value_1'] = Variable<double>(value1.value);
    }
    if (value2.present) {
      map['value_2'] = Variable<double>(value2.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    if (relatedMealId.present) {
      map['related_meal_id'] = Variable<String>(relatedMealId.value);
    }
    if (relatedMedicationId.present) {
      map['related_medication_id'] =
          Variable<String>(relatedMedicationId.value);
    }
    if (minutesAfter.present) {
      map['minutes_after'] = Variable<int>(minutesAfter.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalsMeasurementsCompanion(')
          ..write('measurementId: $measurementId, ')
          ..write('patientId: $patientId, ')
          ..write('measurementType: $measurementType, ')
          ..write('value1: $value1, ')
          ..write('value2: $value2, ')
          ..write('unit: $unit, ')
          ..write('context: $context, ')
          ..write('relatedMealId: $relatedMealId, ')
          ..write('relatedMedicationId: $relatedMedicationId, ')
          ..write('minutesAfter: $minutesAfter, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DietaryRulesTable extends DietaryRules
    with TableInfo<$DietaryRulesTable, DietaryRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DietaryRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dietRuleIdMeta =
      const VerificationMeta('dietRuleId');
  @override
  late final GeneratedColumn<String> dietRuleId = GeneratedColumn<String>(
      'diet_rule_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _foodItemEnMeta =
      const VerificationMeta('foodItemEn');
  @override
  late final GeneratedColumn<String> foodItemEn = GeneratedColumn<String>(
      'food_item_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _foodItemArMeta =
      const VerificationMeta('foodItemAr');
  @override
  late final GeneratedColumn<String> foodItemAr = GeneratedColumn<String>(
      'food_item_ar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ruleTypeMeta =
      const VerificationMeta('ruleType');
  @override
  late final GeneratedColumn<String> ruleType = GeneratedColumn<String>(
      'rule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        dietRuleId,
        patientId,
        foodItemEn,
        foodItemAr,
        ruleType,
        notes,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dietary_rules';
  @override
  VerificationContext validateIntegrity(Insertable<DietaryRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('diet_rule_id')) {
      context.handle(
          _dietRuleIdMeta,
          dietRuleId.isAcceptableOrUnknown(
              data['diet_rule_id']!, _dietRuleIdMeta));
    } else if (isInserting) {
      context.missing(_dietRuleIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('food_item_en')) {
      context.handle(
          _foodItemEnMeta,
          foodItemEn.isAcceptableOrUnknown(
              data['food_item_en']!, _foodItemEnMeta));
    } else if (isInserting) {
      context.missing(_foodItemEnMeta);
    }
    if (data.containsKey('food_item_ar')) {
      context.handle(
          _foodItemArMeta,
          foodItemAr.isAcceptableOrUnknown(
              data['food_item_ar']!, _foodItemArMeta));
    }
    if (data.containsKey('rule_type')) {
      context.handle(_ruleTypeMeta,
          ruleType.isAcceptableOrUnknown(data['rule_type']!, _ruleTypeMeta));
    } else if (isInserting) {
      context.missing(_ruleTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dietRuleId};
  @override
  DietaryRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DietaryRule(
      dietRuleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diet_rule_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      foodItemEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}food_item_en'])!,
      foodItemAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}food_item_ar']),
      ruleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rule_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $DietaryRulesTable createAlias(String alias) {
    return $DietaryRulesTable(attachedDatabase, alias);
  }
}

class DietaryRule extends DataClass implements Insertable<DietaryRule> {
  final String dietRuleId;
  final String patientId;
  final String foodItemEn;
  final String? foodItemAr;

  /// avoid, limit, prefer or separate_from_medication.
  final String ruleType;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const DietaryRule(
      {required this.dietRuleId,
      required this.patientId,
      required this.foodItemEn,
      this.foodItemAr,
      required this.ruleType,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['diet_rule_id'] = Variable<String>(dietRuleId);
    map['patient_id'] = Variable<String>(patientId);
    map['food_item_en'] = Variable<String>(foodItemEn);
    if (!nullToAbsent || foodItemAr != null) {
      map['food_item_ar'] = Variable<String>(foodItemAr);
    }
    map['rule_type'] = Variable<String>(ruleType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  DietaryRulesCompanion toCompanion(bool nullToAbsent) {
    return DietaryRulesCompanion(
      dietRuleId: Value(dietRuleId),
      patientId: Value(patientId),
      foodItemEn: Value(foodItemEn),
      foodItemAr: foodItemAr == null && nullToAbsent
          ? const Value.absent()
          : Value(foodItemAr),
      ruleType: Value(ruleType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DietaryRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DietaryRule(
      dietRuleId: serializer.fromJson<String>(json['dietRuleId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      foodItemEn: serializer.fromJson<String>(json['foodItemEn']),
      foodItemAr: serializer.fromJson<String?>(json['foodItemAr']),
      ruleType: serializer.fromJson<String>(json['ruleType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dietRuleId': serializer.toJson<String>(dietRuleId),
      'patientId': serializer.toJson<String>(patientId),
      'foodItemEn': serializer.toJson<String>(foodItemEn),
      'foodItemAr': serializer.toJson<String?>(foodItemAr),
      'ruleType': serializer.toJson<String>(ruleType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DietaryRule copyWith(
          {String? dietRuleId,
          String? patientId,
          String? foodItemEn,
          Value<String?> foodItemAr = const Value.absent(),
          String? ruleType,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      DietaryRule(
        dietRuleId: dietRuleId ?? this.dietRuleId,
        patientId: patientId ?? this.patientId,
        foodItemEn: foodItemEn ?? this.foodItemEn,
        foodItemAr: foodItemAr.present ? foodItemAr.value : this.foodItemAr,
        ruleType: ruleType ?? this.ruleType,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  DietaryRule copyWithCompanion(DietaryRulesCompanion data) {
    return DietaryRule(
      dietRuleId:
          data.dietRuleId.present ? data.dietRuleId.value : this.dietRuleId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      foodItemEn:
          data.foodItemEn.present ? data.foodItemEn.value : this.foodItemEn,
      foodItemAr:
          data.foodItemAr.present ? data.foodItemAr.value : this.foodItemAr,
      ruleType: data.ruleType.present ? data.ruleType.value : this.ruleType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DietaryRule(')
          ..write('dietRuleId: $dietRuleId, ')
          ..write('patientId: $patientId, ')
          ..write('foodItemEn: $foodItemEn, ')
          ..write('foodItemAr: $foodItemAr, ')
          ..write('ruleType: $ruleType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dietRuleId, patientId, foodItemEn, foodItemAr,
      ruleType, notes, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietaryRule &&
          other.dietRuleId == this.dietRuleId &&
          other.patientId == this.patientId &&
          other.foodItemEn == this.foodItemEn &&
          other.foodItemAr == this.foodItemAr &&
          other.ruleType == this.ruleType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DietaryRulesCompanion extends UpdateCompanion<DietaryRule> {
  final Value<String> dietRuleId;
  final Value<String> patientId;
  final Value<String> foodItemEn;
  final Value<String?> foodItemAr;
  final Value<String> ruleType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const DietaryRulesCompanion({
    this.dietRuleId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.foodItemEn = const Value.absent(),
    this.foodItemAr = const Value.absent(),
    this.ruleType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DietaryRulesCompanion.insert({
    required String dietRuleId,
    required String patientId,
    required String foodItemEn,
    this.foodItemAr = const Value.absent(),
    required String ruleType,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : dietRuleId = Value(dietRuleId),
        patientId = Value(patientId),
        foodItemEn = Value(foodItemEn),
        ruleType = Value(ruleType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DietaryRule> custom({
    Expression<String>? dietRuleId,
    Expression<String>? patientId,
    Expression<String>? foodItemEn,
    Expression<String>? foodItemAr,
    Expression<String>? ruleType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dietRuleId != null) 'diet_rule_id': dietRuleId,
      if (patientId != null) 'patient_id': patientId,
      if (foodItemEn != null) 'food_item_en': foodItemEn,
      if (foodItemAr != null) 'food_item_ar': foodItemAr,
      if (ruleType != null) 'rule_type': ruleType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DietaryRulesCompanion copyWith(
      {Value<String>? dietRuleId,
      Value<String>? patientId,
      Value<String>? foodItemEn,
      Value<String?>? foodItemAr,
      Value<String>? ruleType,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return DietaryRulesCompanion(
      dietRuleId: dietRuleId ?? this.dietRuleId,
      patientId: patientId ?? this.patientId,
      foodItemEn: foodItemEn ?? this.foodItemEn,
      foodItemAr: foodItemAr ?? this.foodItemAr,
      ruleType: ruleType ?? this.ruleType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dietRuleId.present) {
      map['diet_rule_id'] = Variable<String>(dietRuleId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (foodItemEn.present) {
      map['food_item_en'] = Variable<String>(foodItemEn.value);
    }
    if (foodItemAr.present) {
      map['food_item_ar'] = Variable<String>(foodItemAr.value);
    }
    if (ruleType.present) {
      map['rule_type'] = Variable<String>(ruleType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DietaryRulesCompanion(')
          ..write('dietRuleId: $dietRuleId, ')
          ..write('patientId: $patientId, ')
          ..write('foodItemEn: $foodItemEn, ')
          ..write('foodItemAr: $foodItemAr, ')
          ..write('ruleType: $ruleType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrescriptionsTable extends Prescriptions
    with TableInfo<$PrescriptionsTable, Prescription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _prescriptionIdMeta =
      const VerificationMeta('prescriptionId');
  @override
  late final GeneratedColumn<String> prescriptionId = GeneratedColumn<String>(
      'prescription_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doctorNameMeta =
      const VerificationMeta('doctorName');
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
      'doctor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _issueDateMeta =
      const VerificationMeta('issueDate');
  @override
  late final GeneratedColumn<String> issueDate = GeneratedColumn<String>(
      'issue_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        prescriptionId,
        patientId,
        doctorName,
        issueDate,
        filePath,
        notes,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Prescription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prescription_id')) {
      context.handle(
          _prescriptionIdMeta,
          prescriptionId.isAcceptableOrUnknown(
              data['prescription_id']!, _prescriptionIdMeta));
    } else if (isInserting) {
      context.missing(_prescriptionIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
          _doctorNameMeta,
          doctorName.isAcceptableOrUnknown(
              data['doctor_name']!, _doctorNameMeta));
    }
    if (data.containsKey('issue_date')) {
      context.handle(_issueDateMeta,
          issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prescriptionId};
  @override
  Prescription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prescription(
      prescriptionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}prescription_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      doctorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctor_name']),
      issueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}issue_date']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $PrescriptionsTable createAlias(String alias) {
    return $PrescriptionsTable(attachedDatabase, alias);
  }
}

class Prescription extends DataClass implements Insertable<Prescription> {
  final String prescriptionId;
  final String patientId;
  final String? doctorName;
  final String? issueDate;

  /// Path relative to the app-private prescriptions directory.
  final String filePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Prescription(
      {required this.prescriptionId,
      required this.patientId,
      this.doctorName,
      this.issueDate,
      required this.filePath,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prescription_id'] = Variable<String>(prescriptionId);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || issueDate != null) {
      map['issue_date'] = Variable<String>(issueDate);
    }
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PrescriptionsCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionsCompanion(
      prescriptionId: Value(prescriptionId),
      patientId: Value(patientId),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      issueDate: issueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(issueDate),
      filePath: Value(filePath),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Prescription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prescription(
      prescriptionId: serializer.fromJson<String>(json['prescriptionId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      issueDate: serializer.fromJson<String?>(json['issueDate']),
      filePath: serializer.fromJson<String>(json['filePath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'prescriptionId': serializer.toJson<String>(prescriptionId),
      'patientId': serializer.toJson<String>(patientId),
      'doctorName': serializer.toJson<String?>(doctorName),
      'issueDate': serializer.toJson<String?>(issueDate),
      'filePath': serializer.toJson<String>(filePath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Prescription copyWith(
          {String? prescriptionId,
          String? patientId,
          Value<String?> doctorName = const Value.absent(),
          Value<String?> issueDate = const Value.absent(),
          String? filePath,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Prescription(
        prescriptionId: prescriptionId ?? this.prescriptionId,
        patientId: patientId ?? this.patientId,
        doctorName: doctorName.present ? doctorName.value : this.doctorName,
        issueDate: issueDate.present ? issueDate.value : this.issueDate,
        filePath: filePath ?? this.filePath,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Prescription copyWithCompanion(PrescriptionsCompanion data) {
    return Prescription(
      prescriptionId: data.prescriptionId.present
          ? data.prescriptionId.value
          : this.prescriptionId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorName:
          data.doctorName.present ? data.doctorName.value : this.doctorName,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prescription(')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('issueDate: $issueDate, ')
          ..write('filePath: $filePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(prescriptionId, patientId, doctorName,
      issueDate, filePath, notes, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prescription &&
          other.prescriptionId == this.prescriptionId &&
          other.patientId == this.patientId &&
          other.doctorName == this.doctorName &&
          other.issueDate == this.issueDate &&
          other.filePath == this.filePath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PrescriptionsCompanion extends UpdateCompanion<Prescription> {
  final Value<String> prescriptionId;
  final Value<String> patientId;
  final Value<String?> doctorName;
  final Value<String?> issueDate;
  final Value<String> filePath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PrescriptionsCompanion({
    this.prescriptionId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.filePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionsCompanion.insert({
    required String prescriptionId,
    required String patientId,
    this.doctorName = const Value.absent(),
    this.issueDate = const Value.absent(),
    required String filePath,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : prescriptionId = Value(prescriptionId),
        patientId = Value(patientId),
        filePath = Value(filePath),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Prescription> custom({
    Expression<String>? prescriptionId,
    Expression<String>? patientId,
    Expression<String>? doctorName,
    Expression<String>? issueDate,
    Expression<String>? filePath,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prescriptionId != null) 'prescription_id': prescriptionId,
      if (patientId != null) 'patient_id': patientId,
      if (doctorName != null) 'doctor_name': doctorName,
      if (issueDate != null) 'issue_date': issueDate,
      if (filePath != null) 'file_path': filePath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionsCompanion copyWith(
      {Value<String>? prescriptionId,
      Value<String>? patientId,
      Value<String?>? doctorName,
      Value<String?>? issueDate,
      Value<String>? filePath,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return PrescriptionsCompanion(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      issueDate: issueDate ?? this.issueDate,
      filePath: filePath ?? this.filePath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prescriptionId.present) {
      map['prescription_id'] = Variable<String>(prescriptionId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<String>(issueDate.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionsCompanion(')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('issueDate: $issueDate, ')
          ..write('filePath: $filePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, AppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientPersonIdMeta =
      const VerificationMeta('recipientPersonId');
  @override
  late final GeneratedColumn<String> recipientPersonId =
      GeneratedColumn<String>('recipient_person_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationTypeMeta =
      const VerificationMeta('notificationType');
  @override
  late final GeneratedColumn<String> notificationType = GeneratedColumn<String>(
      'notification_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dedupKeyMeta =
      const VerificationMeta('dedupKey');
  @override
  late final GeneratedColumn<String> dedupKey = GeneratedColumn<String>(
      'dedup_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
      'delivered_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseInstanceIdMeta =
      const VerificationMeta('doseInstanceId');
  @override
  late final GeneratedColumn<String> doseInstanceId = GeneratedColumn<String>(
      'dose_instance_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
      'appointment_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inventoryBatchIdMeta =
      const VerificationMeta('inventoryBatchId');
  @override
  late final GeneratedColumn<String> inventoryBatchId = GeneratedColumn<String>(
      'inventory_batch_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleEnMeta =
      const VerificationMeta('titleEn');
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
      'title_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleArMeta =
      const VerificationMeta('titleAr');
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
      'title_ar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bodyEnMeta = const VerificationMeta('bodyEn');
  @override
  late final GeneratedColumn<String> bodyEn = GeneratedColumn<String>(
      'body_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bodyArMeta = const VerificationMeta('bodyAr');
  @override
  late final GeneratedColumn<String> bodyAr = GeneratedColumn<String>(
      'body_ar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        notificationId,
        patientId,
        recipientPersonId,
        notificationType,
        dedupKey,
        scheduledAt,
        deliveredAt,
        status,
        doseInstanceId,
        appointmentId,
        inventoryBatchId,
        medicationId,
        titleEn,
        titleAr,
        bodyEn,
        bodyAr,
        isRead,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(Insertable<AppNotification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('recipient_person_id')) {
      context.handle(
          _recipientPersonIdMeta,
          recipientPersonId.isAcceptableOrUnknown(
              data['recipient_person_id']!, _recipientPersonIdMeta));
    }
    if (data.containsKey('notification_type')) {
      context.handle(
          _notificationTypeMeta,
          notificationType.isAcceptableOrUnknown(
              data['notification_type']!, _notificationTypeMeta));
    } else if (isInserting) {
      context.missing(_notificationTypeMeta);
    }
    if (data.containsKey('dedup_key')) {
      context.handle(_dedupKeyMeta,
          dedupKey.isAcceptableOrUnknown(data['dedup_key']!, _dedupKeyMeta));
    } else if (isInserting) {
      context.missing(_dedupKeyMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('dose_instance_id')) {
      context.handle(
          _doseInstanceIdMeta,
          doseInstanceId.isAcceptableOrUnknown(
              data['dose_instance_id']!, _doseInstanceIdMeta));
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    }
    if (data.containsKey('inventory_batch_id')) {
      context.handle(
          _inventoryBatchIdMeta,
          inventoryBatchId.isAcceptableOrUnknown(
              data['inventory_batch_id']!, _inventoryBatchIdMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    }
    if (data.containsKey('title_en')) {
      context.handle(_titleEnMeta,
          titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta));
    }
    if (data.containsKey('title_ar')) {
      context.handle(_titleArMeta,
          titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta));
    }
    if (data.containsKey('body_en')) {
      context.handle(_bodyEnMeta,
          bodyEn.isAcceptableOrUnknown(data['body_en']!, _bodyEnMeta));
    }
    if (data.containsKey('body_ar')) {
      context.handle(_bodyArMeta,
          bodyAr.isAcceptableOrUnknown(data['body_ar']!, _bodyArMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  AppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotification(
      notificationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      recipientPersonId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipient_person_id']),
      notificationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_type'])!,
      dedupKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dedup_key'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivered_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      doseInstanceId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dose_instance_id']),
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appointment_id']),
      inventoryBatchId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}inventory_batch_id']),
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id']),
      titleEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_en']),
      titleAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_ar']),
      bodyEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_en']),
      bodyAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_ar']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class AppNotification extends DataClass implements Insertable<AppNotification> {
  final String notificationId;
  final String patientId;
  final String? recipientPersonId;
  final String notificationType;

  /// Stable identity used to deduplicate generation across launches.
  final String dedupKey;
  final DateTime scheduledAt;
  final DateTime? deliveredAt;

  /// scheduled, delivered, cancelled or resolved.
  final String status;
  final String? doseInstanceId;
  final String? appointmentId;
  final String? inventoryBatchId;
  final String? medicationId;
  final String? titleEn;
  final String? titleAr;
  final String? bodyEn;
  final String? bodyAr;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppNotification(
      {required this.notificationId,
      required this.patientId,
      this.recipientPersonId,
      required this.notificationType,
      required this.dedupKey,
      required this.scheduledAt,
      this.deliveredAt,
      required this.status,
      this.doseInstanceId,
      this.appointmentId,
      this.inventoryBatchId,
      this.medicationId,
      this.titleEn,
      this.titleAr,
      this.bodyEn,
      this.bodyAr,
      required this.isRead,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<String>(notificationId);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || recipientPersonId != null) {
      map['recipient_person_id'] = Variable<String>(recipientPersonId);
    }
    map['notification_type'] = Variable<String>(notificationType);
    map['dedup_key'] = Variable<String>(dedupKey);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || doseInstanceId != null) {
      map['dose_instance_id'] = Variable<String>(doseInstanceId);
    }
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<String>(appointmentId);
    }
    if (!nullToAbsent || inventoryBatchId != null) {
      map['inventory_batch_id'] = Variable<String>(inventoryBatchId);
    }
    if (!nullToAbsent || medicationId != null) {
      map['medication_id'] = Variable<String>(medicationId);
    }
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || titleAr != null) {
      map['title_ar'] = Variable<String>(titleAr);
    }
    if (!nullToAbsent || bodyEn != null) {
      map['body_en'] = Variable<String>(bodyEn);
    }
    if (!nullToAbsent || bodyAr != null) {
      map['body_ar'] = Variable<String>(bodyAr);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      notificationId: Value(notificationId),
      patientId: Value(patientId),
      recipientPersonId: recipientPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientPersonId),
      notificationType: Value(notificationType),
      dedupKey: Value(dedupKey),
      scheduledAt: Value(scheduledAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      status: Value(status),
      doseInstanceId: doseInstanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(doseInstanceId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      inventoryBatchId: inventoryBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryBatchId),
      medicationId: medicationId == null && nullToAbsent
          ? const Value.absent()
          : Value(medicationId),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      titleAr: titleAr == null && nullToAbsent
          ? const Value.absent()
          : Value(titleAr),
      bodyEn:
          bodyEn == null && nullToAbsent ? const Value.absent() : Value(bodyEn),
      bodyAr:
          bodyAr == null && nullToAbsent ? const Value.absent() : Value(bodyAr),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotification(
      notificationId: serializer.fromJson<String>(json['notificationId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      recipientPersonId:
          serializer.fromJson<String?>(json['recipientPersonId']),
      notificationType: serializer.fromJson<String>(json['notificationType']),
      dedupKey: serializer.fromJson<String>(json['dedupKey']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      status: serializer.fromJson<String>(json['status']),
      doseInstanceId: serializer.fromJson<String?>(json['doseInstanceId']),
      appointmentId: serializer.fromJson<String?>(json['appointmentId']),
      inventoryBatchId: serializer.fromJson<String?>(json['inventoryBatchId']),
      medicationId: serializer.fromJson<String?>(json['medicationId']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      titleAr: serializer.fromJson<String?>(json['titleAr']),
      bodyEn: serializer.fromJson<String?>(json['bodyEn']),
      bodyAr: serializer.fromJson<String?>(json['bodyAr']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<String>(notificationId),
      'patientId': serializer.toJson<String>(patientId),
      'recipientPersonId': serializer.toJson<String?>(recipientPersonId),
      'notificationType': serializer.toJson<String>(notificationType),
      'dedupKey': serializer.toJson<String>(dedupKey),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'status': serializer.toJson<String>(status),
      'doseInstanceId': serializer.toJson<String?>(doseInstanceId),
      'appointmentId': serializer.toJson<String?>(appointmentId),
      'inventoryBatchId': serializer.toJson<String?>(inventoryBatchId),
      'medicationId': serializer.toJson<String?>(medicationId),
      'titleEn': serializer.toJson<String?>(titleEn),
      'titleAr': serializer.toJson<String?>(titleAr),
      'bodyEn': serializer.toJson<String?>(bodyEn),
      'bodyAr': serializer.toJson<String?>(bodyAr),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppNotification copyWith(
          {String? notificationId,
          String? patientId,
          Value<String?> recipientPersonId = const Value.absent(),
          String? notificationType,
          String? dedupKey,
          DateTime? scheduledAt,
          Value<DateTime?> deliveredAt = const Value.absent(),
          String? status,
          Value<String?> doseInstanceId = const Value.absent(),
          Value<String?> appointmentId = const Value.absent(),
          Value<String?> inventoryBatchId = const Value.absent(),
          Value<String?> medicationId = const Value.absent(),
          Value<String?> titleEn = const Value.absent(),
          Value<String?> titleAr = const Value.absent(),
          Value<String?> bodyEn = const Value.absent(),
          Value<String?> bodyAr = const Value.absent(),
          bool? isRead,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AppNotification(
        notificationId: notificationId ?? this.notificationId,
        patientId: patientId ?? this.patientId,
        recipientPersonId: recipientPersonId.present
            ? recipientPersonId.value
            : this.recipientPersonId,
        notificationType: notificationType ?? this.notificationType,
        dedupKey: dedupKey ?? this.dedupKey,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
        status: status ?? this.status,
        doseInstanceId:
            doseInstanceId.present ? doseInstanceId.value : this.doseInstanceId,
        appointmentId:
            appointmentId.present ? appointmentId.value : this.appointmentId,
        inventoryBatchId: inventoryBatchId.present
            ? inventoryBatchId.value
            : this.inventoryBatchId,
        medicationId:
            medicationId.present ? medicationId.value : this.medicationId,
        titleEn: titleEn.present ? titleEn.value : this.titleEn,
        titleAr: titleAr.present ? titleAr.value : this.titleAr,
        bodyEn: bodyEn.present ? bodyEn.value : this.bodyEn,
        bodyAr: bodyAr.present ? bodyAr.value : this.bodyAr,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppNotification copyWithCompanion(NotificationsCompanion data) {
    return AppNotification(
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      recipientPersonId: data.recipientPersonId.present
          ? data.recipientPersonId.value
          : this.recipientPersonId,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      dedupKey: data.dedupKey.present ? data.dedupKey.value : this.dedupKey,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      deliveredAt:
          data.deliveredAt.present ? data.deliveredAt.value : this.deliveredAt,
      status: data.status.present ? data.status.value : this.status,
      doseInstanceId: data.doseInstanceId.present
          ? data.doseInstanceId.value
          : this.doseInstanceId,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      inventoryBatchId: data.inventoryBatchId.present
          ? data.inventoryBatchId.value
          : this.inventoryBatchId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      bodyEn: data.bodyEn.present ? data.bodyEn.value : this.bodyEn,
      bodyAr: data.bodyAr.present ? data.bodyAr.value : this.bodyAr,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotification(')
          ..write('notificationId: $notificationId, ')
          ..write('patientId: $patientId, ')
          ..write('recipientPersonId: $recipientPersonId, ')
          ..write('notificationType: $notificationType, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('status: $status, ')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('bodyEn: $bodyEn, ')
          ..write('bodyAr: $bodyAr, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      notificationId,
      patientId,
      recipientPersonId,
      notificationType,
      dedupKey,
      scheduledAt,
      deliveredAt,
      status,
      doseInstanceId,
      appointmentId,
      inventoryBatchId,
      medicationId,
      titleEn,
      titleAr,
      bodyEn,
      bodyAr,
      isRead,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotification &&
          other.notificationId == this.notificationId &&
          other.patientId == this.patientId &&
          other.recipientPersonId == this.recipientPersonId &&
          other.notificationType == this.notificationType &&
          other.dedupKey == this.dedupKey &&
          other.scheduledAt == this.scheduledAt &&
          other.deliveredAt == this.deliveredAt &&
          other.status == this.status &&
          other.doseInstanceId == this.doseInstanceId &&
          other.appointmentId == this.appointmentId &&
          other.inventoryBatchId == this.inventoryBatchId &&
          other.medicationId == this.medicationId &&
          other.titleEn == this.titleEn &&
          other.titleAr == this.titleAr &&
          other.bodyEn == this.bodyEn &&
          other.bodyAr == this.bodyAr &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationsCompanion extends UpdateCompanion<AppNotification> {
  final Value<String> notificationId;
  final Value<String> patientId;
  final Value<String?> recipientPersonId;
  final Value<String> notificationType;
  final Value<String> dedupKey;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> deliveredAt;
  final Value<String> status;
  final Value<String?> doseInstanceId;
  final Value<String?> appointmentId;
  final Value<String?> inventoryBatchId;
  final Value<String?> medicationId;
  final Value<String?> titleEn;
  final Value<String?> titleAr;
  final Value<String?> bodyEn;
  final Value<String?> bodyAr;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.notificationId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.recipientPersonId = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.dedupKey = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.status = const Value.absent(),
    this.doseInstanceId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.inventoryBatchId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.bodyEn = const Value.absent(),
    this.bodyAr = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String notificationId,
    required String patientId,
    this.recipientPersonId = const Value.absent(),
    required String notificationType,
    required String dedupKey,
    required DateTime scheduledAt,
    this.deliveredAt = const Value.absent(),
    required String status,
    this.doseInstanceId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.inventoryBatchId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.bodyEn = const Value.absent(),
    this.bodyAr = const Value.absent(),
    this.isRead = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : notificationId = Value(notificationId),
        patientId = Value(patientId),
        notificationType = Value(notificationType),
        dedupKey = Value(dedupKey),
        scheduledAt = Value(scheduledAt),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AppNotification> custom({
    Expression<String>? notificationId,
    Expression<String>? patientId,
    Expression<String>? recipientPersonId,
    Expression<String>? notificationType,
    Expression<String>? dedupKey,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? deliveredAt,
    Expression<String>? status,
    Expression<String>? doseInstanceId,
    Expression<String>? appointmentId,
    Expression<String>? inventoryBatchId,
    Expression<String>? medicationId,
    Expression<String>? titleEn,
    Expression<String>? titleAr,
    Expression<String>? bodyEn,
    Expression<String>? bodyAr,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (patientId != null) 'patient_id': patientId,
      if (recipientPersonId != null) 'recipient_person_id': recipientPersonId,
      if (notificationType != null) 'notification_type': notificationType,
      if (dedupKey != null) 'dedup_key': dedupKey,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (status != null) 'status': status,
      if (doseInstanceId != null) 'dose_instance_id': doseInstanceId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (inventoryBatchId != null) 'inventory_batch_id': inventoryBatchId,
      if (medicationId != null) 'medication_id': medicationId,
      if (titleEn != null) 'title_en': titleEn,
      if (titleAr != null) 'title_ar': titleAr,
      if (bodyEn != null) 'body_en': bodyEn,
      if (bodyAr != null) 'body_ar': bodyAr,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith(
      {Value<String>? notificationId,
      Value<String>? patientId,
      Value<String?>? recipientPersonId,
      Value<String>? notificationType,
      Value<String>? dedupKey,
      Value<DateTime>? scheduledAt,
      Value<DateTime?>? deliveredAt,
      Value<String>? status,
      Value<String?>? doseInstanceId,
      Value<String?>? appointmentId,
      Value<String?>? inventoryBatchId,
      Value<String?>? medicationId,
      Value<String?>? titleEn,
      Value<String?>? titleAr,
      Value<String?>? bodyEn,
      Value<String?>? bodyAr,
      Value<bool>? isRead,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return NotificationsCompanion(
      notificationId: notificationId ?? this.notificationId,
      patientId: patientId ?? this.patientId,
      recipientPersonId: recipientPersonId ?? this.recipientPersonId,
      notificationType: notificationType ?? this.notificationType,
      dedupKey: dedupKey ?? this.dedupKey,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      status: status ?? this.status,
      doseInstanceId: doseInstanceId ?? this.doseInstanceId,
      appointmentId: appointmentId ?? this.appointmentId,
      inventoryBatchId: inventoryBatchId ?? this.inventoryBatchId,
      medicationId: medicationId ?? this.medicationId,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      bodyEn: bodyEn ?? this.bodyEn,
      bodyAr: bodyAr ?? this.bodyAr,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (recipientPersonId.present) {
      map['recipient_person_id'] = Variable<String>(recipientPersonId.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(notificationType.value);
    }
    if (dedupKey.present) {
      map['dedup_key'] = Variable<String>(dedupKey.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (doseInstanceId.present) {
      map['dose_instance_id'] = Variable<String>(doseInstanceId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (inventoryBatchId.present) {
      map['inventory_batch_id'] = Variable<String>(inventoryBatchId.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (bodyEn.present) {
      map['body_en'] = Variable<String>(bodyEn.value);
    }
    if (bodyAr.present) {
      map['body_ar'] = Variable<String>(bodyAr.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('patientId: $patientId, ')
          ..write('recipientPersonId: $recipientPersonId, ')
          ..write('notificationType: $notificationType, ')
          ..write('dedupKey: $dedupKey, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('status: $status, ')
          ..write('doseInstanceId: $doseInstanceId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('inventoryBatchId: $inventoryBatchId, ')
          ..write('medicationId: $medicationId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('bodyEn: $bodyEn, ')
          ..write('bodyAr: $bodyAr, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatientNotificationPreferencesTable
    extends PatientNotificationPreferences
    with
        TableInfo<$PatientNotificationPreferencesTable,
            NotificationPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientNotificationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _preferenceIdMeta =
      const VerificationMeta('preferenceId');
  @override
  late final GeneratedColumn<String> preferenceId = GeneratedColumn<String>(
      'preference_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationTypeMeta =
      const VerificationMeta('notificationType');
  @override
  late final GeneratedColumn<String> notificationType = GeneratedColumn<String>(
      'notification_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        preferenceId,
        patientId,
        notificationType,
        enabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_notification_preferences';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('preference_id')) {
      context.handle(
          _preferenceIdMeta,
          preferenceId.isAcceptableOrUnknown(
              data['preference_id']!, _preferenceIdMeta));
    } else if (isInserting) {
      context.missing(_preferenceIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('notification_type')) {
      context.handle(
          _notificationTypeMeta,
          notificationType.isAcceptableOrUnknown(
              data['notification_type']!, _notificationTypeMeta));
    } else if (isInserting) {
      context.missing(_notificationTypeMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {preferenceId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {patientId, notificationType},
      ];
  @override
  NotificationPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreference(
      preferenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preference_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      notificationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_type'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PatientNotificationPreferencesTable createAlias(String alias) {
    return $PatientNotificationPreferencesTable(attachedDatabase, alias);
  }
}

class NotificationPreference extends DataClass
    implements Insertable<NotificationPreference> {
  final String preferenceId;
  final String patientId;
  final String notificationType;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NotificationPreference(
      {required this.preferenceId,
      required this.patientId,
      required this.notificationType,
      required this.enabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['preference_id'] = Variable<String>(preferenceId);
    map['patient_id'] = Variable<String>(patientId);
    map['notification_type'] = Variable<String>(notificationType);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatientNotificationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return PatientNotificationPreferencesCompanion(
      preferenceId: Value(preferenceId),
      patientId: Value(patientId),
      notificationType: Value(notificationType),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreference(
      preferenceId: serializer.fromJson<String>(json['preferenceId']),
      patientId: serializer.fromJson<String>(json['patientId']),
      notificationType: serializer.fromJson<String>(json['notificationType']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'preferenceId': serializer.toJson<String>(preferenceId),
      'patientId': serializer.toJson<String>(patientId),
      'notificationType': serializer.toJson<String>(notificationType),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotificationPreference copyWith(
          {String? preferenceId,
          String? patientId,
          String? notificationType,
          bool? enabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      NotificationPreference(
        preferenceId: preferenceId ?? this.preferenceId,
        patientId: patientId ?? this.patientId,
        notificationType: notificationType ?? this.notificationType,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NotificationPreference copyWithCompanion(
      PatientNotificationPreferencesCompanion data) {
    return NotificationPreference(
      preferenceId: data.preferenceId.present
          ? data.preferenceId.value
          : this.preferenceId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreference(')
          ..write('preferenceId: $preferenceId, ')
          ..write('patientId: $patientId, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      preferenceId, patientId, notificationType, enabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreference &&
          other.preferenceId == this.preferenceId &&
          other.patientId == this.patientId &&
          other.notificationType == this.notificationType &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientNotificationPreferencesCompanion
    extends UpdateCompanion<NotificationPreference> {
  final Value<String> preferenceId;
  final Value<String> patientId;
  final Value<String> notificationType;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PatientNotificationPreferencesCompanion({
    this.preferenceId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientNotificationPreferencesCompanion.insert({
    required String preferenceId,
    required String patientId,
    required String notificationType,
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : preferenceId = Value(preferenceId),
        patientId = Value(patientId),
        notificationType = Value(notificationType),
        enabled = Value(enabled),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotificationPreference> custom({
    Expression<String>? preferenceId,
    Expression<String>? patientId,
    Expression<String>? notificationType,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (preferenceId != null) 'preference_id': preferenceId,
      if (patientId != null) 'patient_id': patientId,
      if (notificationType != null) 'notification_type': notificationType,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientNotificationPreferencesCompanion copyWith(
      {Value<String>? preferenceId,
      Value<String>? patientId,
      Value<String>? notificationType,
      Value<bool>? enabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PatientNotificationPreferencesCompanion(
      preferenceId: preferenceId ?? this.preferenceId,
      patientId: patientId ?? this.patientId,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (preferenceId.present) {
      map['preference_id'] = Variable<String>(preferenceId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(notificationType.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientNotificationPreferencesCompanion(')
          ..write('preferenceId: $preferenceId, ')
          ..write('patientId: $patientId, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _auditEventIdMeta =
      const VerificationMeta('auditEventId');
  @override
  late final GeneratedColumn<String> auditEventId = GeneratedColumn<String>(
      'audit_event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actorPersonIdMeta =
      const VerificationMeta('actorPersonId');
  @override
  late final GeneratedColumn<String> actorPersonId = GeneratedColumn<String>(
      'actor_person_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        auditEventId,
        patientId,
        actorPersonId,
        entityType,
        entityId,
        action,
        occurredAt,
        metadataJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('audit_event_id')) {
      context.handle(
          _auditEventIdMeta,
          auditEventId.isAcceptableOrUnknown(
              data['audit_event_id']!, _auditEventIdMeta));
    } else if (isInserting) {
      context.missing(_auditEventIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    }
    if (data.containsKey('actor_person_id')) {
      context.handle(
          _actorPersonIdMeta,
          actorPersonId.isAcceptableOrUnknown(
              data['actor_person_id']!, _actorPersonIdMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {auditEventId};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      auditEventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audit_event_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id']),
      actorPersonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_person_id']),
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final String auditEventId;
  final String? patientId;
  final String? actorPersonId;
  final String entityType;
  final String entityId;
  final String action;
  final DateTime occurredAt;
  final String? metadataJson;
  const AuditEvent(
      {required this.auditEventId,
      this.patientId,
      this.actorPersonId,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.occurredAt,
      this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['audit_event_id'] = Variable<String>(auditEventId);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
    }
    if (!nullToAbsent || actorPersonId != null) {
      map['actor_person_id'] = Variable<String>(actorPersonId);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      auditEventId: Value(auditEventId),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      actorPersonId: actorPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorPersonId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      occurredAt: Value(occurredAt),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory AuditEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      auditEventId: serializer.fromJson<String>(json['auditEventId']),
      patientId: serializer.fromJson<String?>(json['patientId']),
      actorPersonId: serializer.fromJson<String?>(json['actorPersonId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'auditEventId': serializer.toJson<String>(auditEventId),
      'patientId': serializer.toJson<String?>(patientId),
      'actorPersonId': serializer.toJson<String?>(actorPersonId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  AuditEvent copyWith(
          {String? auditEventId,
          Value<String?> patientId = const Value.absent(),
          Value<String?> actorPersonId = const Value.absent(),
          String? entityType,
          String? entityId,
          String? action,
          DateTime? occurredAt,
          Value<String?> metadataJson = const Value.absent()}) =>
      AuditEvent(
        auditEventId: auditEventId ?? this.auditEventId,
        patientId: patientId.present ? patientId.value : this.patientId,
        actorPersonId:
            actorPersonId.present ? actorPersonId.value : this.actorPersonId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        occurredAt: occurredAt ?? this.occurredAt,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
      );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      auditEventId: data.auditEventId.present
          ? data.auditEventId.value
          : this.auditEventId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      actorPersonId: data.actorPersonId.present
          ? data.actorPersonId.value
          : this.actorPersonId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('auditEventId: $auditEventId, ')
          ..write('patientId: $patientId, ')
          ..write('actorPersonId: $actorPersonId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(auditEventId, patientId, actorPersonId,
      entityType, entityId, action, occurredAt, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.auditEventId == this.auditEventId &&
          other.patientId == this.patientId &&
          other.actorPersonId == this.actorPersonId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.occurredAt == this.occurredAt &&
          other.metadataJson == this.metadataJson);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> auditEventId;
  final Value<String?> patientId;
  final Value<String?> actorPersonId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<DateTime> occurredAt;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.auditEventId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.actorPersonId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String auditEventId,
    this.patientId = const Value.absent(),
    this.actorPersonId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String action,
    required DateTime occurredAt,
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : auditEventId = Value(auditEventId),
        entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        occurredAt = Value(occurredAt);
  static Insertable<AuditEvent> custom({
    Expression<String>? auditEventId,
    Expression<String>? patientId,
    Expression<String>? actorPersonId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<DateTime>? occurredAt,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (auditEventId != null) 'audit_event_id': auditEventId,
      if (patientId != null) 'patient_id': patientId,
      if (actorPersonId != null) 'actor_person_id': actorPersonId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith(
      {Value<String>? auditEventId,
      Value<String?>? patientId,
      Value<String?>? actorPersonId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? action,
      Value<DateTime>? occurredAt,
      Value<String?>? metadataJson,
      Value<int>? rowid}) {
    return AuditEventsCompanion(
      auditEventId: auditEventId ?? this.auditEventId,
      patientId: patientId ?? this.patientId,
      actorPersonId: actorPersonId ?? this.actorPersonId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      occurredAt: occurredAt ?? this.occurredAt,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (auditEventId.present) {
      map['audit_event_id'] = Variable<String>(auditEventId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (actorPersonId.present) {
      map['actor_person_id'] = Variable<String>(actorPersonId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('auditEventId: $auditEventId, ')
          ..write('patientId: $patientId, ')
          ..write('actorPersonId: $actorPersonId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrashItemsTable extends TrashItems
    with TableInfo<$TrashItemsTable, TrashItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrashItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trashItemIdMeta =
      const VerificationMeta('trashItemId');
  @override
  late final GeneratedColumn<String> trashItemId = GeneratedColumn<String>(
      'trash_item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _restoredAtMeta =
      const VerificationMeta('restoredAt');
  @override
  late final GeneratedColumn<DateTime> restoredAt = GeneratedColumn<DateTime>(
      'restored_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _permanentlyDeletedAtMeta =
      const VerificationMeta('permanentlyDeletedAt');
  @override
  late final GeneratedColumn<DateTime> permanentlyDeletedAt =
      GeneratedColumn<DateTime>('permanently_deleted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _snapshotJsonMeta =
      const VerificationMeta('snapshotJson');
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
      'snapshot_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        trashItemId,
        patientId,
        entityType,
        entityId,
        label,
        deletedAt,
        restoredAt,
        permanentlyDeletedAt,
        snapshotJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trash_items';
  @override
  VerificationContext validateIntegrity(Insertable<TrashItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trash_item_id')) {
      context.handle(
          _trashItemIdMeta,
          trashItemId.isAcceptableOrUnknown(
              data['trash_item_id']!, _trashItemIdMeta));
    } else if (isInserting) {
      context.missing(_trashItemIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    if (data.containsKey('restored_at')) {
      context.handle(
          _restoredAtMeta,
          restoredAt.isAcceptableOrUnknown(
              data['restored_at']!, _restoredAtMeta));
    }
    if (data.containsKey('permanently_deleted_at')) {
      context.handle(
          _permanentlyDeletedAtMeta,
          permanentlyDeletedAt.isAcceptableOrUnknown(
              data['permanently_deleted_at']!, _permanentlyDeletedAtMeta));
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
          _snapshotJsonMeta,
          snapshotJson.isAcceptableOrUnknown(
              data['snapshot_json']!, _snapshotJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trashItemId};
  @override
  TrashItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrashItem(
      trashItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trash_item_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id']),
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at'])!,
      restoredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}restored_at']),
      permanentlyDeletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}permanently_deleted_at']),
      snapshotJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_json']),
    );
  }

  @override
  $TrashItemsTable createAlias(String alias) {
    return $TrashItemsTable(attachedDatabase, alias);
  }
}

class TrashItem extends DataClass implements Insertable<TrashItem> {
  final String trashItemId;
  final String? patientId;
  final String entityType;
  final String entityId;
  final String? label;
  final DateTime deletedAt;
  final DateTime? restoredAt;
  final DateTime? permanentlyDeletedAt;
  final String? snapshotJson;
  const TrashItem(
      {required this.trashItemId,
      this.patientId,
      required this.entityType,
      required this.entityId,
      this.label,
      required this.deletedAt,
      this.restoredAt,
      this.permanentlyDeletedAt,
      this.snapshotJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trash_item_id'] = Variable<String>(trashItemId);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    if (!nullToAbsent || restoredAt != null) {
      map['restored_at'] = Variable<DateTime>(restoredAt);
    }
    if (!nullToAbsent || permanentlyDeletedAt != null) {
      map['permanently_deleted_at'] = Variable<DateTime>(permanentlyDeletedAt);
    }
    if (!nullToAbsent || snapshotJson != null) {
      map['snapshot_json'] = Variable<String>(snapshotJson);
    }
    return map;
  }

  TrashItemsCompanion toCompanion(bool nullToAbsent) {
    return TrashItemsCompanion(
      trashItemId: Value(trashItemId),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      deletedAt: Value(deletedAt),
      restoredAt: restoredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restoredAt),
      permanentlyDeletedAt: permanentlyDeletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(permanentlyDeletedAt),
      snapshotJson: snapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotJson),
    );
  }

  factory TrashItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrashItem(
      trashItemId: serializer.fromJson<String>(json['trashItemId']),
      patientId: serializer.fromJson<String?>(json['patientId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      label: serializer.fromJson<String?>(json['label']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      restoredAt: serializer.fromJson<DateTime?>(json['restoredAt']),
      permanentlyDeletedAt:
          serializer.fromJson<DateTime?>(json['permanentlyDeletedAt']),
      snapshotJson: serializer.fromJson<String?>(json['snapshotJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trashItemId': serializer.toJson<String>(trashItemId),
      'patientId': serializer.toJson<String?>(patientId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'label': serializer.toJson<String?>(label),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'restoredAt': serializer.toJson<DateTime?>(restoredAt),
      'permanentlyDeletedAt':
          serializer.toJson<DateTime?>(permanentlyDeletedAt),
      'snapshotJson': serializer.toJson<String?>(snapshotJson),
    };
  }

  TrashItem copyWith(
          {String? trashItemId,
          Value<String?> patientId = const Value.absent(),
          String? entityType,
          String? entityId,
          Value<String?> label = const Value.absent(),
          DateTime? deletedAt,
          Value<DateTime?> restoredAt = const Value.absent(),
          Value<DateTime?> permanentlyDeletedAt = const Value.absent(),
          Value<String?> snapshotJson = const Value.absent()}) =>
      TrashItem(
        trashItemId: trashItemId ?? this.trashItemId,
        patientId: patientId.present ? patientId.value : this.patientId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        label: label.present ? label.value : this.label,
        deletedAt: deletedAt ?? this.deletedAt,
        restoredAt: restoredAt.present ? restoredAt.value : this.restoredAt,
        permanentlyDeletedAt: permanentlyDeletedAt.present
            ? permanentlyDeletedAt.value
            : this.permanentlyDeletedAt,
        snapshotJson:
            snapshotJson.present ? snapshotJson.value : this.snapshotJson,
      );
  TrashItem copyWithCompanion(TrashItemsCompanion data) {
    return TrashItem(
      trashItemId:
          data.trashItemId.present ? data.trashItemId.value : this.trashItemId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      label: data.label.present ? data.label.value : this.label,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      restoredAt:
          data.restoredAt.present ? data.restoredAt.value : this.restoredAt,
      permanentlyDeletedAt: data.permanentlyDeletedAt.present
          ? data.permanentlyDeletedAt.value
          : this.permanentlyDeletedAt,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrashItem(')
          ..write('trashItemId: $trashItemId, ')
          ..write('patientId: $patientId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('label: $label, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('restoredAt: $restoredAt, ')
          ..write('permanentlyDeletedAt: $permanentlyDeletedAt, ')
          ..write('snapshotJson: $snapshotJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(trashItemId, patientId, entityType, entityId,
      label, deletedAt, restoredAt, permanentlyDeletedAt, snapshotJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrashItem &&
          other.trashItemId == this.trashItemId &&
          other.patientId == this.patientId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.label == this.label &&
          other.deletedAt == this.deletedAt &&
          other.restoredAt == this.restoredAt &&
          other.permanentlyDeletedAt == this.permanentlyDeletedAt &&
          other.snapshotJson == this.snapshotJson);
}

class TrashItemsCompanion extends UpdateCompanion<TrashItem> {
  final Value<String> trashItemId;
  final Value<String?> patientId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> label;
  final Value<DateTime> deletedAt;
  final Value<DateTime?> restoredAt;
  final Value<DateTime?> permanentlyDeletedAt;
  final Value<String?> snapshotJson;
  final Value<int> rowid;
  const TrashItemsCompanion({
    this.trashItemId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.label = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.restoredAt = const Value.absent(),
    this.permanentlyDeletedAt = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrashItemsCompanion.insert({
    required String trashItemId,
    this.patientId = const Value.absent(),
    required String entityType,
    required String entityId,
    this.label = const Value.absent(),
    required DateTime deletedAt,
    this.restoredAt = const Value.absent(),
    this.permanentlyDeletedAt = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : trashItemId = Value(trashItemId),
        entityType = Value(entityType),
        entityId = Value(entityId),
        deletedAt = Value(deletedAt);
  static Insertable<TrashItem> custom({
    Expression<String>? trashItemId,
    Expression<String>? patientId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? label,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? restoredAt,
    Expression<DateTime>? permanentlyDeletedAt,
    Expression<String>? snapshotJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trashItemId != null) 'trash_item_id': trashItemId,
      if (patientId != null) 'patient_id': patientId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (label != null) 'label': label,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (restoredAt != null) 'restored_at': restoredAt,
      if (permanentlyDeletedAt != null)
        'permanently_deleted_at': permanentlyDeletedAt,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrashItemsCompanion copyWith(
      {Value<String>? trashItemId,
      Value<String?>? patientId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String?>? label,
      Value<DateTime>? deletedAt,
      Value<DateTime?>? restoredAt,
      Value<DateTime?>? permanentlyDeletedAt,
      Value<String?>? snapshotJson,
      Value<int>? rowid}) {
    return TrashItemsCompanion(
      trashItemId: trashItemId ?? this.trashItemId,
      patientId: patientId ?? this.patientId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      label: label ?? this.label,
      deletedAt: deletedAt ?? this.deletedAt,
      restoredAt: restoredAt ?? this.restoredAt,
      permanentlyDeletedAt: permanentlyDeletedAt ?? this.permanentlyDeletedAt,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trashItemId.present) {
      map['trash_item_id'] = Variable<String>(trashItemId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (restoredAt.present) {
      map['restored_at'] = Variable<DateTime>(restoredAt.value);
    }
    if (permanentlyDeletedAt.present) {
      map['permanently_deleted_at'] =
          Variable<DateTime>(permanentlyDeletedAt.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrashItemsCompanion(')
          ..write('trashItemId: $trashItemId, ')
          ..write('patientId: $patientId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('label: $label, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('restoredAt: $restoredAt, ')
          ..write('permanentlyDeletedAt: $permanentlyDeletedAt, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  const AppSetting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith(
          {String? key, Value<String?> value = const Value.absent()}) =>
      AppSetting(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String?>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $CaregiverAssignmentsTable caregiverAssignments =
      $CaregiverAssignmentsTable(this);
  late final $PatientIllnessesTable patientIllnesses =
      $PatientIllnessesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationInventoryBatchesTable medicationInventoryBatches =
      $MedicationInventoryBatchesTable(this);
  late final $InventoryAdjustmentsTable inventoryAdjustments =
      $InventoryAdjustmentsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $DoseInstancesTable doseInstances = $DoseInstancesTable(this);
  late final $DoseInventoryConsumptionTable doseInventoryConsumption =
      $DoseInventoryConsumptionTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $VitalsMeasurementsTable vitalsMeasurements =
      $VitalsMeasurementsTable(this);
  late final $DietaryRulesTable dietaryRules = $DietaryRulesTable(this);
  late final $PrescriptionsTable prescriptions = $PrescriptionsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $PatientNotificationPreferencesTable
      patientNotificationPreferences =
      $PatientNotificationPreferencesTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  late final $TrashItemsTable trashItems = $TrashItemsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        persons,
        patients,
        caregiverAssignments,
        patientIllnesses,
        medications,
        medicationInventoryBatches,
        inventoryAdjustments,
        meals,
        medicationSchedules,
        doseInstances,
        doseInventoryConsumption,
        appointments,
        vitalsMeasurements,
        dietaryRules,
        prescriptions,
        notifications,
        patientNotificationPreferences,
        auditEvents,
        trashItems,
        appSettings
      ];
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  required String personId,
  required String fullName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> preferredLanguage,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<String> personId,
  Value<String> fullName,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> preferredLanguage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
      column: $table.preferredLanguage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PersonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, BaseReferences<_$AppDatabase, $PersonsTable, Person>),
    Person,
    PrefetchHooks Function()> {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> personId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> preferredLanguage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion(
            personId: personId,
            fullName: fullName,
            phone: phone,
            email: email,
            preferredLanguage: preferredLanguage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String personId,
            required String fullName,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> preferredLanguage = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion.insert(
            personId: personId,
            fullName: fullName,
            phone: phone,
            email: email,
            preferredLanguage: preferredLanguage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, BaseReferences<_$AppDatabase, $PersonsTable, Person>),
    Person,
    PrefetchHooks Function()>;
typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String patientId,
  Value<String?> dateOfBirth,
  Value<String?> sex,
  Value<String?> bloodType,
  Value<String?> emergencyContactName,
  Value<String?> emergencyContactPhone,
  Value<String?> notes,
  required String timezone,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> patientId,
  Value<String?> dateOfBirth,
  Value<String?> sex,
  Value<String?> bloodType,
  Value<String?> emergencyContactName,
  Value<String?> emergencyContactPhone,
  Value<String?> notes,
  Value<String> timezone,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bloodType => $composableBuilder(
      column: $table.bloodType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, BaseReferences<_$AppDatabase, $PatientsTable, Patient>),
    Patient,
    PrefetchHooks Function()> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> patientId = const Value.absent(),
            Value<String?> dateOfBirth = const Value.absent(),
            Value<String?> sex = const Value.absent(),
            Value<String?> bloodType = const Value.absent(),
            Value<String?> emergencyContactName = const Value.absent(),
            Value<String?> emergencyContactPhone = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            patientId: patientId,
            dateOfBirth: dateOfBirth,
            sex: sex,
            bloodType: bloodType,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            notes: notes,
            timezone: timezone,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String patientId,
            Value<String?> dateOfBirth = const Value.absent(),
            Value<String?> sex = const Value.absent(),
            Value<String?> bloodType = const Value.absent(),
            Value<String?> emergencyContactName = const Value.absent(),
            Value<String?> emergencyContactPhone = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String timezone,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            patientId: patientId,
            dateOfBirth: dateOfBirth,
            sex: sex,
            bloodType: bloodType,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            notes: notes,
            timezone: timezone,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, BaseReferences<_$AppDatabase, $PatientsTable, Patient>),
    Patient,
    PrefetchHooks Function()>;
typedef $$CaregiverAssignmentsTableCreateCompanionBuilder
    = CaregiverAssignmentsCompanion Function({
  required String assignmentId,
  required String patientId,
  required String caregiverPersonId,
  Value<String?> relationship,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> removedAt,
  Value<int> rowid,
});
typedef $$CaregiverAssignmentsTableUpdateCompanionBuilder
    = CaregiverAssignmentsCompanion Function({
  Value<String> assignmentId,
  Value<String> patientId,
  Value<String> caregiverPersonId,
  Value<String?> relationship,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> removedAt,
  Value<int> rowid,
});

class $$CaregiverAssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $CaregiverAssignmentsTable> {
  $$CaregiverAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assignmentId => $composableBuilder(
      column: $table.assignmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caregiverPersonId => $composableBuilder(
      column: $table.caregiverPersonId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get removedAt => $composableBuilder(
      column: $table.removedAt, builder: (column) => ColumnFilters(column));
}

class $$CaregiverAssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CaregiverAssignmentsTable> {
  $$CaregiverAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assignmentId => $composableBuilder(
      column: $table.assignmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caregiverPersonId => $composableBuilder(
      column: $table.caregiverPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationship => $composableBuilder(
      column: $table.relationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get removedAt => $composableBuilder(
      column: $table.removedAt, builder: (column) => ColumnOrderings(column));
}

class $$CaregiverAssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaregiverAssignmentsTable> {
  $$CaregiverAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assignmentId => $composableBuilder(
      column: $table.assignmentId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get caregiverPersonId => $composableBuilder(
      column: $table.caregiverPersonId, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get removedAt =>
      $composableBuilder(column: $table.removedAt, builder: (column) => column);
}

class $$CaregiverAssignmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CaregiverAssignmentsTable,
    CaregiverAssignment,
    $$CaregiverAssignmentsTableFilterComposer,
    $$CaregiverAssignmentsTableOrderingComposer,
    $$CaregiverAssignmentsTableAnnotationComposer,
    $$CaregiverAssignmentsTableCreateCompanionBuilder,
    $$CaregiverAssignmentsTableUpdateCompanionBuilder,
    (
      CaregiverAssignment,
      BaseReferences<_$AppDatabase, $CaregiverAssignmentsTable,
          CaregiverAssignment>
    ),
    CaregiverAssignment,
    PrefetchHooks Function()> {
  $$CaregiverAssignmentsTableTableManager(
      _$AppDatabase db, $CaregiverAssignmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaregiverAssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaregiverAssignmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaregiverAssignmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> assignmentId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> caregiverPersonId = const Value.absent(),
            Value<String?> relationship = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> removedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CaregiverAssignmentsCompanion(
            assignmentId: assignmentId,
            patientId: patientId,
            caregiverPersonId: caregiverPersonId,
            relationship: relationship,
            createdAt: createdAt,
            updatedAt: updatedAt,
            removedAt: removedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String assignmentId,
            required String patientId,
            required String caregiverPersonId,
            Value<String?> relationship = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> removedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CaregiverAssignmentsCompanion.insert(
            assignmentId: assignmentId,
            patientId: patientId,
            caregiverPersonId: caregiverPersonId,
            relationship: relationship,
            createdAt: createdAt,
            updatedAt: updatedAt,
            removedAt: removedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CaregiverAssignmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CaregiverAssignmentsTable,
        CaregiverAssignment,
        $$CaregiverAssignmentsTableFilterComposer,
        $$CaregiverAssignmentsTableOrderingComposer,
        $$CaregiverAssignmentsTableAnnotationComposer,
        $$CaregiverAssignmentsTableCreateCompanionBuilder,
        $$CaregiverAssignmentsTableUpdateCompanionBuilder,
        (
          CaregiverAssignment,
          BaseReferences<_$AppDatabase, $CaregiverAssignmentsTable,
              CaregiverAssignment>
        ),
        CaregiverAssignment,
        PrefetchHooks Function()>;
typedef $$PatientIllnessesTableCreateCompanionBuilder
    = PatientIllnessesCompanion Function({
  required String illnessId,
  required String patientId,
  required String conditionName,
  Value<String?> diagnosedDate,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PatientIllnessesTableUpdateCompanionBuilder
    = PatientIllnessesCompanion Function({
  Value<String> illnessId,
  Value<String> patientId,
  Value<String> conditionName,
  Value<String?> diagnosedDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$PatientIllnessesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientIllnessesTable> {
  $$PatientIllnessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get illnessId => $composableBuilder(
      column: $table.illnessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionName => $composableBuilder(
      column: $table.conditionName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosedDate => $composableBuilder(
      column: $table.diagnosedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$PatientIllnessesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientIllnessesTable> {
  $$PatientIllnessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get illnessId => $composableBuilder(
      column: $table.illnessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionName => $composableBuilder(
      column: $table.conditionName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosedDate => $composableBuilder(
      column: $table.diagnosedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientIllnessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientIllnessesTable> {
  $$PatientIllnessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get illnessId =>
      $composableBuilder(column: $table.illnessId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get conditionName => $composableBuilder(
      column: $table.conditionName, builder: (column) => column);

  GeneratedColumn<String> get diagnosedDate => $composableBuilder(
      column: $table.diagnosedDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PatientIllnessesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientIllnessesTable,
    Illness,
    $$PatientIllnessesTableFilterComposer,
    $$PatientIllnessesTableOrderingComposer,
    $$PatientIllnessesTableAnnotationComposer,
    $$PatientIllnessesTableCreateCompanionBuilder,
    $$PatientIllnessesTableUpdateCompanionBuilder,
    (Illness, BaseReferences<_$AppDatabase, $PatientIllnessesTable, Illness>),
    Illness,
    PrefetchHooks Function()> {
  $$PatientIllnessesTableTableManager(
      _$AppDatabase db, $PatientIllnessesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientIllnessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientIllnessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientIllnessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> illnessId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> conditionName = const Value.absent(),
            Value<String?> diagnosedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientIllnessesCompanion(
            illnessId: illnessId,
            patientId: patientId,
            conditionName: conditionName,
            diagnosedDate: diagnosedDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String illnessId,
            required String patientId,
            required String conditionName,
            Value<String?> diagnosedDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientIllnessesCompanion.insert(
            illnessId: illnessId,
            patientId: patientId,
            conditionName: conditionName,
            diagnosedDate: diagnosedDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientIllnessesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientIllnessesTable,
    Illness,
    $$PatientIllnessesTableFilterComposer,
    $$PatientIllnessesTableOrderingComposer,
    $$PatientIllnessesTableAnnotationComposer,
    $$PatientIllnessesTableCreateCompanionBuilder,
    $$PatientIllnessesTableUpdateCompanionBuilder,
    (Illness, BaseReferences<_$AppDatabase, $PatientIllnessesTable, Illness>),
    Illness,
    PrefetchHooks Function()>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  required String medicationId,
  required String patientId,
  Value<String?> catalogId,
  required String nameEn,
  Value<String?> nameAr,
  Value<String?> scientificName,
  Value<String?> strength,
  Value<String?> dosageForm,
  Value<String?> route,
  required String doseUnit,
  Value<String?> instructionsEn,
  Value<String?> instructionsAr,
  Value<String?> startDate,
  Value<String?> endDate,
  Value<bool> isPrn,
  Value<int?> maximumDailyQuantityScaled,
  Value<double?> catalogPriceEgp,
  Value<bool> storageOnly,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<String> medicationId,
  Value<String> patientId,
  Value<String?> catalogId,
  Value<String> nameEn,
  Value<String?> nameAr,
  Value<String?> scientificName,
  Value<String?> strength,
  Value<String?> dosageForm,
  Value<String?> route,
  Value<String> doseUnit,
  Value<String?> instructionsEn,
  Value<String?> instructionsAr,
  Value<String?> startDate,
  Value<String?> endDate,
  Value<bool> isPrn,
  Value<int?> maximumDailyQuantityScaled,
  Value<double?> catalogPriceEgp,
  Value<bool> storageOnly,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get catalogId => $composableBuilder(
      column: $table.catalogId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageForm => $composableBuilder(
      column: $table.dosageForm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get route => $composableBuilder(
      column: $table.route, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doseUnit => $composableBuilder(
      column: $table.doseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionsEn => $composableBuilder(
      column: $table.instructionsEn,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionsAr => $composableBuilder(
      column: $table.instructionsAr,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maximumDailyQuantityScaled => $composableBuilder(
      column: $table.maximumDailyQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get catalogPriceEgp => $composableBuilder(
      column: $table.catalogPriceEgp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get storageOnly => $composableBuilder(
      column: $table.storageOnly, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get catalogId => $composableBuilder(
      column: $table.catalogId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strength => $composableBuilder(
      column: $table.strength, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageForm => $composableBuilder(
      column: $table.dosageForm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get route => $composableBuilder(
      column: $table.route, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doseUnit => $composableBuilder(
      column: $table.doseUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionsEn => $composableBuilder(
      column: $table.instructionsEn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionsAr => $composableBuilder(
      column: $table.instructionsAr,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maximumDailyQuantityScaled => $composableBuilder(
      column: $table.maximumDailyQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get catalogPriceEgp => $composableBuilder(
      column: $table.catalogPriceEgp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get storageOnly => $composableBuilder(
      column: $table.storageOnly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
      column: $table.scientificName, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get dosageForm => $composableBuilder(
      column: $table.dosageForm, builder: (column) => column);

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => column);

  GeneratedColumn<String> get instructionsEn => $composableBuilder(
      column: $table.instructionsEn, builder: (column) => column);

  GeneratedColumn<String> get instructionsAr => $composableBuilder(
      column: $table.instructionsAr, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isPrn =>
      $composableBuilder(column: $table.isPrn, builder: (column) => column);

  GeneratedColumn<int> get maximumDailyQuantityScaled => $composableBuilder(
      column: $table.maximumDailyQuantityScaled, builder: (column) => column);

  GeneratedColumn<double> get catalogPriceEgp => $composableBuilder(
      column: $table.catalogPriceEgp, builder: (column) => column);

  GeneratedColumn<bool> get storageOnly => $composableBuilder(
      column: $table.storageOnly, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> medicationId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> catalogId = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<String?> scientificName = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> dosageForm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            Value<String> doseUnit = const Value.absent(),
            Value<String?> instructionsEn = const Value.absent(),
            Value<String?> instructionsAr = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<int?> maximumDailyQuantityScaled = const Value.absent(),
            Value<double?> catalogPriceEgp = const Value.absent(),
            Value<bool> storageOnly = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion(
            medicationId: medicationId,
            patientId: patientId,
            catalogId: catalogId,
            nameEn: nameEn,
            nameAr: nameAr,
            scientificName: scientificName,
            strength: strength,
            dosageForm: dosageForm,
            route: route,
            doseUnit: doseUnit,
            instructionsEn: instructionsEn,
            instructionsAr: instructionsAr,
            startDate: startDate,
            endDate: endDate,
            isPrn: isPrn,
            maximumDailyQuantityScaled: maximumDailyQuantityScaled,
            catalogPriceEgp: catalogPriceEgp,
            storageOnly: storageOnly,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String medicationId,
            required String patientId,
            Value<String?> catalogId = const Value.absent(),
            required String nameEn,
            Value<String?> nameAr = const Value.absent(),
            Value<String?> scientificName = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> dosageForm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            required String doseUnit,
            Value<String?> instructionsEn = const Value.absent(),
            Value<String?> instructionsAr = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<int?> maximumDailyQuantityScaled = const Value.absent(),
            Value<double?> catalogPriceEgp = const Value.absent(),
            Value<bool> storageOnly = const Value.absent(),
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            medicationId: medicationId,
            patientId: patientId,
            catalogId: catalogId,
            nameEn: nameEn,
            nameAr: nameAr,
            scientificName: scientificName,
            strength: strength,
            dosageForm: dosageForm,
            route: route,
            doseUnit: doseUnit,
            instructionsEn: instructionsEn,
            instructionsAr: instructionsAr,
            startDate: startDate,
            endDate: endDate,
            isPrn: isPrn,
            maximumDailyQuantityScaled: maximumDailyQuantityScaled,
            catalogPriceEgp: catalogPriceEgp,
            storageOnly: storageOnly,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()>;
typedef $$MedicationInventoryBatchesTableCreateCompanionBuilder
    = MedicationInventoryBatchesCompanion Function({
  required String inventoryBatchId,
  required String medicationId,
  Value<String?> purchaseDate,
  Value<double?> purchasePrice,
  Value<String?> expirationDate,
  Value<String?> packagingType,
  Value<int?> unitsPerPackage,
  Value<int?> packagesCount,
  Value<String?> subPackagingType,
  Value<int?> subPackagesPerPackage,
  Value<int?> looseQuantityScaled,
  required int initialQuantityScaled,
  required int availableQuantityScaled,
  Value<int> quantityScale,
  Value<bool> isDepleted,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MedicationInventoryBatchesTableUpdateCompanionBuilder
    = MedicationInventoryBatchesCompanion Function({
  Value<String> inventoryBatchId,
  Value<String> medicationId,
  Value<String?> purchaseDate,
  Value<double?> purchasePrice,
  Value<String?> expirationDate,
  Value<String?> packagingType,
  Value<int?> unitsPerPackage,
  Value<int?> packagesCount,
  Value<String?> subPackagingType,
  Value<int?> subPackagesPerPackage,
  Value<int?> looseQuantityScaled,
  Value<int> initialQuantityScaled,
  Value<int> availableQuantityScaled,
  Value<int> quantityScale,
  Value<bool> isDepleted,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MedicationInventoryBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationInventoryBatchesTable> {
  $$MedicationInventoryBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packagingType => $composableBuilder(
      column: $table.packagingType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get packagesCount => $composableBuilder(
      column: $table.packagesCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subPackagingType => $composableBuilder(
      column: $table.subPackagingType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subPackagesPerPackage => $composableBuilder(
      column: $table.subPackagesPerPackage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get looseQuantityScaled => $composableBuilder(
      column: $table.looseQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get initialQuantityScaled => $composableBuilder(
      column: $table.initialQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicationInventoryBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationInventoryBatchesTable> {
  $$MedicationInventoryBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packagingType => $composableBuilder(
      column: $table.packagingType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get packagesCount => $composableBuilder(
      column: $table.packagesCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subPackagingType => $composableBuilder(
      column: $table.subPackagingType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subPackagesPerPackage => $composableBuilder(
      column: $table.subPackagesPerPackage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get looseQuantityScaled => $composableBuilder(
      column: $table.looseQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get initialQuantityScaled => $composableBuilder(
      column: $table.initialQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicationInventoryBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationInventoryBatchesTable> {
  $$MedicationInventoryBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<String> get expirationDate => $composableBuilder(
      column: $table.expirationDate, builder: (column) => column);

  GeneratedColumn<String> get packagingType => $composableBuilder(
      column: $table.packagingType, builder: (column) => column);

  GeneratedColumn<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage, builder: (column) => column);

  GeneratedColumn<int> get packagesCount => $composableBuilder(
      column: $table.packagesCount, builder: (column) => column);

  GeneratedColumn<String> get subPackagingType => $composableBuilder(
      column: $table.subPackagingType, builder: (column) => column);

  GeneratedColumn<int> get subPackagesPerPackage => $composableBuilder(
      column: $table.subPackagesPerPackage, builder: (column) => column);

  GeneratedColumn<int> get looseQuantityScaled => $composableBuilder(
      column: $table.looseQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get initialQuantityScaled => $composableBuilder(
      column: $table.initialQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MedicationInventoryBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationInventoryBatchesTable,
    InventoryBatch,
    $$MedicationInventoryBatchesTableFilterComposer,
    $$MedicationInventoryBatchesTableOrderingComposer,
    $$MedicationInventoryBatchesTableAnnotationComposer,
    $$MedicationInventoryBatchesTableCreateCompanionBuilder,
    $$MedicationInventoryBatchesTableUpdateCompanionBuilder,
    (
      InventoryBatch,
      BaseReferences<_$AppDatabase, $MedicationInventoryBatchesTable,
          InventoryBatch>
    ),
    InventoryBatch,
    PrefetchHooks Function()> {
  $$MedicationInventoryBatchesTableTableManager(
      _$AppDatabase db, $MedicationInventoryBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationInventoryBatchesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationInventoryBatchesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationInventoryBatchesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> inventoryBatchId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String?> purchaseDate = const Value.absent(),
            Value<double?> purchasePrice = const Value.absent(),
            Value<String?> expirationDate = const Value.absent(),
            Value<String?> packagingType = const Value.absent(),
            Value<int?> unitsPerPackage = const Value.absent(),
            Value<int?> packagesCount = const Value.absent(),
            Value<String?> subPackagingType = const Value.absent(),
            Value<int?> subPackagesPerPackage = const Value.absent(),
            Value<int?> looseQuantityScaled = const Value.absent(),
            Value<int> initialQuantityScaled = const Value.absent(),
            Value<int> availableQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<bool> isDepleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationInventoryBatchesCompanion(
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            expirationDate: expirationDate,
            packagingType: packagingType,
            unitsPerPackage: unitsPerPackage,
            packagesCount: packagesCount,
            subPackagingType: subPackagingType,
            subPackagesPerPackage: subPackagesPerPackage,
            looseQuantityScaled: looseQuantityScaled,
            initialQuantityScaled: initialQuantityScaled,
            availableQuantityScaled: availableQuantityScaled,
            quantityScale: quantityScale,
            isDepleted: isDepleted,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String inventoryBatchId,
            required String medicationId,
            Value<String?> purchaseDate = const Value.absent(),
            Value<double?> purchasePrice = const Value.absent(),
            Value<String?> expirationDate = const Value.absent(),
            Value<String?> packagingType = const Value.absent(),
            Value<int?> unitsPerPackage = const Value.absent(),
            Value<int?> packagesCount = const Value.absent(),
            Value<String?> subPackagingType = const Value.absent(),
            Value<int?> subPackagesPerPackage = const Value.absent(),
            Value<int?> looseQuantityScaled = const Value.absent(),
            required int initialQuantityScaled,
            required int availableQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            Value<bool> isDepleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationInventoryBatchesCompanion.insert(
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            expirationDate: expirationDate,
            packagingType: packagingType,
            unitsPerPackage: unitsPerPackage,
            packagesCount: packagesCount,
            subPackagingType: subPackagingType,
            subPackagesPerPackage: subPackagesPerPackage,
            looseQuantityScaled: looseQuantityScaled,
            initialQuantityScaled: initialQuantityScaled,
            availableQuantityScaled: availableQuantityScaled,
            quantityScale: quantityScale,
            isDepleted: isDepleted,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationInventoryBatchesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MedicationInventoryBatchesTable,
        InventoryBatch,
        $$MedicationInventoryBatchesTableFilterComposer,
        $$MedicationInventoryBatchesTableOrderingComposer,
        $$MedicationInventoryBatchesTableAnnotationComposer,
        $$MedicationInventoryBatchesTableCreateCompanionBuilder,
        $$MedicationInventoryBatchesTableUpdateCompanionBuilder,
        (
          InventoryBatch,
          BaseReferences<_$AppDatabase, $MedicationInventoryBatchesTable,
              InventoryBatch>
        ),
        InventoryBatch,
        PrefetchHooks Function()>;
typedef $$InventoryAdjustmentsTableCreateCompanionBuilder
    = InventoryAdjustmentsCompanion Function({
  required String adjustmentId,
  required String inventoryBatchId,
  required String medicationId,
  required int previousQuantityScaled,
  required int deltaScaled,
  required int newQuantityScaled,
  Value<int> quantityScale,
  required String reason,
  Value<String?> notes,
  Value<String?> actorPersonId,
  required DateTime occurredAt,
  Value<int> rowid,
});
typedef $$InventoryAdjustmentsTableUpdateCompanionBuilder
    = InventoryAdjustmentsCompanion Function({
  Value<String> adjustmentId,
  Value<String> inventoryBatchId,
  Value<String> medicationId,
  Value<int> previousQuantityScaled,
  Value<int> deltaScaled,
  Value<int> newQuantityScaled,
  Value<int> quantityScale,
  Value<String> reason,
  Value<String?> notes,
  Value<String?> actorPersonId,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});

class $$InventoryAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get adjustmentId => $composableBuilder(
      column: $table.adjustmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousQuantityScaled => $composableBuilder(
      column: $table.previousQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deltaScaled => $composableBuilder(
      column: $table.deltaScaled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newQuantityScaled => $composableBuilder(
      column: $table.newQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));
}

class $$InventoryAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get adjustmentId => $composableBuilder(
      column: $table.adjustmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousQuantityScaled => $composableBuilder(
      column: $table.previousQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deltaScaled => $composableBuilder(
      column: $table.deltaScaled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newQuantityScaled => $composableBuilder(
      column: $table.newQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));
}

class $$InventoryAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get adjustmentId => $composableBuilder(
      column: $table.adjustmentId, builder: (column) => column);

  GeneratedColumn<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<int> get previousQuantityScaled => $composableBuilder(
      column: $table.previousQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get deltaScaled => $composableBuilder(
      column: $table.deltaScaled, builder: (column) => column);

  GeneratedColumn<int> get newQuantityScaled => $composableBuilder(
      column: $table.newQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);
}

class $$InventoryAdjustmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryAdjustmentsTable,
    InventoryAdjustment,
    $$InventoryAdjustmentsTableFilterComposer,
    $$InventoryAdjustmentsTableOrderingComposer,
    $$InventoryAdjustmentsTableAnnotationComposer,
    $$InventoryAdjustmentsTableCreateCompanionBuilder,
    $$InventoryAdjustmentsTableUpdateCompanionBuilder,
    (
      InventoryAdjustment,
      BaseReferences<_$AppDatabase, $InventoryAdjustmentsTable,
          InventoryAdjustment>
    ),
    InventoryAdjustment,
    PrefetchHooks Function()> {
  $$InventoryAdjustmentsTableTableManager(
      _$AppDatabase db, $InventoryAdjustmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryAdjustmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryAdjustmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> adjustmentId = const Value.absent(),
            Value<String> inventoryBatchId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<int> previousQuantityScaled = const Value.absent(),
            Value<int> deltaScaled = const Value.absent(),
            Value<int> newQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> actorPersonId = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryAdjustmentsCompanion(
            adjustmentId: adjustmentId,
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            previousQuantityScaled: previousQuantityScaled,
            deltaScaled: deltaScaled,
            newQuantityScaled: newQuantityScaled,
            quantityScale: quantityScale,
            reason: reason,
            notes: notes,
            actorPersonId: actorPersonId,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String adjustmentId,
            required String inventoryBatchId,
            required String medicationId,
            required int previousQuantityScaled,
            required int deltaScaled,
            required int newQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            required String reason,
            Value<String?> notes = const Value.absent(),
            Value<String?> actorPersonId = const Value.absent(),
            required DateTime occurredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryAdjustmentsCompanion.insert(
            adjustmentId: adjustmentId,
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            previousQuantityScaled: previousQuantityScaled,
            deltaScaled: deltaScaled,
            newQuantityScaled: newQuantityScaled,
            quantityScale: quantityScale,
            reason: reason,
            notes: notes,
            actorPersonId: actorPersonId,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InventoryAdjustmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $InventoryAdjustmentsTable,
        InventoryAdjustment,
        $$InventoryAdjustmentsTableFilterComposer,
        $$InventoryAdjustmentsTableOrderingComposer,
        $$InventoryAdjustmentsTableAnnotationComposer,
        $$InventoryAdjustmentsTableCreateCompanionBuilder,
        $$InventoryAdjustmentsTableUpdateCompanionBuilder,
        (
          InventoryAdjustment,
          BaseReferences<_$AppDatabase, $InventoryAdjustmentsTable,
              InventoryAdjustment>
        ),
        InventoryAdjustment,
        PrefetchHooks Function()>;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  required String mealId,
  required String patientId,
  required String nameEn,
  required String nameAr,
  required String mealType,
  Value<String?> defaultTime,
  Value<String> timeMode,
  Value<String?> weekdayTimes,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<String> mealId,
  Value<String> patientId,
  Value<String> nameEn,
  Value<String> nameAr,
  Value<String> mealType,
  Value<String?> defaultTime,
  Value<String> timeMode,
  Value<String?> weekdayTimes,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mealId => $composableBuilder(
      column: $table.mealId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultTime => $composableBuilder(
      column: $table.defaultTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeMode => $composableBuilder(
      column: $table.timeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdayTimes => $composableBuilder(
      column: $table.weekdayTimes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mealId => $composableBuilder(
      column: $table.mealId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultTime => $composableBuilder(
      column: $table.defaultTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeMode => $composableBuilder(
      column: $table.timeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdayTimes => $composableBuilder(
      column: $table.weekdayTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mealId =>
      $composableBuilder(column: $table.mealId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get defaultTime => $composableBuilder(
      column: $table.defaultTime, builder: (column) => column);

  GeneratedColumn<String> get timeMode =>
      $composableBuilder(column: $table.timeMode, builder: (column) => column);

  GeneratedColumn<String> get weekdayTimes => $composableBuilder(
      column: $table.weekdayTimes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
    Meal,
    PrefetchHooks Function()> {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mealId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<String?> defaultTime = const Value.absent(),
            Value<String> timeMode = const Value.absent(),
            Value<String?> weekdayTimes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealsCompanion(
            mealId: mealId,
            patientId: patientId,
            nameEn: nameEn,
            nameAr: nameAr,
            mealType: mealType,
            defaultTime: defaultTime,
            timeMode: timeMode,
            weekdayTimes: weekdayTimes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mealId,
            required String patientId,
            required String nameEn,
            required String nameAr,
            required String mealType,
            Value<String?> defaultTime = const Value.absent(),
            Value<String> timeMode = const Value.absent(),
            Value<String?> weekdayTimes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MealsCompanion.insert(
            mealId: mealId,
            patientId: patientId,
            nameEn: nameEn,
            nameAr: nameAr,
            mealType: mealType,
            defaultTime: defaultTime,
            timeMode: timeMode,
            weekdayTimes: weekdayTimes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
    Meal,
    PrefetchHooks Function()>;
typedef $$MedicationSchedulesTableCreateCompanionBuilder
    = MedicationSchedulesCompanion Function({
  required String scheduleId,
  required String medicationId,
  Value<String?> groupId,
  required String scheduleType,
  Value<String?> fixedTime,
  Value<String?> mealId,
  Value<String?> timingRelation,
  Value<int?> offsetMinutes,
  required int doseQuantityScaled,
  Value<int> quantityScale,
  required String recurrenceRule,
  Value<String?> validFrom,
  Value<String?> validUntil,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MedicationSchedulesTableUpdateCompanionBuilder
    = MedicationSchedulesCompanion Function({
  Value<String> scheduleId,
  Value<String> medicationId,
  Value<String?> groupId,
  Value<String> scheduleType,
  Value<String?> fixedTime,
  Value<String?> mealId,
  Value<String?> timingRelation,
  Value<int?> offsetMinutes,
  Value<int> doseQuantityScaled,
  Value<int> quantityScale,
  Value<String> recurrenceRule,
  Value<String?> validFrom,
  Value<String?> validUntil,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MedicationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealId => $composableBuilder(
      column: $table.mealId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timingRelation => $composableBuilder(
      column: $table.timingRelation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealId => $composableBuilder(
      column: $table.mealId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timingRelation => $composableBuilder(
      column: $table.timingRelation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get fixedTime =>
      $composableBuilder(column: $table.fixedTime, builder: (column) => column);

  GeneratedColumn<String> get mealId =>
      $composableBuilder(column: $table.mealId, builder: (column) => column);

  GeneratedColumn<String> get timingRelation => $composableBuilder(
      column: $table.timingRelation, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
      column: $table.offsetMinutes, builder: (column) => column);

  GeneratedColumn<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MedicationSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationSchedulesTable,
    MedicationSchedule,
    $$MedicationSchedulesTableFilterComposer,
    $$MedicationSchedulesTableOrderingComposer,
    $$MedicationSchedulesTableAnnotationComposer,
    $$MedicationSchedulesTableCreateCompanionBuilder,
    $$MedicationSchedulesTableUpdateCompanionBuilder,
    (
      MedicationSchedule,
      BaseReferences<_$AppDatabase, $MedicationSchedulesTable,
          MedicationSchedule>
    ),
    MedicationSchedule,
    PrefetchHooks Function()> {
  $$MedicationSchedulesTableTableManager(
      _$AppDatabase db, $MedicationSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationSchedulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scheduleId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String?> fixedTime = const Value.absent(),
            Value<String?> mealId = const Value.absent(),
            Value<String?> timingRelation = const Value.absent(),
            Value<int?> offsetMinutes = const Value.absent(),
            Value<int> doseQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String> recurrenceRule = const Value.absent(),
            Value<String?> validFrom = const Value.absent(),
            Value<String?> validUntil = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationSchedulesCompanion(
            scheduleId: scheduleId,
            medicationId: medicationId,
            groupId: groupId,
            scheduleType: scheduleType,
            fixedTime: fixedTime,
            mealId: mealId,
            timingRelation: timingRelation,
            offsetMinutes: offsetMinutes,
            doseQuantityScaled: doseQuantityScaled,
            quantityScale: quantityScale,
            recurrenceRule: recurrenceRule,
            validFrom: validFrom,
            validUntil: validUntil,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scheduleId,
            required String medicationId,
            Value<String?> groupId = const Value.absent(),
            required String scheduleType,
            Value<String?> fixedTime = const Value.absent(),
            Value<String?> mealId = const Value.absent(),
            Value<String?> timingRelation = const Value.absent(),
            Value<int?> offsetMinutes = const Value.absent(),
            required int doseQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            required String recurrenceRule,
            Value<String?> validFrom = const Value.absent(),
            Value<String?> validUntil = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationSchedulesCompanion.insert(
            scheduleId: scheduleId,
            medicationId: medicationId,
            groupId: groupId,
            scheduleType: scheduleType,
            fixedTime: fixedTime,
            mealId: mealId,
            timingRelation: timingRelation,
            offsetMinutes: offsetMinutes,
            doseQuantityScaled: doseQuantityScaled,
            quantityScale: quantityScale,
            recurrenceRule: recurrenceRule,
            validFrom: validFrom,
            validUntil: validUntil,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationSchedulesTable,
    MedicationSchedule,
    $$MedicationSchedulesTableFilterComposer,
    $$MedicationSchedulesTableOrderingComposer,
    $$MedicationSchedulesTableAnnotationComposer,
    $$MedicationSchedulesTableCreateCompanionBuilder,
    $$MedicationSchedulesTableUpdateCompanionBuilder,
    (
      MedicationSchedule,
      BaseReferences<_$AppDatabase, $MedicationSchedulesTable,
          MedicationSchedule>
    ),
    MedicationSchedule,
    PrefetchHooks Function()>;
typedef $$DoseInstancesTableCreateCompanionBuilder = DoseInstancesCompanion
    Function({
  required String doseInstanceId,
  required String patientId,
  required String medicationId,
  Value<String?> scheduleId,
  required String localDate,
  required DateTime scheduledAt,
  required int requiredQuantityScaled,
  Value<int> quantityScale,
  Value<int?> actualQuantityScaled,
  required String status,
  Value<DateTime?> takenAt,
  Value<DateTime?> skippedAt,
  Value<DateTime?> missedAt,
  Value<int?> lateMinutes,
  Value<bool> isPrn,
  Value<String?> loggedByPersonId,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DoseInstancesTableUpdateCompanionBuilder = DoseInstancesCompanion
    Function({
  Value<String> doseInstanceId,
  Value<String> patientId,
  Value<String> medicationId,
  Value<String?> scheduleId,
  Value<String> localDate,
  Value<DateTime> scheduledAt,
  Value<int> requiredQuantityScaled,
  Value<int> quantityScale,
  Value<int?> actualQuantityScaled,
  Value<String> status,
  Value<DateTime?> takenAt,
  Value<DateTime?> skippedAt,
  Value<DateTime?> missedAt,
  Value<int?> lateMinutes,
  Value<bool> isPrn,
  Value<String?> loggedByPersonId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DoseInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $DoseInstancesTable> {
  $$DoseInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiredQuantityScaled => $composableBuilder(
      column: $table.requiredQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualQuantityScaled => $composableBuilder(
      column: $table.actualQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get skippedAt => $composableBuilder(
      column: $table.skippedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get missedAt => $composableBuilder(
      column: $table.missedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loggedByPersonId => $composableBuilder(
      column: $table.loggedByPersonId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DoseInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseInstancesTable> {
  $$DoseInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiredQuantityScaled => $composableBuilder(
      column: $table.requiredQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualQuantityScaled => $composableBuilder(
      column: $table.actualQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get skippedAt => $composableBuilder(
      column: $table.skippedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get missedAt => $composableBuilder(
      column: $table.missedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loggedByPersonId => $composableBuilder(
      column: $table.loggedByPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DoseInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseInstancesTable> {
  $$DoseInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<int> get requiredQuantityScaled => $composableBuilder(
      column: $table.requiredQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<int> get actualQuantityScaled => $composableBuilder(
      column: $table.actualQuantityScaled, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get missedAt =>
      $composableBuilder(column: $table.missedAt, builder: (column) => column);

  GeneratedColumn<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => column);

  GeneratedColumn<bool> get isPrn =>
      $composableBuilder(column: $table.isPrn, builder: (column) => column);

  GeneratedColumn<String> get loggedByPersonId => $composableBuilder(
      column: $table.loggedByPersonId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DoseInstancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseInstancesTable,
    DoseInstance,
    $$DoseInstancesTableFilterComposer,
    $$DoseInstancesTableOrderingComposer,
    $$DoseInstancesTableAnnotationComposer,
    $$DoseInstancesTableCreateCompanionBuilder,
    $$DoseInstancesTableUpdateCompanionBuilder,
    (
      DoseInstance,
      BaseReferences<_$AppDatabase, $DoseInstancesTable, DoseInstance>
    ),
    DoseInstance,
    PrefetchHooks Function()> {
  $$DoseInstancesTableTableManager(_$AppDatabase db, $DoseInstancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseInstancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> doseInstanceId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String?> scheduleId = const Value.absent(),
            Value<String> localDate = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<int> requiredQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<int?> actualQuantityScaled = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> takenAt = const Value.absent(),
            Value<DateTime?> skippedAt = const Value.absent(),
            Value<DateTime?> missedAt = const Value.absent(),
            Value<int?> lateMinutes = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<String?> loggedByPersonId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInstancesCompanion(
            doseInstanceId: doseInstanceId,
            patientId: patientId,
            medicationId: medicationId,
            scheduleId: scheduleId,
            localDate: localDate,
            scheduledAt: scheduledAt,
            requiredQuantityScaled: requiredQuantityScaled,
            quantityScale: quantityScale,
            actualQuantityScaled: actualQuantityScaled,
            status: status,
            takenAt: takenAt,
            skippedAt: skippedAt,
            missedAt: missedAt,
            lateMinutes: lateMinutes,
            isPrn: isPrn,
            loggedByPersonId: loggedByPersonId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String doseInstanceId,
            required String patientId,
            required String medicationId,
            Value<String?> scheduleId = const Value.absent(),
            required String localDate,
            required DateTime scheduledAt,
            required int requiredQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            Value<int?> actualQuantityScaled = const Value.absent(),
            required String status,
            Value<DateTime?> takenAt = const Value.absent(),
            Value<DateTime?> skippedAt = const Value.absent(),
            Value<DateTime?> missedAt = const Value.absent(),
            Value<int?> lateMinutes = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<String?> loggedByPersonId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInstancesCompanion.insert(
            doseInstanceId: doseInstanceId,
            patientId: patientId,
            medicationId: medicationId,
            scheduleId: scheduleId,
            localDate: localDate,
            scheduledAt: scheduledAt,
            requiredQuantityScaled: requiredQuantityScaled,
            quantityScale: quantityScale,
            actualQuantityScaled: actualQuantityScaled,
            status: status,
            takenAt: takenAt,
            skippedAt: skippedAt,
            missedAt: missedAt,
            lateMinutes: lateMinutes,
            isPrn: isPrn,
            loggedByPersonId: loggedByPersonId,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DoseInstancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoseInstancesTable,
    DoseInstance,
    $$DoseInstancesTableFilterComposer,
    $$DoseInstancesTableOrderingComposer,
    $$DoseInstancesTableAnnotationComposer,
    $$DoseInstancesTableCreateCompanionBuilder,
    $$DoseInstancesTableUpdateCompanionBuilder,
    (
      DoseInstance,
      BaseReferences<_$AppDatabase, $DoseInstancesTable, DoseInstance>
    ),
    DoseInstance,
    PrefetchHooks Function()>;
typedef $$DoseInventoryConsumptionTableCreateCompanionBuilder
    = DoseInventoryConsumptionCompanion Function({
  required String consumptionId,
  required String doseInstanceId,
  required String inventoryBatchId,
  required int quantityScaled,
  Value<int> quantityScale,
  Value<bool> manuallySelected,
  required DateTime createdAt,
  Value<DateTime?> reversedAt,
  Value<int> rowid,
});
typedef $$DoseInventoryConsumptionTableUpdateCompanionBuilder
    = DoseInventoryConsumptionCompanion Function({
  Value<String> consumptionId,
  Value<String> doseInstanceId,
  Value<String> inventoryBatchId,
  Value<int> quantityScaled,
  Value<int> quantityScale,
  Value<bool> manuallySelected,
  Value<DateTime> createdAt,
  Value<DateTime?> reversedAt,
  Value<int> rowid,
});

class $$DoseInventoryConsumptionTableFilterComposer
    extends Composer<_$AppDatabase, $DoseInventoryConsumptionTable> {
  $$DoseInventoryConsumptionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get consumptionId => $composableBuilder(
      column: $table.consumptionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScaled => $composableBuilder(
      column: $table.quantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get manuallySelected => $composableBuilder(
      column: $table.manuallySelected,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
      column: $table.reversedAt, builder: (column) => ColumnFilters(column));
}

class $$DoseInventoryConsumptionTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseInventoryConsumptionTable> {
  $$DoseInventoryConsumptionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get consumptionId => $composableBuilder(
      column: $table.consumptionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScaled => $composableBuilder(
      column: $table.quantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get manuallySelected => $composableBuilder(
      column: $table.manuallySelected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
      column: $table.reversedAt, builder: (column) => ColumnOrderings(column));
}

class $$DoseInventoryConsumptionTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseInventoryConsumptionTable> {
  $$DoseInventoryConsumptionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get consumptionId => $composableBuilder(
      column: $table.consumptionId, builder: (column) => column);

  GeneratedColumn<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId, builder: (column) => column);

  GeneratedColumn<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId, builder: (column) => column);

  GeneratedColumn<int> get quantityScaled => $composableBuilder(
      column: $table.quantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<bool> get manuallySelected => $composableBuilder(
      column: $table.manuallySelected, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
      column: $table.reversedAt, builder: (column) => column);
}

class $$DoseInventoryConsumptionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseInventoryConsumptionTable,
    DoseConsumption,
    $$DoseInventoryConsumptionTableFilterComposer,
    $$DoseInventoryConsumptionTableOrderingComposer,
    $$DoseInventoryConsumptionTableAnnotationComposer,
    $$DoseInventoryConsumptionTableCreateCompanionBuilder,
    $$DoseInventoryConsumptionTableUpdateCompanionBuilder,
    (
      DoseConsumption,
      BaseReferences<_$AppDatabase, $DoseInventoryConsumptionTable,
          DoseConsumption>
    ),
    DoseConsumption,
    PrefetchHooks Function()> {
  $$DoseInventoryConsumptionTableTableManager(
      _$AppDatabase db, $DoseInventoryConsumptionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseInventoryConsumptionTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseInventoryConsumptionTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseInventoryConsumptionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> consumptionId = const Value.absent(),
            Value<String> doseInstanceId = const Value.absent(),
            Value<String> inventoryBatchId = const Value.absent(),
            Value<int> quantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<bool> manuallySelected = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> reversedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInventoryConsumptionCompanion(
            consumptionId: consumptionId,
            doseInstanceId: doseInstanceId,
            inventoryBatchId: inventoryBatchId,
            quantityScaled: quantityScaled,
            quantityScale: quantityScale,
            manuallySelected: manuallySelected,
            createdAt: createdAt,
            reversedAt: reversedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String consumptionId,
            required String doseInstanceId,
            required String inventoryBatchId,
            required int quantityScaled,
            Value<int> quantityScale = const Value.absent(),
            Value<bool> manuallySelected = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> reversedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInventoryConsumptionCompanion.insert(
            consumptionId: consumptionId,
            doseInstanceId: doseInstanceId,
            inventoryBatchId: inventoryBatchId,
            quantityScaled: quantityScaled,
            quantityScale: quantityScale,
            manuallySelected: manuallySelected,
            createdAt: createdAt,
            reversedAt: reversedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DoseInventoryConsumptionTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DoseInventoryConsumptionTable,
        DoseConsumption,
        $$DoseInventoryConsumptionTableFilterComposer,
        $$DoseInventoryConsumptionTableOrderingComposer,
        $$DoseInventoryConsumptionTableAnnotationComposer,
        $$DoseInventoryConsumptionTableCreateCompanionBuilder,
        $$DoseInventoryConsumptionTableUpdateCompanionBuilder,
        (
          DoseConsumption,
          BaseReferences<_$AppDatabase, $DoseInventoryConsumptionTable,
              DoseConsumption>
        ),
        DoseConsumption,
        PrefetchHooks Function()>;
typedef $$AppointmentsTableCreateCompanionBuilder = AppointmentsCompanion
    Function({
  required String appointmentId,
  required String patientId,
  required String doctorName,
  Value<String?> specialty,
  required DateTime scheduledTime,
  Value<String?> location,
  Value<String?> notes,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$AppointmentsTableUpdateCompanionBuilder = AppointmentsCompanion
    Function({
  Value<String> appointmentId,
  Value<String> patientId,
  Value<String> doctorName,
  Value<String?> specialty,
  Value<DateTime> scheduledTime,
  Value<String?> location,
  Value<String?> notes,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$AppointmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (
      Appointment,
      BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment>
    ),
    Appointment,
    PrefetchHooks Function()> {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> appointmentId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> doctorName = const Value.absent(),
            Value<String?> specialty = const Value.absent(),
            Value<DateTime> scheduledTime = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppointmentsCompanion(
            appointmentId: appointmentId,
            patientId: patientId,
            doctorName: doctorName,
            specialty: specialty,
            scheduledTime: scheduledTime,
            location: location,
            notes: notes,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String appointmentId,
            required String patientId,
            required String doctorName,
            Value<String?> specialty = const Value.absent(),
            required DateTime scheduledTime,
            Value<String?> location = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppointmentsCompanion.insert(
            appointmentId: appointmentId,
            patientId: patientId,
            doctorName: doctorName,
            specialty: specialty,
            scheduledTime: scheduledTime,
            location: location,
            notes: notes,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppointmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppointmentsTable,
    Appointment,
    $$AppointmentsTableFilterComposer,
    $$AppointmentsTableOrderingComposer,
    $$AppointmentsTableAnnotationComposer,
    $$AppointmentsTableCreateCompanionBuilder,
    $$AppointmentsTableUpdateCompanionBuilder,
    (
      Appointment,
      BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment>
    ),
    Appointment,
    PrefetchHooks Function()>;
typedef $$VitalsMeasurementsTableCreateCompanionBuilder
    = VitalsMeasurementsCompanion Function({
  required String measurementId,
  required String patientId,
  required String measurementType,
  Value<double?> value1,
  Value<double?> value2,
  Value<String?> unit,
  Value<String?> context,
  Value<String?> relatedMealId,
  Value<String?> relatedMedicationId,
  Value<int?> minutesAfter,
  required DateTime measuredAt,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$VitalsMeasurementsTableUpdateCompanionBuilder
    = VitalsMeasurementsCompanion Function({
  Value<String> measurementId,
  Value<String> patientId,
  Value<String> measurementType,
  Value<double?> value1,
  Value<double?> value2,
  Value<String?> unit,
  Value<String?> context,
  Value<String?> relatedMealId,
  Value<String?> relatedMedicationId,
  Value<int?> minutesAfter,
  Value<DateTime> measuredAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$VitalsMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $VitalsMeasurementsTable> {
  $$VitalsMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get measurementId => $composableBuilder(
      column: $table.measurementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measurementType => $composableBuilder(
      column: $table.measurementType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value1 => $composableBuilder(
      column: $table.value1, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value2 => $composableBuilder(
      column: $table.value2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedMealId => $composableBuilder(
      column: $table.relatedMealId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedMedicationId => $composableBuilder(
      column: $table.relatedMedicationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutesAfter => $composableBuilder(
      column: $table.minutesAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$VitalsMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalsMeasurementsTable> {
  $$VitalsMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get measurementId => $composableBuilder(
      column: $table.measurementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measurementType => $composableBuilder(
      column: $table.measurementType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value1 => $composableBuilder(
      column: $table.value1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value2 => $composableBuilder(
      column: $table.value2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context => $composableBuilder(
      column: $table.context, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedMealId => $composableBuilder(
      column: $table.relatedMealId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedMedicationId => $composableBuilder(
      column: $table.relatedMedicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutesAfter => $composableBuilder(
      column: $table.minutesAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$VitalsMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalsMeasurementsTable> {
  $$VitalsMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get measurementId => $composableBuilder(
      column: $table.measurementId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get measurementType => $composableBuilder(
      column: $table.measurementType, builder: (column) => column);

  GeneratedColumn<double> get value1 =>
      $composableBuilder(column: $table.value1, builder: (column) => column);

  GeneratedColumn<double> get value2 =>
      $composableBuilder(column: $table.value2, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);

  GeneratedColumn<String> get relatedMealId => $composableBuilder(
      column: $table.relatedMealId, builder: (column) => column);

  GeneratedColumn<String> get relatedMedicationId => $composableBuilder(
      column: $table.relatedMedicationId, builder: (column) => column);

  GeneratedColumn<int> get minutesAfter => $composableBuilder(
      column: $table.minutesAfter, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$VitalsMeasurementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VitalsMeasurementsTable,
    VitalMeasurement,
    $$VitalsMeasurementsTableFilterComposer,
    $$VitalsMeasurementsTableOrderingComposer,
    $$VitalsMeasurementsTableAnnotationComposer,
    $$VitalsMeasurementsTableCreateCompanionBuilder,
    $$VitalsMeasurementsTableUpdateCompanionBuilder,
    (
      VitalMeasurement,
      BaseReferences<_$AppDatabase, $VitalsMeasurementsTable, VitalMeasurement>
    ),
    VitalMeasurement,
    PrefetchHooks Function()> {
  $$VitalsMeasurementsTableTableManager(
      _$AppDatabase db, $VitalsMeasurementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalsMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalsMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalsMeasurementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> measurementId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> measurementType = const Value.absent(),
            Value<double?> value1 = const Value.absent(),
            Value<double?> value2 = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> context = const Value.absent(),
            Value<String?> relatedMealId = const Value.absent(),
            Value<String?> relatedMedicationId = const Value.absent(),
            Value<int?> minutesAfter = const Value.absent(),
            Value<DateTime> measuredAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VitalsMeasurementsCompanion(
            measurementId: measurementId,
            patientId: patientId,
            measurementType: measurementType,
            value1: value1,
            value2: value2,
            unit: unit,
            context: context,
            relatedMealId: relatedMealId,
            relatedMedicationId: relatedMedicationId,
            minutesAfter: minutesAfter,
            measuredAt: measuredAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String measurementId,
            required String patientId,
            required String measurementType,
            Value<double?> value1 = const Value.absent(),
            Value<double?> value2 = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> context = const Value.absent(),
            Value<String?> relatedMealId = const Value.absent(),
            Value<String?> relatedMedicationId = const Value.absent(),
            Value<int?> minutesAfter = const Value.absent(),
            required DateTime measuredAt,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VitalsMeasurementsCompanion.insert(
            measurementId: measurementId,
            patientId: patientId,
            measurementType: measurementType,
            value1: value1,
            value2: value2,
            unit: unit,
            context: context,
            relatedMealId: relatedMealId,
            relatedMedicationId: relatedMedicationId,
            minutesAfter: minutesAfter,
            measuredAt: measuredAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VitalsMeasurementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VitalsMeasurementsTable,
    VitalMeasurement,
    $$VitalsMeasurementsTableFilterComposer,
    $$VitalsMeasurementsTableOrderingComposer,
    $$VitalsMeasurementsTableAnnotationComposer,
    $$VitalsMeasurementsTableCreateCompanionBuilder,
    $$VitalsMeasurementsTableUpdateCompanionBuilder,
    (
      VitalMeasurement,
      BaseReferences<_$AppDatabase, $VitalsMeasurementsTable, VitalMeasurement>
    ),
    VitalMeasurement,
    PrefetchHooks Function()>;
typedef $$DietaryRulesTableCreateCompanionBuilder = DietaryRulesCompanion
    Function({
  required String dietRuleId,
  required String patientId,
  required String foodItemEn,
  Value<String?> foodItemAr,
  required String ruleType,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$DietaryRulesTableUpdateCompanionBuilder = DietaryRulesCompanion
    Function({
  Value<String> dietRuleId,
  Value<String> patientId,
  Value<String> foodItemEn,
  Value<String?> foodItemAr,
  Value<String> ruleType,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$DietaryRulesTableFilterComposer
    extends Composer<_$AppDatabase, $DietaryRulesTable> {
  $$DietaryRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dietRuleId => $composableBuilder(
      column: $table.dietRuleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodItemEn => $composableBuilder(
      column: $table.foodItemEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodItemAr => $composableBuilder(
      column: $table.foodItemAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$DietaryRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $DietaryRulesTable> {
  $$DietaryRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dietRuleId => $composableBuilder(
      column: $table.dietRuleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodItemEn => $composableBuilder(
      column: $table.foodItemEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodItemAr => $composableBuilder(
      column: $table.foodItemAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ruleType => $composableBuilder(
      column: $table.ruleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$DietaryRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DietaryRulesTable> {
  $$DietaryRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dietRuleId => $composableBuilder(
      column: $table.dietRuleId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get foodItemEn => $composableBuilder(
      column: $table.foodItemEn, builder: (column) => column);

  GeneratedColumn<String> get foodItemAr => $composableBuilder(
      column: $table.foodItemAr, builder: (column) => column);

  GeneratedColumn<String> get ruleType =>
      $composableBuilder(column: $table.ruleType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DietaryRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DietaryRulesTable,
    DietaryRule,
    $$DietaryRulesTableFilterComposer,
    $$DietaryRulesTableOrderingComposer,
    $$DietaryRulesTableAnnotationComposer,
    $$DietaryRulesTableCreateCompanionBuilder,
    $$DietaryRulesTableUpdateCompanionBuilder,
    (
      DietaryRule,
      BaseReferences<_$AppDatabase, $DietaryRulesTable, DietaryRule>
    ),
    DietaryRule,
    PrefetchHooks Function()> {
  $$DietaryRulesTableTableManager(_$AppDatabase db, $DietaryRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DietaryRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DietaryRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DietaryRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> dietRuleId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> foodItemEn = const Value.absent(),
            Value<String?> foodItemAr = const Value.absent(),
            Value<String> ruleType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DietaryRulesCompanion(
            dietRuleId: dietRuleId,
            patientId: patientId,
            foodItemEn: foodItemEn,
            foodItemAr: foodItemAr,
            ruleType: ruleType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String dietRuleId,
            required String patientId,
            required String foodItemEn,
            Value<String?> foodItemAr = const Value.absent(),
            required String ruleType,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DietaryRulesCompanion.insert(
            dietRuleId: dietRuleId,
            patientId: patientId,
            foodItemEn: foodItemEn,
            foodItemAr: foodItemAr,
            ruleType: ruleType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DietaryRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DietaryRulesTable,
    DietaryRule,
    $$DietaryRulesTableFilterComposer,
    $$DietaryRulesTableOrderingComposer,
    $$DietaryRulesTableAnnotationComposer,
    $$DietaryRulesTableCreateCompanionBuilder,
    $$DietaryRulesTableUpdateCompanionBuilder,
    (
      DietaryRule,
      BaseReferences<_$AppDatabase, $DietaryRulesTable, DietaryRule>
    ),
    DietaryRule,
    PrefetchHooks Function()>;
typedef $$PrescriptionsTableCreateCompanionBuilder = PrescriptionsCompanion
    Function({
  required String prescriptionId,
  required String patientId,
  Value<String?> doctorName,
  Value<String?> issueDate,
  required String filePath,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$PrescriptionsTableUpdateCompanionBuilder = PrescriptionsCompanion
    Function({
  Value<String> prescriptionId,
  Value<String> patientId,
  Value<String?> doctorName,
  Value<String?> issueDate,
  Value<String> filePath,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$PrescriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get prescriptionId => $composableBuilder(
      column: $table.prescriptionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get issueDate => $composableBuilder(
      column: $table.issueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$PrescriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get prescriptionId => $composableBuilder(
      column: $table.prescriptionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get issueDate => $composableBuilder(
      column: $table.issueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$PrescriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get prescriptionId => $composableBuilder(
      column: $table.prescriptionId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => column);

  GeneratedColumn<String> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PrescriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrescriptionsTable,
    Prescription,
    $$PrescriptionsTableFilterComposer,
    $$PrescriptionsTableOrderingComposer,
    $$PrescriptionsTableAnnotationComposer,
    $$PrescriptionsTableCreateCompanionBuilder,
    $$PrescriptionsTableUpdateCompanionBuilder,
    (
      Prescription,
      BaseReferences<_$AppDatabase, $PrescriptionsTable, Prescription>
    ),
    Prescription,
    PrefetchHooks Function()> {
  $$PrescriptionsTableTableManager(_$AppDatabase db, $PrescriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrescriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrescriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrescriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> prescriptionId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> doctorName = const Value.absent(),
            Value<String?> issueDate = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionsCompanion(
            prescriptionId: prescriptionId,
            patientId: patientId,
            doctorName: doctorName,
            issueDate: issueDate,
            filePath: filePath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String prescriptionId,
            required String patientId,
            Value<String?> doctorName = const Value.absent(),
            Value<String?> issueDate = const Value.absent(),
            required String filePath,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionsCompanion.insert(
            prescriptionId: prescriptionId,
            patientId: patientId,
            doctorName: doctorName,
            issueDate: issueDate,
            filePath: filePath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrescriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrescriptionsTable,
    Prescription,
    $$PrescriptionsTableFilterComposer,
    $$PrescriptionsTableOrderingComposer,
    $$PrescriptionsTableAnnotationComposer,
    $$PrescriptionsTableCreateCompanionBuilder,
    $$PrescriptionsTableUpdateCompanionBuilder,
    (
      Prescription,
      BaseReferences<_$AppDatabase, $PrescriptionsTable, Prescription>
    ),
    Prescription,
    PrefetchHooks Function()>;
typedef $$NotificationsTableCreateCompanionBuilder = NotificationsCompanion
    Function({
  required String notificationId,
  required String patientId,
  Value<String?> recipientPersonId,
  required String notificationType,
  required String dedupKey,
  required DateTime scheduledAt,
  Value<DateTime?> deliveredAt,
  required String status,
  Value<String?> doseInstanceId,
  Value<String?> appointmentId,
  Value<String?> inventoryBatchId,
  Value<String?> medicationId,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> bodyEn,
  Value<String?> bodyAr,
  Value<bool> isRead,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotificationsTableUpdateCompanionBuilder = NotificationsCompanion
    Function({
  Value<String> notificationId,
  Value<String> patientId,
  Value<String?> recipientPersonId,
  Value<String> notificationType,
  Value<String> dedupKey,
  Value<DateTime> scheduledAt,
  Value<DateTime?> deliveredAt,
  Value<String> status,
  Value<String?> doseInstanceId,
  Value<String?> appointmentId,
  Value<String?> inventoryBatchId,
  Value<String?> medicationId,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> bodyEn,
  Value<String?> bodyAr,
  Value<bool> isRead,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientPersonId => $composableBuilder(
      column: $table.recipientPersonId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dedupKey => $composableBuilder(
      column: $table.dedupKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleEn => $composableBuilder(
      column: $table.titleEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleAr => $composableBuilder(
      column: $table.titleAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyEn => $composableBuilder(
      column: $table.bodyEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bodyAr => $composableBuilder(
      column: $table.bodyAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientPersonId => $composableBuilder(
      column: $table.recipientPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dedupKey => $composableBuilder(
      column: $table.dedupKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicationId => $composableBuilder(
      column: $table.medicationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleEn => $composableBuilder(
      column: $table.titleEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleAr => $composableBuilder(
      column: $table.titleAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyEn => $composableBuilder(
      column: $table.bodyEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bodyAr => $composableBuilder(
      column: $table.bodyAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get recipientPersonId => $composableBuilder(
      column: $table.recipientPersonId, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
      column: $table.notificationType, builder: (column) => column);

  GeneratedColumn<String> get dedupKey =>
      $composableBuilder(column: $table.dedupKey, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get doseInstanceId => $composableBuilder(
      column: $table.doseInstanceId, builder: (column) => column);

  GeneratedColumn<String> get appointmentId => $composableBuilder(
      column: $table.appointmentId, builder: (column) => column);

  GeneratedColumn<String> get inventoryBatchId => $composableBuilder(
      column: $table.inventoryBatchId, builder: (column) => column);

  GeneratedColumn<String> get medicationId => $composableBuilder(
      column: $table.medicationId, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get bodyEn =>
      $composableBuilder(column: $table.bodyEn, builder: (column) => column);

  GeneratedColumn<String> get bodyAr =>
      $composableBuilder(column: $table.bodyAr, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsTable,
    AppNotification,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      AppNotification,
      BaseReferences<_$AppDatabase, $NotificationsTable, AppNotification>
    ),
    AppNotification,
    PrefetchHooks Function()> {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> notificationId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> recipientPersonId = const Value.absent(),
            Value<String> notificationType = const Value.absent(),
            Value<String> dedupKey = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> doseInstanceId = const Value.absent(),
            Value<String?> appointmentId = const Value.absent(),
            Value<String?> inventoryBatchId = const Value.absent(),
            Value<String?> medicationId = const Value.absent(),
            Value<String?> titleEn = const Value.absent(),
            Value<String?> titleAr = const Value.absent(),
            Value<String?> bodyEn = const Value.absent(),
            Value<String?> bodyAr = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion(
            notificationId: notificationId,
            patientId: patientId,
            recipientPersonId: recipientPersonId,
            notificationType: notificationType,
            dedupKey: dedupKey,
            scheduledAt: scheduledAt,
            deliveredAt: deliveredAt,
            status: status,
            doseInstanceId: doseInstanceId,
            appointmentId: appointmentId,
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            titleEn: titleEn,
            titleAr: titleAr,
            bodyEn: bodyEn,
            bodyAr: bodyAr,
            isRead: isRead,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String notificationId,
            required String patientId,
            Value<String?> recipientPersonId = const Value.absent(),
            required String notificationType,
            required String dedupKey,
            required DateTime scheduledAt,
            Value<DateTime?> deliveredAt = const Value.absent(),
            required String status,
            Value<String?> doseInstanceId = const Value.absent(),
            Value<String?> appointmentId = const Value.absent(),
            Value<String?> inventoryBatchId = const Value.absent(),
            Value<String?> medicationId = const Value.absent(),
            Value<String?> titleEn = const Value.absent(),
            Value<String?> titleAr = const Value.absent(),
            Value<String?> bodyEn = const Value.absent(),
            Value<String?> bodyAr = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion.insert(
            notificationId: notificationId,
            patientId: patientId,
            recipientPersonId: recipientPersonId,
            notificationType: notificationType,
            dedupKey: dedupKey,
            scheduledAt: scheduledAt,
            deliveredAt: deliveredAt,
            status: status,
            doseInstanceId: doseInstanceId,
            appointmentId: appointmentId,
            inventoryBatchId: inventoryBatchId,
            medicationId: medicationId,
            titleEn: titleEn,
            titleAr: titleAr,
            bodyEn: bodyEn,
            bodyAr: bodyAr,
            isRead: isRead,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsTable,
    AppNotification,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      AppNotification,
      BaseReferences<_$AppDatabase, $NotificationsTable, AppNotification>
    ),
    AppNotification,
    PrefetchHooks Function()>;
typedef $$PatientNotificationPreferencesTableCreateCompanionBuilder
    = PatientNotificationPreferencesCompanion Function({
  required String preferenceId,
  required String patientId,
  required String notificationType,
  required bool enabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PatientNotificationPreferencesTableUpdateCompanionBuilder
    = PatientNotificationPreferencesCompanion Function({
  Value<String> preferenceId,
  Value<String> patientId,
  Value<String> notificationType,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PatientNotificationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientNotificationPreferencesTable> {
  $$PatientNotificationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get preferenceId => $composableBuilder(
      column: $table.preferenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PatientNotificationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientNotificationPreferencesTable> {
  $$PatientNotificationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get preferenceId => $composableBuilder(
      column: $table.preferenceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientNotificationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientNotificationPreferencesTable> {
  $$PatientNotificationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get preferenceId => $composableBuilder(
      column: $table.preferenceId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
      column: $table.notificationType, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PatientNotificationPreferencesTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $PatientNotificationPreferencesTable,
        NotificationPreference,
        $$PatientNotificationPreferencesTableFilterComposer,
        $$PatientNotificationPreferencesTableOrderingComposer,
        $$PatientNotificationPreferencesTableAnnotationComposer,
        $$PatientNotificationPreferencesTableCreateCompanionBuilder,
        $$PatientNotificationPreferencesTableUpdateCompanionBuilder,
        (
          NotificationPreference,
          BaseReferences<_$AppDatabase, $PatientNotificationPreferencesTable,
              NotificationPreference>
        ),
        NotificationPreference,
        PrefetchHooks Function()> {
  $$PatientNotificationPreferencesTableTableManager(
      _$AppDatabase db, $PatientNotificationPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientNotificationPreferencesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientNotificationPreferencesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientNotificationPreferencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> preferenceId = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> notificationType = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientNotificationPreferencesCompanion(
            preferenceId: preferenceId,
            patientId: patientId,
            notificationType: notificationType,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String preferenceId,
            required String patientId,
            required String notificationType,
            required bool enabled,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientNotificationPreferencesCompanion.insert(
            preferenceId: preferenceId,
            patientId: patientId,
            notificationType: notificationType,
            enabled: enabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientNotificationPreferencesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PatientNotificationPreferencesTable,
        NotificationPreference,
        $$PatientNotificationPreferencesTableFilterComposer,
        $$PatientNotificationPreferencesTableOrderingComposer,
        $$PatientNotificationPreferencesTableAnnotationComposer,
        $$PatientNotificationPreferencesTableCreateCompanionBuilder,
        $$PatientNotificationPreferencesTableUpdateCompanionBuilder,
        (
          NotificationPreference,
          BaseReferences<_$AppDatabase, $PatientNotificationPreferencesTable,
              NotificationPreference>
        ),
        NotificationPreference,
        PrefetchHooks Function()>;
typedef $$AuditEventsTableCreateCompanionBuilder = AuditEventsCompanion
    Function({
  required String auditEventId,
  Value<String?> patientId,
  Value<String?> actorPersonId,
  required String entityType,
  required String entityId,
  required String action,
  required DateTime occurredAt,
  Value<String?> metadataJson,
  Value<int> rowid,
});
typedef $$AuditEventsTableUpdateCompanionBuilder = AuditEventsCompanion
    Function({
  Value<String> auditEventId,
  Value<String?> patientId,
  Value<String?> actorPersonId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> action,
  Value<DateTime> occurredAt,
  Value<String?> metadataJson,
  Value<int> rowid,
});

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get auditEventId => $composableBuilder(
      column: $table.auditEventId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get auditEventId => $composableBuilder(
      column: $table.auditEventId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get auditEventId => $composableBuilder(
      column: $table.auditEventId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get actorPersonId => $composableBuilder(
      column: $table.actorPersonId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);
}

class $$AuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>),
    AuditEvent,
    PrefetchHooks Function()> {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> auditEventId = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            Value<String?> actorPersonId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion(
            auditEventId: auditEventId,
            patientId: patientId,
            actorPersonId: actorPersonId,
            entityType: entityType,
            entityId: entityId,
            action: action,
            occurredAt: occurredAt,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String auditEventId,
            Value<String?> patientId = const Value.absent(),
            Value<String?> actorPersonId = const Value.absent(),
            required String entityType,
            required String entityId,
            required String action,
            required DateTime occurredAt,
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion.insert(
            auditEventId: auditEventId,
            patientId: patientId,
            actorPersonId: actorPersonId,
            entityType: entityType,
            entityId: entityId,
            action: action,
            occurredAt: occurredAt,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>),
    AuditEvent,
    PrefetchHooks Function()>;
typedef $$TrashItemsTableCreateCompanionBuilder = TrashItemsCompanion Function({
  required String trashItemId,
  Value<String?> patientId,
  required String entityType,
  required String entityId,
  Value<String?> label,
  required DateTime deletedAt,
  Value<DateTime?> restoredAt,
  Value<DateTime?> permanentlyDeletedAt,
  Value<String?> snapshotJson,
  Value<int> rowid,
});
typedef $$TrashItemsTableUpdateCompanionBuilder = TrashItemsCompanion Function({
  Value<String> trashItemId,
  Value<String?> patientId,
  Value<String> entityType,
  Value<String> entityId,
  Value<String?> label,
  Value<DateTime> deletedAt,
  Value<DateTime?> restoredAt,
  Value<DateTime?> permanentlyDeletedAt,
  Value<String?> snapshotJson,
  Value<int> rowid,
});

class $$TrashItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TrashItemsTable> {
  $$TrashItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trashItemId => $composableBuilder(
      column: $table.trashItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get restoredAt => $composableBuilder(
      column: $table.restoredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get permanentlyDeletedAt => $composableBuilder(
      column: $table.permanentlyDeletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => ColumnFilters(column));
}

class $$TrashItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrashItemsTable> {
  $$TrashItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trashItemId => $composableBuilder(
      column: $table.trashItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get restoredAt => $composableBuilder(
      column: $table.restoredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get permanentlyDeletedAt => $composableBuilder(
      column: $table.permanentlyDeletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson,
      builder: (column) => ColumnOrderings(column));
}

class $$TrashItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrashItemsTable> {
  $$TrashItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trashItemId => $composableBuilder(
      column: $table.trashItemId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get restoredAt => $composableBuilder(
      column: $table.restoredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get permanentlyDeletedAt => $composableBuilder(
      column: $table.permanentlyDeletedAt, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => column);
}

class $$TrashItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrashItemsTable,
    TrashItem,
    $$TrashItemsTableFilterComposer,
    $$TrashItemsTableOrderingComposer,
    $$TrashItemsTableAnnotationComposer,
    $$TrashItemsTableCreateCompanionBuilder,
    $$TrashItemsTableUpdateCompanionBuilder,
    (TrashItem, BaseReferences<_$AppDatabase, $TrashItemsTable, TrashItem>),
    TrashItem,
    PrefetchHooks Function()> {
  $$TrashItemsTableTableManager(_$AppDatabase db, $TrashItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrashItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrashItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrashItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> trashItemId = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<DateTime> deletedAt = const Value.absent(),
            Value<DateTime?> restoredAt = const Value.absent(),
            Value<DateTime?> permanentlyDeletedAt = const Value.absent(),
            Value<String?> snapshotJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrashItemsCompanion(
            trashItemId: trashItemId,
            patientId: patientId,
            entityType: entityType,
            entityId: entityId,
            label: label,
            deletedAt: deletedAt,
            restoredAt: restoredAt,
            permanentlyDeletedAt: permanentlyDeletedAt,
            snapshotJson: snapshotJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String trashItemId,
            Value<String?> patientId = const Value.absent(),
            required String entityType,
            required String entityId,
            Value<String?> label = const Value.absent(),
            required DateTime deletedAt,
            Value<DateTime?> restoredAt = const Value.absent(),
            Value<DateTime?> permanentlyDeletedAt = const Value.absent(),
            Value<String?> snapshotJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrashItemsCompanion.insert(
            trashItemId: trashItemId,
            patientId: patientId,
            entityType: entityType,
            entityId: entityId,
            label: label,
            deletedAt: deletedAt,
            restoredAt: restoredAt,
            permanentlyDeletedAt: permanentlyDeletedAt,
            snapshotJson: snapshotJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrashItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrashItemsTable,
    TrashItem,
    $$TrashItemsTableFilterComposer,
    $$TrashItemsTableOrderingComposer,
    $$TrashItemsTableAnnotationComposer,
    $$TrashItemsTableCreateCompanionBuilder,
    $$TrashItemsTableUpdateCompanionBuilder,
    (TrashItem, BaseReferences<_$AppDatabase, $TrashItemsTable, TrashItem>),
    TrashItem,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  Value<String?> value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$CaregiverAssignmentsTableTableManager get caregiverAssignments =>
      $$CaregiverAssignmentsTableTableManager(_db, _db.caregiverAssignments);
  $$PatientIllnessesTableTableManager get patientIllnesses =>
      $$PatientIllnessesTableTableManager(_db, _db.patientIllnesses);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationInventoryBatchesTableTableManager
      get medicationInventoryBatches =>
          $$MedicationInventoryBatchesTableTableManager(
              _db, _db.medicationInventoryBatches);
  $$InventoryAdjustmentsTableTableManager get inventoryAdjustments =>
      $$InventoryAdjustmentsTableTableManager(_db, _db.inventoryAdjustments);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$DoseInstancesTableTableManager get doseInstances =>
      $$DoseInstancesTableTableManager(_db, _db.doseInstances);
  $$DoseInventoryConsumptionTableTableManager get doseInventoryConsumption =>
      $$DoseInventoryConsumptionTableTableManager(
          _db, _db.doseInventoryConsumption);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$VitalsMeasurementsTableTableManager get vitalsMeasurements =>
      $$VitalsMeasurementsTableTableManager(_db, _db.vitalsMeasurements);
  $$DietaryRulesTableTableManager get dietaryRules =>
      $$DietaryRulesTableTableManager(_db, _db.dietaryRules);
  $$PrescriptionsTableTableManager get prescriptions =>
      $$PrescriptionsTableTableManager(_db, _db.prescriptions);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$PatientNotificationPreferencesTableTableManager
      get patientNotificationPreferences =>
          $$PatientNotificationPreferencesTableTableManager(
              _db, _db.patientNotificationPreferences);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
  $$TrashItemsTableTableManager get trashItems =>
      $$TrashItemsTableTableManager(_db, _db.trashItems);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
