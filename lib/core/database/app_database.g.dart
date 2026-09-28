// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients
    with TableInfo<$PatientsTable, PatientsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationMeta =
      const VerificationMeta('relation');
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
      'relation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timezoneMeta =
      const VerificationMeta('timezone');
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Africa/Cairo'));
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
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, relation, timezone, createdAt, updatedAt, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<PatientsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(_relationMeta,
          relation.isAcceptableOrUnknown(data['relation']!, _relationMeta));
    }
    if (data.containsKey('timezone')) {
      context.handle(_timezoneMeta,
          timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta));
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
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      relation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation']),
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class PatientsData extends DataClass implements Insertable<PatientsData> {
  final String id;
  final String name;
  final String? relation;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  const PatientsData(
      {required this.id,
      required this.name,
      this.relation,
      required this.timezone,
      required this.createdAt,
      required this.updatedAt,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || relation != null) {
      map['relation'] = Variable<String>(relation);
    }
    map['timezone'] = Variable<String>(timezone);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      relation: relation == null && nullToAbsent
          ? const Value.absent()
          : Value(relation),
      timezone: Value(timezone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory PatientsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientsData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      relation: serializer.fromJson<String?>(json['relation']),
      timezone: serializer.fromJson<String>(json['timezone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'relation': serializer.toJson<String?>(relation),
      'timezone': serializer.toJson<String>(timezone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  PatientsData copyWith(
          {String? id,
          String? name,
          Value<String?> relation = const Value.absent(),
          String? timezone,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isArchived}) =>
      PatientsData(
        id: id ?? this.id,
        name: name ?? this.name,
        relation: relation.present ? relation.value : this.relation,
        timezone: timezone ?? this.timezone,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isArchived: isArchived ?? this.isArchived,
      );
  PatientsData copyWithCompanion(PatientsCompanion data) {
    return PatientsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      relation: data.relation.present ? data.relation.value : this.relation,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, relation, timezone, createdAt, updatedAt, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.relation == this.relation &&
          other.timezone == this.timezone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class PatientsCompanion extends UpdateCompanion<PatientsData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> relation;
  final Value<String> timezone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.relation = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String name,
    this.relation = const Value.absent(),
    this.timezone = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PatientsData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? relation,
    Expression<String>? timezone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (relation != null) 'relation': relation,
      if (timezone != null) 'timezone': timezone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? relation,
      Value<String>? timezone,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
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
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unit'));
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
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isPrnMeta = const VerificationMeta('isPrn');
  @override
  late final GeneratedColumn<bool> isPrn = GeneratedColumn<bool>(
      'is_prn', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_prn" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _maxDailyQuantityScaledMeta =
      const VerificationMeta('maxDailyQuantityScaled');
  @override
  late final GeneratedColumn<int> maxDailyQuantityScaled = GeneratedColumn<int>(
      'max_daily_quantity_scaled', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        catalogId,
        nameEn,
        nameAr,
        strength,
        dosageForm,
        route,
        doseUnit,
        instructionsEn,
        instructionsAr,
        startDate,
        endDate,
        isPrn,
        maxDailyQuantityScaled,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<MedicationsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('max_daily_quantity_scaled')) {
      context.handle(
          _maxDailyQuantityScaledMeta,
          maxDailyQuantityScaled.isAcceptableOrUnknown(
              data['max_daily_quantity_scaled']!, _maxDailyQuantityScaledMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      catalogId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}catalog_id']),
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar']),
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
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      isPrn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_prn'])!,
      maxDailyQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}max_daily_quantity_scaled']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationsData extends DataClass implements Insertable<MedicationsData> {
  final String id;
  final String patientId;
  final String? catalogId;
  final String nameEn;
  final String? nameAr;
  final String? strength;
  final String? dosageForm;
  final String? route;
  final String doseUnit;
  final String? instructionsEn;
  final String? instructionsAr;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isPrn;
  final int? maxDailyQuantityScaled;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicationsData(
      {required this.id,
      required this.patientId,
      this.catalogId,
      required this.nameEn,
      this.nameAr,
      this.strength,
      this.dosageForm,
      this.route,
      required this.doseUnit,
      this.instructionsEn,
      this.instructionsAr,
      this.startDate,
      this.endDate,
      required this.isPrn,
      this.maxDailyQuantityScaled,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
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
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_prn'] = Variable<bool>(isPrn);
    if (!nullToAbsent || maxDailyQuantityScaled != null) {
      map['max_daily_quantity_scaled'] = Variable<int>(maxDailyQuantityScaled);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      catalogId: catalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogId),
      nameEn: Value(nameEn),
      nameAr:
          nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
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
      maxDailyQuantityScaled: maxDailyQuantityScaled == null && nullToAbsent
          ? const Value.absent()
          : Value(maxDailyQuantityScaled),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationsData(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String?>(json['nameAr']),
      strength: serializer.fromJson<String?>(json['strength']),
      dosageForm: serializer.fromJson<String?>(json['dosageForm']),
      route: serializer.fromJson<String?>(json['route']),
      doseUnit: serializer.fromJson<String>(json['doseUnit']),
      instructionsEn: serializer.fromJson<String?>(json['instructionsEn']),
      instructionsAr: serializer.fromJson<String?>(json['instructionsAr']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isPrn: serializer.fromJson<bool>(json['isPrn']),
      maxDailyQuantityScaled:
          serializer.fromJson<int?>(json['maxDailyQuantityScaled']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'catalogId': serializer.toJson<String?>(catalogId),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String?>(nameAr),
      'strength': serializer.toJson<String?>(strength),
      'dosageForm': serializer.toJson<String?>(dosageForm),
      'route': serializer.toJson<String?>(route),
      'doseUnit': serializer.toJson<String>(doseUnit),
      'instructionsEn': serializer.toJson<String?>(instructionsEn),
      'instructionsAr': serializer.toJson<String?>(instructionsAr),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isPrn': serializer.toJson<bool>(isPrn),
      'maxDailyQuantityScaled': serializer.toJson<int?>(maxDailyQuantityScaled),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicationsData copyWith(
          {String? id,
          String? patientId,
          Value<String?> catalogId = const Value.absent(),
          String? nameEn,
          Value<String?> nameAr = const Value.absent(),
          Value<String?> strength = const Value.absent(),
          Value<String?> dosageForm = const Value.absent(),
          Value<String?> route = const Value.absent(),
          String? doseUnit,
          Value<String?> instructionsEn = const Value.absent(),
          Value<String?> instructionsAr = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          bool? isPrn,
          Value<int?> maxDailyQuantityScaled = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MedicationsData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        catalogId: catalogId.present ? catalogId.value : this.catalogId,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr.present ? nameAr.value : this.nameAr,
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
        maxDailyQuantityScaled: maxDailyQuantityScaled.present
            ? maxDailyQuantityScaled.value
            : this.maxDailyQuantityScaled,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MedicationsData copyWithCompanion(MedicationsCompanion data) {
    return MedicationsData(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
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
      maxDailyQuantityScaled: data.maxDailyQuantityScaled.present
          ? data.maxDailyQuantityScaled.value
          : this.maxDailyQuantityScaled,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('catalogId: $catalogId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('route: $route, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructionsEn: $instructionsEn, ')
          ..write('instructionsAr: $instructionsAr, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isPrn: $isPrn, ')
          ..write('maxDailyQuantityScaled: $maxDailyQuantityScaled, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      catalogId,
      nameEn,
      nameAr,
      strength,
      dosageForm,
      route,
      doseUnit,
      instructionsEn,
      instructionsAr,
      startDate,
      endDate,
      isPrn,
      maxDailyQuantityScaled,
      isActive,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationsData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.catalogId == this.catalogId &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.strength == this.strength &&
          other.dosageForm == this.dosageForm &&
          other.route == this.route &&
          other.doseUnit == this.doseUnit &&
          other.instructionsEn == this.instructionsEn &&
          other.instructionsAr == this.instructionsAr &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isPrn == this.isPrn &&
          other.maxDailyQuantityScaled == this.maxDailyQuantityScaled &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationsCompanion extends UpdateCompanion<MedicationsData> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String?> catalogId;
  final Value<String> nameEn;
  final Value<String?> nameAr;
  final Value<String?> strength;
  final Value<String?> dosageForm;
  final Value<String?> route;
  final Value<String> doseUnit;
  final Value<String?> instructionsEn;
  final Value<String?> instructionsAr;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isPrn;
  final Value<int?> maxDailyQuantityScaled;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.route = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructionsEn = const Value.absent(),
    this.instructionsAr = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.maxDailyQuantityScaled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String patientId,
    this.catalogId = const Value.absent(),
    required String nameEn,
    this.nameAr = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.route = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructionsEn = const Value.absent(),
    this.instructionsAr = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isPrn = const Value.absent(),
    this.maxDailyQuantityScaled = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        nameEn = Value(nameEn),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MedicationsData> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? catalogId,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? strength,
    Expression<String>? dosageForm,
    Expression<String>? route,
    Expression<String>? doseUnit,
    Expression<String>? instructionsEn,
    Expression<String>? instructionsAr,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isPrn,
    Expression<int>? maxDailyQuantityScaled,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (catalogId != null) 'catalog_id': catalogId,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (strength != null) 'strength': strength,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (route != null) 'route': route,
      if (doseUnit != null) 'dose_unit': doseUnit,
      if (instructionsEn != null) 'instructions_en': instructionsEn,
      if (instructionsAr != null) 'instructions_ar': instructionsAr,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isPrn != null) 'is_prn': isPrn,
      if (maxDailyQuantityScaled != null)
        'max_daily_quantity_scaled': maxDailyQuantityScaled,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String?>? catalogId,
      Value<String>? nameEn,
      Value<String?>? nameAr,
      Value<String?>? strength,
      Value<String?>? dosageForm,
      Value<String?>? route,
      Value<String>? doseUnit,
      Value<String?>? instructionsEn,
      Value<String?>? instructionsAr,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? isPrn,
      Value<int?>? maxDailyQuantityScaled,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      catalogId: catalogId ?? this.catalogId,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      route: route ?? this.route,
      doseUnit: doseUnit ?? this.doseUnit,
      instructionsEn: instructionsEn ?? this.instructionsEn,
      instructionsAr: instructionsAr ?? this.instructionsAr,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isPrn: isPrn ?? this.isPrn,
      maxDailyQuantityScaled:
          maxDailyQuantityScaled ?? this.maxDailyQuantityScaled,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isPrn.present) {
      map['is_prn'] = Variable<bool>(isPrn.value);
    }
    if (maxDailyQuantityScaled.present) {
      map['max_daily_quantity_scaled'] =
          Variable<int>(maxDailyQuantityScaled.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('catalogId: $catalogId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('route: $route, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructionsEn: $instructionsEn, ')
          ..write('instructionsAr: $instructionsAr, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isPrn: $isPrn, ')
          ..write('maxDailyQuantityScaled: $maxDailyQuantityScaled, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medications (id)'));
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
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _validFromMeta =
      const VerificationMeta('validFrom');
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
      'valid_from', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _validUntilMeta =
      const VerificationMeta('validUntil');
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
      'valid_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicationId,
        scheduleType,
        fixedTime,
        recurrenceRule,
        doseQuantityScaled,
        quantityScale,
        validFrom,
        validUntil,
        isActive
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
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
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    } else if (isInserting) {
      context.missing(_recurrenceRuleMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      fixedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fixed_time']),
      recurrenceRule: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_rule'])!,
      doseQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}dose_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      validFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_from']),
      validUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_until']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $MedicationSchedulesTable createAlias(String alias) {
    return $MedicationSchedulesTable(attachedDatabase, alias);
  }
}

class MedicationSchedule extends DataClass
    implements Insertable<MedicationSchedule> {
  final String id;
  final String medicationId;
  final String scheduleType;
  final String? fixedTime;
  final String recurrenceRule;
  final int doseQuantityScaled;
  final int quantityScale;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;
  const MedicationSchedule(
      {required this.id,
      required this.medicationId,
      required this.scheduleType,
      this.fixedTime,
      required this.recurrenceRule,
      required this.doseQuantityScaled,
      required this.quantityScale,
      this.validFrom,
      this.validUntil,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['schedule_type'] = Variable<String>(scheduleType);
    if (!nullToAbsent || fixedTime != null) {
      map['fixed_time'] = Variable<String>(fixedTime);
    }
    map['recurrence_rule'] = Variable<String>(recurrenceRule);
    map['dose_quantity_scaled'] = Variable<int>(doseQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<DateTime>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MedicationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MedicationSchedulesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduleType: Value(scheduleType),
      fixedTime: fixedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTime),
      recurrenceRule: Value(recurrenceRule),
      doseQuantityScaled: Value(doseQuantityScaled),
      quantityScale: Value(quantityScale),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isActive: Value(isActive),
    );
  }

  factory MedicationSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationSchedule(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      fixedTime: serializer.fromJson<String?>(json['fixedTime']),
      recurrenceRule: serializer.fromJson<String>(json['recurrenceRule']),
      doseQuantityScaled: serializer.fromJson<int>(json['doseQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      validFrom: serializer.fromJson<DateTime?>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'fixedTime': serializer.toJson<String?>(fixedTime),
      'recurrenceRule': serializer.toJson<String>(recurrenceRule),
      'doseQuantityScaled': serializer.toJson<int>(doseQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'validFrom': serializer.toJson<DateTime?>(validFrom),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MedicationSchedule copyWith(
          {String? id,
          String? medicationId,
          String? scheduleType,
          Value<String?> fixedTime = const Value.absent(),
          String? recurrenceRule,
          int? doseQuantityScaled,
          int? quantityScale,
          Value<DateTime?> validFrom = const Value.absent(),
          Value<DateTime?> validUntil = const Value.absent(),
          bool? isActive}) =>
      MedicationSchedule(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        scheduleType: scheduleType ?? this.scheduleType,
        fixedTime: fixedTime.present ? fixedTime.value : this.fixedTime,
        recurrenceRule: recurrenceRule ?? this.recurrenceRule,
        doseQuantityScaled: doseQuantityScaled ?? this.doseQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        validFrom: validFrom.present ? validFrom.value : this.validFrom,
        validUntil: validUntil.present ? validUntil.value : this.validUntil,
        isActive: isActive ?? this.isActive,
      );
  MedicationSchedule copyWithCompanion(MedicationSchedulesCompanion data) {
    return MedicationSchedule(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      fixedTime: data.fixedTime.present ? data.fixedTime.value : this.fixedTime,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      doseQuantityScaled: data.doseQuantityScaled.present
          ? data.doseQuantityScaled.value
          : this.doseQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil:
          data.validUntil.present ? data.validUntil.value : this.validUntil,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedule(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('doseQuantityScaled: $doseQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicationId,
      scheduleType,
      fixedTime,
      recurrenceRule,
      doseQuantityScaled,
      quantityScale,
      validFrom,
      validUntil,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationSchedule &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduleType == this.scheduleType &&
          other.fixedTime == this.fixedTime &&
          other.recurrenceRule == this.recurrenceRule &&
          other.doseQuantityScaled == this.doseQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.isActive == this.isActive);
}

class MedicationSchedulesCompanion extends UpdateCompanion<MedicationSchedule> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<String> scheduleType;
  final Value<String?> fixedTime;
  final Value<String> recurrenceRule;
  final Value<int> doseQuantityScaled;
  final Value<int> quantityScale;
  final Value<DateTime?> validFrom;
  final Value<DateTime?> validUntil;
  final Value<bool> isActive;
  final Value<int> rowid;
  const MedicationSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.fixedTime = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.doseQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    required String id,
    required String medicationId,
    required String scheduleType,
    this.fixedTime = const Value.absent(),
    required String recurrenceRule,
    required int doseQuantityScaled,
    this.quantityScale = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        scheduleType = Value(scheduleType),
        recurrenceRule = Value(recurrenceRule),
        doseQuantityScaled = Value(doseQuantityScaled);
  static Insertable<MedicationSchedule> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<String>? scheduleType,
    Expression<String>? fixedTime,
    Expression<String>? recurrenceRule,
    Expression<int>? doseQuantityScaled,
    Expression<int>? quantityScale,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validUntil,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (fixedTime != null) 'fixed_time': fixedTime,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (doseQuantityScaled != null)
        'dose_quantity_scaled': doseQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<String>? scheduleType,
      Value<String?>? fixedTime,
      Value<String>? recurrenceRule,
      Value<int>? doseQuantityScaled,
      Value<int>? quantityScale,
      Value<DateTime?>? validFrom,
      Value<DateTime?>? validUntil,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return MedicationSchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduleType: scheduleType ?? this.scheduleType,
      fixedTime: fixedTime ?? this.fixedTime,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      doseQuantityScaled: doseQuantityScaled ?? this.doseQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (fixedTime.present) {
      map['fixed_time'] = Variable<String>(fixedTime.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (doseQuantityScaled.present) {
      map['dose_quantity_scaled'] = Variable<int>(doseQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('doseQuantityScaled: $doseQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryBatchesTable extends InventoryBatches
    with TableInfo<$InventoryBatchesTable, InventoryBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medications (id)'));
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
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _packagingTypeMeta =
      const VerificationMeta('packagingType');
  @override
  late final GeneratedColumn<String> packagingType = GeneratedColumn<String>(
      'packaging_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _packageCountMeta =
      const VerificationMeta('packageCount');
  @override
  late final GeneratedColumn<int> packageCount = GeneratedColumn<int>(
      'package_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _unitsPerPackageMeta =
      const VerificationMeta('unitsPerPackage');
  @override
  late final GeneratedColumn<int> unitsPerPackage = GeneratedColumn<int>(
      'units_per_package', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _expirationDateMeta =
      const VerificationMeta('expirationDate');
  @override
  late final GeneratedColumn<DateTime> expirationDate =
      GeneratedColumn<DateTime>('expiration_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        medicationId,
        availableQuantityScaled,
        quantityScale,
        unit,
        packagingType,
        packageCount,
        unitsPerPackage,
        purchaseDate,
        purchasePrice,
        expirationDate,
        source,
        isDepleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_batches';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryBatche> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
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
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('packaging_type')) {
      context.handle(
          _packagingTypeMeta,
          packagingType.isAcceptableOrUnknown(
              data['packaging_type']!, _packagingTypeMeta));
    }
    if (data.containsKey('package_count')) {
      context.handle(
          _packageCountMeta,
          packageCount.isAcceptableOrUnknown(
              data['package_count']!, _packageCountMeta));
    }
    if (data.containsKey('units_per_package')) {
      context.handle(
          _unitsPerPackageMeta,
          unitsPerPackage.isAcceptableOrUnknown(
              data['units_per_package']!, _unitsPerPackageMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
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
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('is_depleted')) {
      context.handle(
          _isDepletedMeta,
          isDepleted.isAcceptableOrUnknown(
              data['is_depleted']!, _isDepletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBatche(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      availableQuantityScaled: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}available_quantity_scaled'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      packagingType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}packaging_type']),
      packageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}package_count']),
      unitsPerPackage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}units_per_package']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price']),
      expirationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}expiration_date']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      isDepleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_depleted'])!,
    );
  }

  @override
  $InventoryBatchesTable createAlias(String alias) {
    return $InventoryBatchesTable(attachedDatabase, alias);
  }
}

class InventoryBatche extends DataClass implements Insertable<InventoryBatche> {
  final String id;
  final String medicationId;
  final int availableQuantityScaled;
  final int quantityScale;
  final String unit;
  final String? packagingType;
  final int? packageCount;
  final int? unitsPerPackage;
  final DateTime purchaseDate;
  final double? purchasePrice;
  final DateTime? expirationDate;
  final String? source;
  final bool isDepleted;
  const InventoryBatche(
      {required this.id,
      required this.medicationId,
      required this.availableQuantityScaled,
      required this.quantityScale,
      required this.unit,
      this.packagingType,
      this.packageCount,
      this.unitsPerPackage,
      required this.purchaseDate,
      this.purchasePrice,
      this.expirationDate,
      this.source,
      required this.isDepleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['available_quantity_scaled'] = Variable<int>(availableQuantityScaled);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || packagingType != null) {
      map['packaging_type'] = Variable<String>(packagingType);
    }
    if (!nullToAbsent || packageCount != null) {
      map['package_count'] = Variable<int>(packageCount);
    }
    if (!nullToAbsent || unitsPerPackage != null) {
      map['units_per_package'] = Variable<int>(unitsPerPackage);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || expirationDate != null) {
      map['expiration_date'] = Variable<DateTime>(expirationDate);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['is_depleted'] = Variable<bool>(isDepleted);
    return map;
  }

  InventoryBatchesCompanion toCompanion(bool nullToAbsent) {
    return InventoryBatchesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      availableQuantityScaled: Value(availableQuantityScaled),
      quantityScale: Value(quantityScale),
      unit: Value(unit),
      packagingType: packagingType == null && nullToAbsent
          ? const Value.absent()
          : Value(packagingType),
      packageCount: packageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(packageCount),
      unitsPerPackage: unitsPerPackage == null && nullToAbsent
          ? const Value.absent()
          : Value(unitsPerPackage),
      purchaseDate: Value(purchaseDate),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      expirationDate: expirationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expirationDate),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      isDepleted: Value(isDepleted),
    );
  }

  factory InventoryBatche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBatche(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      availableQuantityScaled:
          serializer.fromJson<int>(json['availableQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      unit: serializer.fromJson<String>(json['unit']),
      packagingType: serializer.fromJson<String?>(json['packagingType']),
      packageCount: serializer.fromJson<int?>(json['packageCount']),
      unitsPerPackage: serializer.fromJson<int?>(json['unitsPerPackage']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      expirationDate: serializer.fromJson<DateTime?>(json['expirationDate']),
      source: serializer.fromJson<String?>(json['source']),
      isDepleted: serializer.fromJson<bool>(json['isDepleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'availableQuantityScaled':
          serializer.toJson<int>(availableQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'unit': serializer.toJson<String>(unit),
      'packagingType': serializer.toJson<String?>(packagingType),
      'packageCount': serializer.toJson<int?>(packageCount),
      'unitsPerPackage': serializer.toJson<int?>(unitsPerPackage),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'expirationDate': serializer.toJson<DateTime?>(expirationDate),
      'source': serializer.toJson<String?>(source),
      'isDepleted': serializer.toJson<bool>(isDepleted),
    };
  }

  InventoryBatche copyWith(
          {String? id,
          String? medicationId,
          int? availableQuantityScaled,
          int? quantityScale,
          String? unit,
          Value<String?> packagingType = const Value.absent(),
          Value<int?> packageCount = const Value.absent(),
          Value<int?> unitsPerPackage = const Value.absent(),
          DateTime? purchaseDate,
          Value<double?> purchasePrice = const Value.absent(),
          Value<DateTime?> expirationDate = const Value.absent(),
          Value<String?> source = const Value.absent(),
          bool? isDepleted}) =>
      InventoryBatche(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        availableQuantityScaled:
            availableQuantityScaled ?? this.availableQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        unit: unit ?? this.unit,
        packagingType:
            packagingType.present ? packagingType.value : this.packagingType,
        packageCount:
            packageCount.present ? packageCount.value : this.packageCount,
        unitsPerPackage: unitsPerPackage.present
            ? unitsPerPackage.value
            : this.unitsPerPackage,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        purchasePrice:
            purchasePrice.present ? purchasePrice.value : this.purchasePrice,
        expirationDate:
            expirationDate.present ? expirationDate.value : this.expirationDate,
        source: source.present ? source.value : this.source,
        isDepleted: isDepleted ?? this.isDepleted,
      );
  InventoryBatche copyWithCompanion(InventoryBatchesCompanion data) {
    return InventoryBatche(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      availableQuantityScaled: data.availableQuantityScaled.present
          ? data.availableQuantityScaled.value
          : this.availableQuantityScaled,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      unit: data.unit.present ? data.unit.value : this.unit,
      packagingType: data.packagingType.present
          ? data.packagingType.value
          : this.packagingType,
      packageCount: data.packageCount.present
          ? data.packageCount.value
          : this.packageCount,
      unitsPerPackage: data.unitsPerPackage.present
          ? data.unitsPerPackage.value
          : this.unitsPerPackage,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      expirationDate: data.expirationDate.present
          ? data.expirationDate.value
          : this.expirationDate,
      source: data.source.present ? data.source.value : this.source,
      isDepleted:
          data.isDepleted.present ? data.isDepleted.value : this.isDepleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatche(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('availableQuantityScaled: $availableQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('packagingType: $packagingType, ')
          ..write('packageCount: $packageCount, ')
          ..write('unitsPerPackage: $unitsPerPackage, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('source: $source, ')
          ..write('isDepleted: $isDepleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      medicationId,
      availableQuantityScaled,
      quantityScale,
      unit,
      packagingType,
      packageCount,
      unitsPerPackage,
      purchaseDate,
      purchasePrice,
      expirationDate,
      source,
      isDepleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBatche &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.availableQuantityScaled == this.availableQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.unit == this.unit &&
          other.packagingType == this.packagingType &&
          other.packageCount == this.packageCount &&
          other.unitsPerPackage == this.unitsPerPackage &&
          other.purchaseDate == this.purchaseDate &&
          other.purchasePrice == this.purchasePrice &&
          other.expirationDate == this.expirationDate &&
          other.source == this.source &&
          other.isDepleted == this.isDepleted);
}

class InventoryBatchesCompanion extends UpdateCompanion<InventoryBatche> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<int> availableQuantityScaled;
  final Value<int> quantityScale;
  final Value<String> unit;
  final Value<String?> packagingType;
  final Value<int?> packageCount;
  final Value<int?> unitsPerPackage;
  final Value<DateTime> purchaseDate;
  final Value<double?> purchasePrice;
  final Value<DateTime?> expirationDate;
  final Value<String?> source;
  final Value<bool> isDepleted;
  final Value<int> rowid;
  const InventoryBatchesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.availableQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.unit = const Value.absent(),
    this.packagingType = const Value.absent(),
    this.packageCount = const Value.absent(),
    this.unitsPerPackage = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.source = const Value.absent(),
    this.isDepleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryBatchesCompanion.insert({
    required String id,
    required String medicationId,
    required int availableQuantityScaled,
    this.quantityScale = const Value.absent(),
    required String unit,
    this.packagingType = const Value.absent(),
    this.packageCount = const Value.absent(),
    this.unitsPerPackage = const Value.absent(),
    required DateTime purchaseDate,
    this.purchasePrice = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.source = const Value.absent(),
    this.isDepleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        availableQuantityScaled = Value(availableQuantityScaled),
        unit = Value(unit),
        purchaseDate = Value(purchaseDate);
  static Insertable<InventoryBatche> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<int>? availableQuantityScaled,
    Expression<int>? quantityScale,
    Expression<String>? unit,
    Expression<String>? packagingType,
    Expression<int>? packageCount,
    Expression<int>? unitsPerPackage,
    Expression<DateTime>? purchaseDate,
    Expression<double>? purchasePrice,
    Expression<DateTime>? expirationDate,
    Expression<String>? source,
    Expression<bool>? isDepleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (availableQuantityScaled != null)
        'available_quantity_scaled': availableQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (unit != null) 'unit': unit,
      if (packagingType != null) 'packaging_type': packagingType,
      if (packageCount != null) 'package_count': packageCount,
      if (unitsPerPackage != null) 'units_per_package': unitsPerPackage,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (expirationDate != null) 'expiration_date': expirationDate,
      if (source != null) 'source': source,
      if (isDepleted != null) 'is_depleted': isDepleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryBatchesCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<int>? availableQuantityScaled,
      Value<int>? quantityScale,
      Value<String>? unit,
      Value<String?>? packagingType,
      Value<int?>? packageCount,
      Value<int?>? unitsPerPackage,
      Value<DateTime>? purchaseDate,
      Value<double?>? purchasePrice,
      Value<DateTime?>? expirationDate,
      Value<String?>? source,
      Value<bool>? isDepleted,
      Value<int>? rowid}) {
    return InventoryBatchesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      availableQuantityScaled:
          availableQuantityScaled ?? this.availableQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      unit: unit ?? this.unit,
      packagingType: packagingType ?? this.packagingType,
      packageCount: packageCount ?? this.packageCount,
      unitsPerPackage: unitsPerPackage ?? this.unitsPerPackage,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      expirationDate: expirationDate ?? this.expirationDate,
      source: source ?? this.source,
      isDepleted: isDepleted ?? this.isDepleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (availableQuantityScaled.present) {
      map['available_quantity_scaled'] =
          Variable<int>(availableQuantityScaled.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (packagingType.present) {
      map['packaging_type'] = Variable<String>(packagingType.value);
    }
    if (packageCount.present) {
      map['package_count'] = Variable<int>(packageCount.value);
    }
    if (unitsPerPackage.present) {
      map['units_per_package'] = Variable<int>(unitsPerPackage.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (expirationDate.present) {
      map['expiration_date'] = Variable<DateTime>(expirationDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isDepleted.present) {
      map['is_depleted'] = Variable<bool>(isDepleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatchesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('availableQuantityScaled: $availableQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('packagingType: $packagingType, ')
          ..write('packageCount: $packageCount, ')
          ..write('unitsPerPackage: $unitsPerPackage, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('source: $source, ')
          ..write('isDepleted: $isDepleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseInstancesTable extends DoseInstances
    with TableInfo<$DoseInstancesTable, DoseInstancesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES medications (id)'));
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SCHEDULED'));
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lateMinutesMeta =
      const VerificationMeta('lateMinutes');
  @override
  late final GeneratedColumn<int> lateMinutes = GeneratedColumn<int>(
      'late_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        medicationId,
        scheduleId,
        scheduledAt,
        requiredQuantityScaled,
        quantityScale,
        actualQuantityScaled,
        status,
        takenAt,
        lateMinutes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_instances';
  @override
  VerificationContext validateIntegrity(Insertable<DoseInstancesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    }
    if (data.containsKey('late_minutes')) {
      context.handle(
          _lateMinutesMeta,
          lateMinutes.isAcceptableOrUnknown(
              data['late_minutes']!, _lateMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseInstancesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseInstancesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id']),
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
      lateMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}late_minutes']),
    );
  }

  @override
  $DoseInstancesTable createAlias(String alias) {
    return $DoseInstancesTable(attachedDatabase, alias);
  }
}

class DoseInstancesData extends DataClass
    implements Insertable<DoseInstancesData> {
  final String id;
  final String patientId;
  final String medicationId;
  final String? scheduleId;
  final DateTime scheduledAt;
  final int requiredQuantityScaled;
  final int quantityScale;
  final int? actualQuantityScaled;
  final String status;
  final DateTime? takenAt;
  final int? lateMinutes;
  const DoseInstancesData(
      {required this.id,
      required this.patientId,
      required this.medicationId,
      this.scheduleId,
      required this.scheduledAt,
      required this.requiredQuantityScaled,
      required this.quantityScale,
      this.actualQuantityScaled,
      required this.status,
      this.takenAt,
      this.lateMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<String>(scheduleId);
    }
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
    if (!nullToAbsent || lateMinutes != null) {
      map['late_minutes'] = Variable<int>(lateMinutes);
    }
    return map;
  }

  DoseInstancesCompanion toCompanion(bool nullToAbsent) {
    return DoseInstancesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicationId: Value(medicationId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
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
      lateMinutes: lateMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(lateMinutes),
    );
  }

  factory DoseInstancesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseInstancesData(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduleId: serializer.fromJson<String?>(json['scheduleId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      requiredQuantityScaled:
          serializer.fromJson<int>(json['requiredQuantityScaled']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      actualQuantityScaled:
          serializer.fromJson<int?>(json['actualQuantityScaled']),
      status: serializer.fromJson<String>(json['status']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      lateMinutes: serializer.fromJson<int?>(json['lateMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduleId': serializer.toJson<String?>(scheduleId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'requiredQuantityScaled': serializer.toJson<int>(requiredQuantityScaled),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'actualQuantityScaled': serializer.toJson<int?>(actualQuantityScaled),
      'status': serializer.toJson<String>(status),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'lateMinutes': serializer.toJson<int?>(lateMinutes),
    };
  }

  DoseInstancesData copyWith(
          {String? id,
          String? patientId,
          String? medicationId,
          Value<String?> scheduleId = const Value.absent(),
          DateTime? scheduledAt,
          int? requiredQuantityScaled,
          int? quantityScale,
          Value<int?> actualQuantityScaled = const Value.absent(),
          String? status,
          Value<DateTime?> takenAt = const Value.absent(),
          Value<int?> lateMinutes = const Value.absent()}) =>
      DoseInstancesData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        medicationId: medicationId ?? this.medicationId,
        scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        requiredQuantityScaled:
            requiredQuantityScaled ?? this.requiredQuantityScaled,
        quantityScale: quantityScale ?? this.quantityScale,
        actualQuantityScaled: actualQuantityScaled.present
            ? actualQuantityScaled.value
            : this.actualQuantityScaled,
        status: status ?? this.status,
        takenAt: takenAt.present ? takenAt.value : this.takenAt,
        lateMinutes: lateMinutes.present ? lateMinutes.value : this.lateMinutes,
      );
  DoseInstancesData copyWithCompanion(DoseInstancesCompanion data) {
    return DoseInstancesData(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
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
      lateMinutes:
          data.lateMinutes.present ? data.lateMinutes.value : this.lateMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseInstancesData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('requiredQuantityScaled: $requiredQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('actualQuantityScaled: $actualQuantityScaled, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('lateMinutes: $lateMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      medicationId,
      scheduleId,
      scheduledAt,
      requiredQuantityScaled,
      quantityScale,
      actualQuantityScaled,
      status,
      takenAt,
      lateMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseInstancesData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.medicationId == this.medicationId &&
          other.scheduleId == this.scheduleId &&
          other.scheduledAt == this.scheduledAt &&
          other.requiredQuantityScaled == this.requiredQuantityScaled &&
          other.quantityScale == this.quantityScale &&
          other.actualQuantityScaled == this.actualQuantityScaled &&
          other.status == this.status &&
          other.takenAt == this.takenAt &&
          other.lateMinutes == this.lateMinutes);
}

class DoseInstancesCompanion extends UpdateCompanion<DoseInstancesData> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> medicationId;
  final Value<String?> scheduleId;
  final Value<DateTime> scheduledAt;
  final Value<int> requiredQuantityScaled;
  final Value<int> quantityScale;
  final Value<int?> actualQuantityScaled;
  final Value<String> status;
  final Value<DateTime?> takenAt;
  final Value<int?> lateMinutes;
  final Value<int> rowid;
  const DoseInstancesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.requiredQuantityScaled = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.actualQuantityScaled = const Value.absent(),
    this.status = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseInstancesCompanion.insert({
    required String id,
    required String patientId,
    required String medicationId,
    this.scheduleId = const Value.absent(),
    required DateTime scheduledAt,
    required int requiredQuantityScaled,
    this.quantityScale = const Value.absent(),
    this.actualQuantityScaled = const Value.absent(),
    this.status = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        medicationId = Value(medicationId),
        scheduledAt = Value(scheduledAt),
        requiredQuantityScaled = Value(requiredQuantityScaled);
  static Insertable<DoseInstancesData> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? medicationId,
    Expression<String>? scheduleId,
    Expression<DateTime>? scheduledAt,
    Expression<int>? requiredQuantityScaled,
    Expression<int>? quantityScale,
    Expression<int>? actualQuantityScaled,
    Expression<String>? status,
    Expression<DateTime>? takenAt,
    Expression<int>? lateMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (requiredQuantityScaled != null)
        'required_quantity_scaled': requiredQuantityScaled,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (actualQuantityScaled != null)
        'actual_quantity_scaled': actualQuantityScaled,
      if (status != null) 'status': status,
      if (takenAt != null) 'taken_at': takenAt,
      if (lateMinutes != null) 'late_minutes': lateMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseInstancesCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? medicationId,
      Value<String?>? scheduleId,
      Value<DateTime>? scheduledAt,
      Value<int>? requiredQuantityScaled,
      Value<int>? quantityScale,
      Value<int?>? actualQuantityScaled,
      Value<String>? status,
      Value<DateTime?>? takenAt,
      Value<int?>? lateMinutes,
      Value<int>? rowid}) {
    return DoseInstancesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      requiredQuantityScaled:
          requiredQuantityScaled ?? this.requiredQuantityScaled,
      quantityScale: quantityScale ?? this.quantityScale,
      actualQuantityScaled: actualQuantityScaled ?? this.actualQuantityScaled,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (lateMinutes.present) {
      map['late_minutes'] = Variable<int>(lateMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseInstancesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('requiredQuantityScaled: $requiredQuantityScaled, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('actualQuantityScaled: $actualQuantityScaled, ')
          ..write('status: $status, ')
          ..write('takenAt: $takenAt, ')
          ..write('lateMinutes: $lateMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordsTable extends HealthRecords
    with TableInfo<$HealthRecordsTable, HealthRecordsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, type, title, notes, occurredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_records';
  @override
  VerificationContext validateIntegrity(Insertable<HealthRecordsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecordsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecordsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $HealthRecordsTable createAlias(String alias) {
    return $HealthRecordsTable(attachedDatabase, alias);
  }
}

class HealthRecordsData extends DataClass
    implements Insertable<HealthRecordsData> {
  final String id;
  final String patientId;
  final String type;
  final String title;
  final String? notes;
  final DateTime occurredAt;
  const HealthRecordsData(
      {required this.id,
      required this.patientId,
      required this.type,
      required this.title,
      this.notes,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  HealthRecordsCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      type: Value(type),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      occurredAt: Value(occurredAt),
    );
  }

  factory HealthRecordsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecordsData(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  HealthRecordsData copyWith(
          {String? id,
          String? patientId,
          String? type,
          String? title,
          Value<String?> notes = const Value.absent(),
          DateTime? occurredAt}) =>
      HealthRecordsData(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        type: type ?? this.type,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  HealthRecordsData copyWithCompanion(HealthRecordsCompanion data) {
    return HealthRecordsData(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsData(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, type, title, notes, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecordsData &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.type == this.type &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.occurredAt == this.occurredAt);
}

class HealthRecordsCompanion extends UpdateCompanion<HealthRecordsData> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const HealthRecordsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordsCompanion.insert({
    required String id,
    required String patientId,
    required String type,
    required String title,
    this.notes = const Value.absent(),
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        type = Value(type),
        title = Value(title),
        occurredAt = Value(occurredAt);
  static Insertable<HealthRecordsData> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? notes,
      Value<DateTime>? occurredAt,
      Value<int>? rowid}) {
    return HealthRecordsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('HealthRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('occurredAt: $occurredAt, ')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _doctorNameMeta =
      const VerificationMeta('doctorName');
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
      'doctor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _issueDateMeta =
      const VerificationMeta('issueDate');
  @override
  late final GeneratedColumn<DateTime> issueDate = GeneratedColumn<DateTime>(
      'issue_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, doctorName, issueDate, filePath, createdAt];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prescription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prescription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      doctorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctor_name']),
      issueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}issue_date']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PrescriptionsTable createAlias(String alias) {
    return $PrescriptionsTable(attachedDatabase, alias);
  }
}

class Prescription extends DataClass implements Insertable<Prescription> {
  final String id;
  final String patientId;
  final String? doctorName;
  final DateTime? issueDate;
  final String filePath;
  final DateTime createdAt;
  const Prescription(
      {required this.id,
      required this.patientId,
      this.doctorName,
      this.issueDate,
      required this.filePath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || doctorName != null) {
      map['doctor_name'] = Variable<String>(doctorName);
    }
    if (!nullToAbsent || issueDate != null) {
      map['issue_date'] = Variable<DateTime>(issueDate);
    }
    map['file_path'] = Variable<String>(filePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrescriptionsCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      doctorName: doctorName == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorName),
      issueDate: issueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(issueDate),
      filePath: Value(filePath),
      createdAt: Value(createdAt),
    );
  }

  factory Prescription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prescription(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      doctorName: serializer.fromJson<String?>(json['doctorName']),
      issueDate: serializer.fromJson<DateTime?>(json['issueDate']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'doctorName': serializer.toJson<String?>(doctorName),
      'issueDate': serializer.toJson<DateTime?>(issueDate),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Prescription copyWith(
          {String? id,
          String? patientId,
          Value<String?> doctorName = const Value.absent(),
          Value<DateTime?> issueDate = const Value.absent(),
          String? filePath,
          DateTime? createdAt}) =>
      Prescription(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        doctorName: doctorName.present ? doctorName.value : this.doctorName,
        issueDate: issueDate.present ? issueDate.value : this.issueDate,
        filePath: filePath ?? this.filePath,
        createdAt: createdAt ?? this.createdAt,
      );
  Prescription copyWithCompanion(PrescriptionsCompanion data) {
    return Prescription(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      doctorName:
          data.doctorName.present ? data.doctorName.value : this.doctorName,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prescription(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('issueDate: $issueDate, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, doctorName, issueDate, filePath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prescription &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.doctorName == this.doctorName &&
          other.issueDate == this.issueDate &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt);
}

class PrescriptionsCompanion extends UpdateCompanion<Prescription> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String?> doctorName;
  final Value<DateTime?> issueDate;
  final Value<String> filePath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PrescriptionsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrescriptionsCompanion.insert({
    required String id,
    required String patientId,
    this.doctorName = const Value.absent(),
    this.issueDate = const Value.absent(),
    required String filePath,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        filePath = Value(filePath),
        createdAt = Value(createdAt);
  static Insertable<Prescription> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? doctorName,
    Expression<DateTime>? issueDate,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (doctorName != null) 'doctor_name': doctorName,
      if (issueDate != null) 'issue_date': issueDate,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrescriptionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String?>? doctorName,
      Value<DateTime?>? issueDate,
      Value<String>? filePath,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PrescriptionsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      issueDate: issueDate ?? this.issueDate,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<DateTime>(issueDate.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('doctorName: $doctorName, ')
          ..write('issueDate: $issueDate, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationPreferencesTable extends NotificationPreferences
    with TableInfo<$NotificationPreferencesTable, NotificationPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
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
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, notificationType, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_preferences';
  @override
  VerificationContext validateIntegrity(
      Insertable<NotificationPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      notificationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_type'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $NotificationPreferencesTable createAlias(String alias) {
    return $NotificationPreferencesTable(attachedDatabase, alias);
  }
}

class NotificationPreference extends DataClass
    implements Insertable<NotificationPreference> {
  final String id;
  final String patientId;
  final String notificationType;
  final bool enabled;
  const NotificationPreference(
      {required this.id,
      required this.patientId,
      required this.notificationType,
      required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['notification_type'] = Variable<String>(notificationType);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  NotificationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return NotificationPreferencesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      notificationType: Value(notificationType),
      enabled: Value(enabled),
    );
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreference(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      notificationType: serializer.fromJson<String>(json['notificationType']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'notificationType': serializer.toJson<String>(notificationType),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  NotificationPreference copyWith(
          {String? id,
          String? patientId,
          String? notificationType,
          bool? enabled}) =>
      NotificationPreference(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        notificationType: notificationType ?? this.notificationType,
        enabled: enabled ?? this.enabled,
      );
  NotificationPreference copyWithCompanion(
      NotificationPreferencesCompanion data) {
    return NotificationPreference(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreference(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, notificationType, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreference &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.notificationType == this.notificationType &&
          other.enabled == this.enabled);
}

class NotificationPreferencesCompanion
    extends UpdateCompanion<NotificationPreference> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> notificationType;
  final Value<bool> enabled;
  final Value<int> rowid;
  const NotificationPreferencesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationPreferencesCompanion.insert({
    required String id,
    required String patientId,
    required String notificationType,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        notificationType = Value(notificationType);
  static Insertable<NotificationPreference> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? notificationType,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (notificationType != null) 'notification_type': notificationType,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationPreferencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? notificationType,
      Value<bool>? enabled,
      Value<int>? rowid}) {
    return NotificationPreferencesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled, ')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
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
  List<GeneratedColumn> get $columns =>
      [id, patientId, entityType, entityId, action, occurredAt, metadataJson];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id']),
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
  final String id;
  final String? patientId;
  final String entityType;
  final String entityId;
  final String action;
  final DateTime occurredAt;
  final String? metadataJson;
  const AuditEvent(
      {required this.id,
      this.patientId,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.occurredAt,
      this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
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
      id: Value(id),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
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
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String?>(json['patientId']),
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
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String?>(patientId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  AuditEvent copyWith(
          {String? id,
          Value<String?> patientId = const Value.absent(),
          String? entityType,
          String? entityId,
          String? action,
          DateTime? occurredAt,
          Value<String?> metadataJson = const Value.absent()}) =>
      AuditEvent(
        id: id ?? this.id,
        patientId: patientId.present ? patientId.value : this.patientId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        occurredAt: occurredAt ?? this.occurredAt,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
      );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
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
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, patientId, entityType, entityId, action, occurredAt, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.occurredAt == this.occurredAt &&
          other.metadataJson == this.metadataJson);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String?> patientId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<DateTime> occurredAt;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    this.patientId = const Value.absent(),
    required String entityType,
    required String entityId,
    required String action,
    required DateTime occurredAt,
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        occurredAt = Value(occurredAt);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<DateTime>? occurredAt,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? patientId,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? action,
      Value<DateTime>? occurredAt,
      Value<String?>? metadataJson,
      Value<int>? rowid}) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
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
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $InventoryBatchesTable inventoryBatches =
      $InventoryBatchesTable(this);
  late final $DoseInstancesTable doseInstances = $DoseInstancesTable(this);
  late final $HealthRecordsTable healthRecords = $HealthRecordsTable(this);
  late final $PrescriptionsTable prescriptions = $PrescriptionsTable(this);
  late final $NotificationPreferencesTable notificationPreferences =
      $NotificationPreferencesTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patients,
        medications,
        medicationSchedules,
        inventoryBatches,
        doseInstances,
        healthRecords,
        prescriptions,
        notificationPreferences,
        auditEvents
      ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String id,
  required String name,
  Value<String?> relation,
  Value<String> timezone,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isArchived,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> relation,
  Value<String> timezone,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<int> rowid,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, PatientsData> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationsTable, List<MedicationsData>>
      _medicationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.medications,
              aliasName: 'patients__id__medications__patient_id');

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DoseInstancesTable, List<DoseInstancesData>>
      _doseInstancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.doseInstances,
              aliasName: 'patients__id__dose_instances__patient_id');

  $$DoseInstancesTableProcessedTableManager get doseInstancesRefs {
    final manager = $$DoseInstancesTableTableManager($_db, $_db.doseInstances)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseInstancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HealthRecordsTable, List<HealthRecordsData>>
      _healthRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.healthRecords,
              aliasName: 'patients__id__health_records__patient_id');

  $$HealthRecordsTableProcessedTableManager get healthRecordsRefs {
    final manager = $$HealthRecordsTableTableManager($_db, $_db.healthRecords)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_healthRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PrescriptionsTable, List<Prescription>>
      _prescriptionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.prescriptions,
              aliasName: 'patients__id__prescriptions__patient_id');

  $$PrescriptionsTableProcessedTableManager get prescriptionsRefs {
    final manager = $$PrescriptionsTableTableManager($_db, $_db.prescriptions)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_prescriptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotificationPreferencesTable,
      List<NotificationPreference>> _notificationPreferencesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.notificationPreferences,
          aliasName: 'patients__id__notification_preferences__patient_id');

  $$NotificationPreferencesTableProcessedTableManager
      get notificationPreferencesRefs {
    final manager = $$NotificationPreferencesTableTableManager(
            $_db, $_db.notificationPreferences)
        .filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_notificationPreferencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  Expression<bool> medicationsRefs(
      Expression<bool> Function($$MedicationsTableFilterComposer f) f) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> doseInstancesRefs(
      Expression<bool> Function($$DoseInstancesTableFilterComposer f) f) {
    final $$DoseInstancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseInstances,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseInstancesTableFilterComposer(
              $db: $db,
              $table: $db.doseInstances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> healthRecordsRefs(
      Expression<bool> Function($$HealthRecordsTableFilterComposer f) f) {
    final $$HealthRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.healthRecords,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HealthRecordsTableFilterComposer(
              $db: $db,
              $table: $db.healthRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> prescriptionsRefs(
      Expression<bool> Function($$PrescriptionsTableFilterComposer f) f) {
    final $$PrescriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prescriptions,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrescriptionsTableFilterComposer(
              $db: $db,
              $table: $db.prescriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notificationPreferencesRefs(
      Expression<bool> Function($$NotificationPreferencesTableFilterComposer f)
          f) {
    final $$NotificationPreferencesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.notificationPreferences,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NotificationPreferencesTableFilterComposer(
                  $db: $db,
                  $table: $db.notificationPreferences,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezone => $composableBuilder(
      column: $table.timezone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  Expression<T> medicationsRefs<T extends Object>(
      Expression<T> Function($$MedicationsTableAnnotationComposer a) f) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> doseInstancesRefs<T extends Object>(
      Expression<T> Function($$DoseInstancesTableAnnotationComposer a) f) {
    final $$DoseInstancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseInstances,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseInstancesTableAnnotationComposer(
              $db: $db,
              $table: $db.doseInstances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> healthRecordsRefs<T extends Object>(
      Expression<T> Function($$HealthRecordsTableAnnotationComposer a) f) {
    final $$HealthRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.healthRecords,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HealthRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.healthRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> prescriptionsRefs<T extends Object>(
      Expression<T> Function($$PrescriptionsTableAnnotationComposer a) f) {
    final $$PrescriptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prescriptions,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrescriptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.prescriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notificationPreferencesRefs<T extends Object>(
      Expression<T> Function($$NotificationPreferencesTableAnnotationComposer a)
          f) {
    final $$NotificationPreferencesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.notificationPreferences,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NotificationPreferencesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.notificationPreferences,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    PatientsData,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (PatientsData, $$PatientsTableReferences),
    PatientsData,
    PrefetchHooks Function(
        {bool medicationsRefs,
        bool doseInstancesRefs,
        bool healthRecordsRefs,
        bool prescriptionsRefs,
        bool notificationPreferencesRefs})> {
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
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> relation = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            id: id,
            name: name,
            relation: relation,
            timezone: timezone,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> relation = const Value.absent(),
            Value<String> timezone = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            id: id,
            name: name,
            relation: relation,
            timezone: timezone,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PatientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {medicationsRefs = false,
              doseInstancesRefs = false,
              healthRecordsRefs = false,
              prescriptionsRefs = false,
              notificationPreferencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationsRefs) db.medications,
                if (doseInstancesRefs) db.doseInstances,
                if (healthRecordsRefs) db.healthRecords,
                if (prescriptionsRefs) db.prescriptions,
                if (notificationPreferencesRefs) db.notificationPreferences
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationsRefs)
                    await $_getPrefetchedData<PatientsData, $PatientsTable,
                            MedicationsData>(
                        currentTable: table,
                        referencedTable:
                            $$PatientsTableReferences._medicationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .medicationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (doseInstancesRefs)
                    await $_getPrefetchedData<PatientsData, $PatientsTable, DoseInstancesData>(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._doseInstancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .doseInstancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (healthRecordsRefs)
                    await $_getPrefetchedData<PatientsData, $PatientsTable, HealthRecordsData>(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._healthRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .healthRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (prescriptionsRefs)
                    await $_getPrefetchedData<PatientsData, $PatientsTable,
                            Prescription>(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._prescriptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .prescriptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (notificationPreferencesRefs)
                    await $_getPrefetchedData<PatientsData, $PatientsTable,
                            NotificationPreference>(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._notificationPreferencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .notificationPreferencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    PatientsData,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (PatientsData, $$PatientsTableReferences),
    PatientsData,
    PrefetchHooks Function(
        {bool medicationsRefs,
        bool doseInstancesRefs,
        bool healthRecordsRefs,
        bool prescriptionsRefs,
        bool notificationPreferencesRefs})>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  required String id,
  required String patientId,
  Value<String?> catalogId,
  required String nameEn,
  Value<String?> nameAr,
  Value<String?> strength,
  Value<String?> dosageForm,
  Value<String?> route,
  Value<String> doseUnit,
  Value<String?> instructionsEn,
  Value<String?> instructionsAr,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<bool> isPrn,
  Value<int?> maxDailyQuantityScaled,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String?> catalogId,
  Value<String> nameEn,
  Value<String?> nameAr,
  Value<String?> strength,
  Value<String?> dosageForm,
  Value<String?> route,
  Value<String> doseUnit,
  Value<String?> instructionsEn,
  Value<String?> instructionsAr,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<bool> isPrn,
  Value<int?> maxDailyQuantityScaled,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, MedicationsData> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('medications__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MedicationSchedulesTable,
      List<MedicationSchedule>> _medicationSchedulesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.medicationSchedules,
          aliasName: 'medications__id__medication_schedules__medication_id');

  $$MedicationSchedulesTableProcessedTableManager get medicationSchedulesRefs {
    final manager = $$MedicationSchedulesTableTableManager(
            $_db, $_db.medicationSchedules)
        .filter(
            (f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_medicationSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryBatchesTable, List<InventoryBatche>>
      _inventoryBatchesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryBatches,
              aliasName: 'medications__id__inventory_batches__medication_id');

  $$InventoryBatchesTableProcessedTableManager get inventoryBatchesRefs {
    final manager =
        $$InventoryBatchesTableTableManager($_db, $_db.inventoryBatches).filter(
            (f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_inventoryBatchesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DoseInstancesTable, List<DoseInstancesData>>
      _doseInstancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.doseInstances,
              aliasName: 'medications__id__dose_instances__medication_id');

  $$DoseInstancesTableProcessedTableManager get doseInstancesRefs {
    final manager = $$DoseInstancesTableTableManager($_db, $_db.doseInstances)
        .filter(
            (f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseInstancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get catalogId => $composableBuilder(
      column: $table.catalogId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxDailyQuantityScaled => $composableBuilder(
      column: $table.maxDailyQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> medicationSchedulesRefs(
      Expression<bool> Function($$MedicationSchedulesTableFilterComposer f) f) {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicationSchedules,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.medicationSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryBatchesRefs(
      Expression<bool> Function($$InventoryBatchesTableFilterComposer f) f) {
    final $$InventoryBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryBatches,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryBatchesTableFilterComposer(
              $db: $db,
              $table: $db.inventoryBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> doseInstancesRefs(
      Expression<bool> Function($$DoseInstancesTableFilterComposer f) f) {
    final $$DoseInstancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseInstances,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseInstancesTableFilterComposer(
              $db: $db,
              $table: $db.doseInstances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get catalogId => $composableBuilder(
      column: $table.catalogId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrn => $composableBuilder(
      column: $table.isPrn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxDailyQuantityScaled => $composableBuilder(
      column: $table.maxDailyQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

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

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isPrn =>
      $composableBuilder(column: $table.isPrn, builder: (column) => column);

  GeneratedColumn<int> get maxDailyQuantityScaled => $composableBuilder(
      column: $table.maxDailyQuantityScaled, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> medicationSchedulesRefs<T extends Object>(
      Expression<T> Function($$MedicationSchedulesTableAnnotationComposer a)
          f) {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.medicationSchedules,
            getReferencedColumn: (t) => t.medicationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MedicationSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.medicationSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> inventoryBatchesRefs<T extends Object>(
      Expression<T> Function($$InventoryBatchesTableAnnotationComposer a) f) {
    final $$InventoryBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryBatches,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> doseInstancesRefs<T extends Object>(
      Expression<T> Function($$DoseInstancesTableAnnotationComposer a) f) {
    final $$DoseInstancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.doseInstances,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DoseInstancesTableAnnotationComposer(
              $db: $db,
              $table: $db.doseInstances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    MedicationsData,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (MedicationsData, $$MedicationsTableReferences),
    MedicationsData,
    PrefetchHooks Function(
        {bool patientId,
        bool medicationSchedulesRefs,
        bool inventoryBatchesRefs,
        bool doseInstancesRefs})> {
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
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> catalogId = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> nameAr = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> dosageForm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            Value<String> doseUnit = const Value.absent(),
            Value<String?> instructionsEn = const Value.absent(),
            Value<String?> instructionsAr = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<int?> maxDailyQuantityScaled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            patientId: patientId,
            catalogId: catalogId,
            nameEn: nameEn,
            nameAr: nameAr,
            strength: strength,
            dosageForm: dosageForm,
            route: route,
            doseUnit: doseUnit,
            instructionsEn: instructionsEn,
            instructionsAr: instructionsAr,
            startDate: startDate,
            endDate: endDate,
            isPrn: isPrn,
            maxDailyQuantityScaled: maxDailyQuantityScaled,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<String?> catalogId = const Value.absent(),
            required String nameEn,
            Value<String?> nameAr = const Value.absent(),
            Value<String?> strength = const Value.absent(),
            Value<String?> dosageForm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            Value<String> doseUnit = const Value.absent(),
            Value<String?> instructionsEn = const Value.absent(),
            Value<String?> instructionsAr = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> isPrn = const Value.absent(),
            Value<int?> maxDailyQuantityScaled = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            patientId: patientId,
            catalogId: catalogId,
            nameEn: nameEn,
            nameAr: nameAr,
            strength: strength,
            dosageForm: dosageForm,
            route: route,
            doseUnit: doseUnit,
            instructionsEn: instructionsEn,
            instructionsAr: instructionsAr,
            startDate: startDate,
            endDate: endDate,
            isPrn: isPrn,
            maxDailyQuantityScaled: maxDailyQuantityScaled,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {patientId = false,
              medicationSchedulesRefs = false,
              inventoryBatchesRefs = false,
              doseInstancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationSchedulesRefs) db.medicationSchedules,
                if (inventoryBatchesRefs) db.inventoryBatches,
                if (doseInstancesRefs) db.doseInstances
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$MedicationsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$MedicationsTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationSchedulesRefs)
                    await $_getPrefetchedData<MedicationsData,
                            $MedicationsTable, MedicationSchedule>(
                        currentTable: table,
                        referencedTable: $$MedicationsTableReferences
                            ._medicationSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicationsTableReferences(db, table, p0)
                                .medicationSchedulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicationId == item.id),
                        typedResults: items),
                  if (inventoryBatchesRefs)
                    await $_getPrefetchedData<MedicationsData,
                            $MedicationsTable, InventoryBatche>(
                        currentTable: table,
                        referencedTable: $$MedicationsTableReferences
                            ._inventoryBatchesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicationsTableReferences(db, table, p0)
                                .inventoryBatchesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicationId == item.id),
                        typedResults: items),
                  if (doseInstancesRefs)
                    await $_getPrefetchedData<MedicationsData,
                            $MedicationsTable, DoseInstancesData>(
                        currentTable: table,
                        referencedTable: $$MedicationsTableReferences
                            ._doseInstancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicationsTableReferences(db, table, p0)
                                .doseInstancesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    MedicationsData,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (MedicationsData, $$MedicationsTableReferences),
    MedicationsData,
    PrefetchHooks Function(
        {bool patientId,
        bool medicationSchedulesRefs,
        bool inventoryBatchesRefs,
        bool doseInstancesRefs})>;
typedef $$MedicationSchedulesTableCreateCompanionBuilder
    = MedicationSchedulesCompanion Function({
  required String id,
  required String medicationId,
  required String scheduleType,
  Value<String?> fixedTime,
  required String recurrenceRule,
  required int doseQuantityScaled,
  Value<int> quantityScale,
  Value<DateTime?> validFrom,
  Value<DateTime?> validUntil,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$MedicationSchedulesTableUpdateCompanionBuilder
    = MedicationSchedulesCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<String> scheduleType,
  Value<String?> fixedTime,
  Value<String> recurrenceRule,
  Value<int> doseQuantityScaled,
  Value<int> quantityScale,
  Value<DateTime?> validFrom,
  Value<DateTime?> validUntil,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$MedicationSchedulesTableReferences extends BaseReferences<
    _$AppDatabase, $MedicationSchedulesTable, MedicationSchedule> {
  $$MedicationSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications
          .createAlias('medication_schedules__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MedicationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fixedTime => $composableBuilder(
      column: $table.fixedTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableOrderingComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get fixedTime =>
      $composableBuilder(column: $table.fixedTime, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  GeneratedColumn<int> get doseQuantityScaled => $composableBuilder(
      column: $table.doseQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (MedicationSchedule, $$MedicationSchedulesTableReferences),
    MedicationSchedule,
    PrefetchHooks Function({bool medicationId})> {
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
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String?> fixedTime = const Value.absent(),
            Value<String> recurrenceRule = const Value.absent(),
            Value<int> doseQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<DateTime?> validFrom = const Value.absent(),
            Value<DateTime?> validUntil = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationSchedulesCompanion(
            id: id,
            medicationId: medicationId,
            scheduleType: scheduleType,
            fixedTime: fixedTime,
            recurrenceRule: recurrenceRule,
            doseQuantityScaled: doseQuantityScaled,
            quantityScale: quantityScale,
            validFrom: validFrom,
            validUntil: validUntil,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required String scheduleType,
            Value<String?> fixedTime = const Value.absent(),
            required String recurrenceRule,
            required int doseQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            Value<DateTime?> validFrom = const Value.absent(),
            Value<DateTime?> validUntil = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationSchedulesCompanion.insert(
            id: id,
            medicationId: medicationId,
            scheduleType: scheduleType,
            fixedTime: fixedTime,
            recurrenceRule: recurrenceRule,
            doseQuantityScaled: doseQuantityScaled,
            quantityScale: quantityScale,
            validFrom: validFrom,
            validUntil: validUntil,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MedicationSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicationId,
                    referencedTable: $$MedicationSchedulesTableReferences
                        ._medicationIdTable(db),
                    referencedColumn: $$MedicationSchedulesTableReferences
                        ._medicationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (MedicationSchedule, $$MedicationSchedulesTableReferences),
    MedicationSchedule,
    PrefetchHooks Function({bool medicationId})>;
typedef $$InventoryBatchesTableCreateCompanionBuilder
    = InventoryBatchesCompanion Function({
  required String id,
  required String medicationId,
  required int availableQuantityScaled,
  Value<int> quantityScale,
  required String unit,
  Value<String?> packagingType,
  Value<int?> packageCount,
  Value<int?> unitsPerPackage,
  required DateTime purchaseDate,
  Value<double?> purchasePrice,
  Value<DateTime?> expirationDate,
  Value<String?> source,
  Value<bool> isDepleted,
  Value<int> rowid,
});
typedef $$InventoryBatchesTableUpdateCompanionBuilder
    = InventoryBatchesCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<int> availableQuantityScaled,
  Value<int> quantityScale,
  Value<String> unit,
  Value<String?> packagingType,
  Value<int?> packageCount,
  Value<int?> unitsPerPackage,
  Value<DateTime> purchaseDate,
  Value<double?> purchasePrice,
  Value<DateTime?> expirationDate,
  Value<String?> source,
  Value<bool> isDepleted,
  Value<int> rowid,
});

final class $$InventoryBatchesTableReferences extends BaseReferences<
    _$AppDatabase, $InventoryBatchesTable, InventoryBatche> {
  $$InventoryBatchesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications
          .createAlias('inventory_batches__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InventoryBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packagingType => $composableBuilder(
      column: $table.packagingType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get packageCount => $composableBuilder(
      column: $table.packageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => ColumnFilters(column));

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packagingType => $composableBuilder(
      column: $table.packagingType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get packageCount => $composableBuilder(
      column: $table.packageCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => ColumnOrderings(column));

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableOrderingComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryBatchesTable> {
  $$InventoryBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get availableQuantityScaled => $composableBuilder(
      column: $table.availableQuantityScaled, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get packagingType => $composableBuilder(
      column: $table.packagingType, builder: (column) => column);

  GeneratedColumn<int> get packageCount => $composableBuilder(
      column: $table.packageCount, builder: (column) => column);

  GeneratedColumn<int> get unitsPerPackage => $composableBuilder(
      column: $table.unitsPerPackage, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isDepleted => $composableBuilder(
      column: $table.isDepleted, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryBatchesTable,
    InventoryBatche,
    $$InventoryBatchesTableFilterComposer,
    $$InventoryBatchesTableOrderingComposer,
    $$InventoryBatchesTableAnnotationComposer,
    $$InventoryBatchesTableCreateCompanionBuilder,
    $$InventoryBatchesTableUpdateCompanionBuilder,
    (InventoryBatche, $$InventoryBatchesTableReferences),
    InventoryBatche,
    PrefetchHooks Function({bool medicationId})> {
  $$InventoryBatchesTableTableManager(
      _$AppDatabase db, $InventoryBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<int> availableQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> packagingType = const Value.absent(),
            Value<int?> packageCount = const Value.absent(),
            Value<int?> unitsPerPackage = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<double?> purchasePrice = const Value.absent(),
            Value<DateTime?> expirationDate = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<bool> isDepleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryBatchesCompanion(
            id: id,
            medicationId: medicationId,
            availableQuantityScaled: availableQuantityScaled,
            quantityScale: quantityScale,
            unit: unit,
            packagingType: packagingType,
            packageCount: packageCount,
            unitsPerPackage: unitsPerPackage,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            expirationDate: expirationDate,
            source: source,
            isDepleted: isDepleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required int availableQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            required String unit,
            Value<String?> packagingType = const Value.absent(),
            Value<int?> packageCount = const Value.absent(),
            Value<int?> unitsPerPackage = const Value.absent(),
            required DateTime purchaseDate,
            Value<double?> purchasePrice = const Value.absent(),
            Value<DateTime?> expirationDate = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<bool> isDepleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryBatchesCompanion.insert(
            id: id,
            medicationId: medicationId,
            availableQuantityScaled: availableQuantityScaled,
            quantityScale: quantityScale,
            unit: unit,
            packagingType: packagingType,
            packageCount: packageCount,
            unitsPerPackage: unitsPerPackage,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            expirationDate: expirationDate,
            source: source,
            isDepleted: isDepleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryBatchesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicationId,
                    referencedTable: $$InventoryBatchesTableReferences
                        ._medicationIdTable(db),
                    referencedColumn: $$InventoryBatchesTableReferences
                        ._medicationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InventoryBatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryBatchesTable,
    InventoryBatche,
    $$InventoryBatchesTableFilterComposer,
    $$InventoryBatchesTableOrderingComposer,
    $$InventoryBatchesTableAnnotationComposer,
    $$InventoryBatchesTableCreateCompanionBuilder,
    $$InventoryBatchesTableUpdateCompanionBuilder,
    (InventoryBatche, $$InventoryBatchesTableReferences),
    InventoryBatche,
    PrefetchHooks Function({bool medicationId})>;
typedef $$DoseInstancesTableCreateCompanionBuilder = DoseInstancesCompanion
    Function({
  required String id,
  required String patientId,
  required String medicationId,
  Value<String?> scheduleId,
  required DateTime scheduledAt,
  required int requiredQuantityScaled,
  Value<int> quantityScale,
  Value<int?> actualQuantityScaled,
  Value<String> status,
  Value<DateTime?> takenAt,
  Value<int?> lateMinutes,
  Value<int> rowid,
});
typedef $$DoseInstancesTableUpdateCompanionBuilder = DoseInstancesCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> medicationId,
  Value<String?> scheduleId,
  Value<DateTime> scheduledAt,
  Value<int> requiredQuantityScaled,
  Value<int> quantityScale,
  Value<int?> actualQuantityScaled,
  Value<String> status,
  Value<DateTime?> takenAt,
  Value<int?> lateMinutes,
  Value<int> rowid,
});

final class $$DoseInstancesTableReferences extends BaseReferences<_$AppDatabase,
    $DoseInstancesTable, DoseInstancesData> {
  $$DoseInstancesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('dose_instances__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications
          .createAlias('dose_instances__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DoseInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $DoseInstancesTable> {
  $$DoseInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnFilters(column));

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

  ColumnFilters<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableOrderingComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => column);

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

  GeneratedColumn<int> get lateMinutes => $composableBuilder(
      column: $table.lateMinutes, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DoseInstancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseInstancesTable,
    DoseInstancesData,
    $$DoseInstancesTableFilterComposer,
    $$DoseInstancesTableOrderingComposer,
    $$DoseInstancesTableAnnotationComposer,
    $$DoseInstancesTableCreateCompanionBuilder,
    $$DoseInstancesTableUpdateCompanionBuilder,
    (DoseInstancesData, $$DoseInstancesTableReferences),
    DoseInstancesData,
    PrefetchHooks Function({bool patientId, bool medicationId})> {
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
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<String?> scheduleId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<int> requiredQuantityScaled = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<int?> actualQuantityScaled = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> takenAt = const Value.absent(),
            Value<int?> lateMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInstancesCompanion(
            id: id,
            patientId: patientId,
            medicationId: medicationId,
            scheduleId: scheduleId,
            scheduledAt: scheduledAt,
            requiredQuantityScaled: requiredQuantityScaled,
            quantityScale: quantityScale,
            actualQuantityScaled: actualQuantityScaled,
            status: status,
            takenAt: takenAt,
            lateMinutes: lateMinutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String medicationId,
            Value<String?> scheduleId = const Value.absent(),
            required DateTime scheduledAt,
            required int requiredQuantityScaled,
            Value<int> quantityScale = const Value.absent(),
            Value<int?> actualQuantityScaled = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> takenAt = const Value.absent(),
            Value<int?> lateMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseInstancesCompanion.insert(
            id: id,
            patientId: patientId,
            medicationId: medicationId,
            scheduleId: scheduleId,
            scheduledAt: scheduledAt,
            requiredQuantityScaled: requiredQuantityScaled,
            quantityScale: quantityScale,
            actualQuantityScaled: actualQuantityScaled,
            status: status,
            takenAt: takenAt,
            lateMinutes: lateMinutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DoseInstancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false, medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$DoseInstancesTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$DoseInstancesTableReferences._patientIdTable(db).id,
                  ) as T;
                }
                if (medicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicationId,
                    referencedTable:
                        $$DoseInstancesTableReferences._medicationIdTable(db),
                    referencedColumn: $$DoseInstancesTableReferences
                        ._medicationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DoseInstancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoseInstancesTable,
    DoseInstancesData,
    $$DoseInstancesTableFilterComposer,
    $$DoseInstancesTableOrderingComposer,
    $$DoseInstancesTableAnnotationComposer,
    $$DoseInstancesTableCreateCompanionBuilder,
    $$DoseInstancesTableUpdateCompanionBuilder,
    (DoseInstancesData, $$DoseInstancesTableReferences),
    DoseInstancesData,
    PrefetchHooks Function({bool patientId, bool medicationId})>;
typedef $$HealthRecordsTableCreateCompanionBuilder = HealthRecordsCompanion
    Function({
  required String id,
  required String patientId,
  required String type,
  required String title,
  Value<String?> notes,
  required DateTime occurredAt,
  Value<int> rowid,
});
typedef $$HealthRecordsTableUpdateCompanionBuilder = HealthRecordsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> type,
  Value<String> title,
  Value<String?> notes,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});

final class $$HealthRecordsTableReferences extends BaseReferences<_$AppDatabase,
    $HealthRecordsTable, HealthRecordsData> {
  $$HealthRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('health_records__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HealthRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HealthRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HealthRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordsTable> {
  $$HealthRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HealthRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthRecordsTable,
    HealthRecordsData,
    $$HealthRecordsTableFilterComposer,
    $$HealthRecordsTableOrderingComposer,
    $$HealthRecordsTableAnnotationComposer,
    $$HealthRecordsTableCreateCompanionBuilder,
    $$HealthRecordsTableUpdateCompanionBuilder,
    (HealthRecordsData, $$HealthRecordsTableReferences),
    HealthRecordsData,
    PrefetchHooks Function({bool patientId})> {
  $$HealthRecordsTableTableManager(_$AppDatabase db, $HealthRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordsCompanion(
            id: id,
            patientId: patientId,
            type: type,
            title: title,
            notes: notes,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String type,
            required String title,
            Value<String?> notes = const Value.absent(),
            required DateTime occurredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthRecordsCompanion.insert(
            id: id,
            patientId: patientId,
            type: type,
            title: title,
            notes: notes,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HealthRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$HealthRecordsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$HealthRecordsTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HealthRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthRecordsTable,
    HealthRecordsData,
    $$HealthRecordsTableFilterComposer,
    $$HealthRecordsTableOrderingComposer,
    $$HealthRecordsTableAnnotationComposer,
    $$HealthRecordsTableCreateCompanionBuilder,
    $$HealthRecordsTableUpdateCompanionBuilder,
    (HealthRecordsData, $$HealthRecordsTableReferences),
    HealthRecordsData,
    PrefetchHooks Function({bool patientId})>;
typedef $$PrescriptionsTableCreateCompanionBuilder = PrescriptionsCompanion
    Function({
  required String id,
  required String patientId,
  Value<String?> doctorName,
  Value<DateTime?> issueDate,
  required String filePath,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PrescriptionsTableUpdateCompanionBuilder = PrescriptionsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String?> doctorName,
  Value<DateTime?> issueDate,
  Value<String> filePath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PrescriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $PrescriptionsTable, Prescription> {
  $$PrescriptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('prescriptions__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PrescriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get issueDate => $composableBuilder(
      column: $table.issueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get issueDate => $composableBuilder(
      column: $table.issueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
      column: $table.doctorName, builder: (column) => column);

  GeneratedColumn<DateTime> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
    (Prescription, $$PrescriptionsTableReferences),
    Prescription,
    PrefetchHooks Function({bool patientId})> {
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
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> doctorName = const Value.absent(),
            Value<DateTime?> issueDate = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionsCompanion(
            id: id,
            patientId: patientId,
            doctorName: doctorName,
            issueDate: issueDate,
            filePath: filePath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<String?> doctorName = const Value.absent(),
            Value<DateTime?> issueDate = const Value.absent(),
            required String filePath,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PrescriptionsCompanion.insert(
            id: id,
            patientId: patientId,
            doctorName: doctorName,
            issueDate: issueDate,
            filePath: filePath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PrescriptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$PrescriptionsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$PrescriptionsTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
    (Prescription, $$PrescriptionsTableReferences),
    Prescription,
    PrefetchHooks Function({bool patientId})>;
typedef $$NotificationPreferencesTableCreateCompanionBuilder
    = NotificationPreferencesCompanion Function({
  required String id,
  required String patientId,
  required String notificationType,
  Value<bool> enabled,
  Value<int> rowid,
});
typedef $$NotificationPreferencesTableUpdateCompanionBuilder
    = NotificationPreferencesCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> notificationType,
  Value<bool> enabled,
  Value<int> rowid,
});

final class $$NotificationPreferencesTableReferences extends BaseReferences<
    _$AppDatabase, $NotificationPreferencesTable, NotificationPreference> {
  $$NotificationPreferencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) => db.patients
      .createAlias('notification_preferences__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotificationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
      column: $table.notificationType, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationPreferencesTable,
    NotificationPreference,
    $$NotificationPreferencesTableFilterComposer,
    $$NotificationPreferencesTableOrderingComposer,
    $$NotificationPreferencesTableAnnotationComposer,
    $$NotificationPreferencesTableCreateCompanionBuilder,
    $$NotificationPreferencesTableUpdateCompanionBuilder,
    (NotificationPreference, $$NotificationPreferencesTableReferences),
    NotificationPreference,
    PrefetchHooks Function({bool patientId})> {
  $$NotificationPreferencesTableTableManager(
      _$AppDatabase db, $NotificationPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationPreferencesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationPreferencesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationPreferencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> notificationType = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationPreferencesCompanion(
            id: id,
            patientId: patientId,
            notificationType: notificationType,
            enabled: enabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String notificationType,
            Value<bool> enabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationPreferencesCompanion.insert(
            id: id,
            patientId: patientId,
            notificationType: notificationType,
            enabled: enabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NotificationPreferencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable: $$NotificationPreferencesTableReferences
                        ._patientIdTable(db),
                    referencedColumn: $$NotificationPreferencesTableReferences
                        ._patientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotificationPreferencesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $NotificationPreferencesTable,
        NotificationPreference,
        $$NotificationPreferencesTableFilterComposer,
        $$NotificationPreferencesTableOrderingComposer,
        $$NotificationPreferencesTableAnnotationComposer,
        $$NotificationPreferencesTableCreateCompanionBuilder,
        $$NotificationPreferencesTableUpdateCompanionBuilder,
        (NotificationPreference, $$NotificationPreferencesTableReferences),
        NotificationPreference,
        PrefetchHooks Function({bool patientId})>;
typedef $$AuditEventsTableCreateCompanionBuilder = AuditEventsCompanion
    Function({
  required String id,
  Value<String?> patientId,
  required String entityType,
  required String entityId,
  required String action,
  required DateTime occurredAt,
  Value<String?> metadataJson,
  Value<int> rowid,
});
typedef $$AuditEventsTableUpdateCompanionBuilder = AuditEventsCompanion
    Function({
  Value<String> id,
  Value<String?> patientId,
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
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

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
            Value<String> id = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion(
            id: id,
            patientId: patientId,
            entityType: entityType,
            entityId: entityId,
            action: action,
            occurredAt: occurredAt,
            metadataJson: metadataJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> patientId = const Value.absent(),
            required String entityType,
            required String entityId,
            required String action,
            required DateTime occurredAt,
            Value<String?> metadataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion.insert(
            id: id,
            patientId: patientId,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$InventoryBatchesTableTableManager get inventoryBatches =>
      $$InventoryBatchesTableTableManager(_db, _db.inventoryBatches);
  $$DoseInstancesTableTableManager get doseInstances =>
      $$DoseInstancesTableTableManager(_db, _db.doseInstances);
  $$HealthRecordsTableTableManager get healthRecords =>
      $$HealthRecordsTableTableManager(_db, _db.healthRecords);
  $$PrescriptionsTableTableManager get prescriptions =>
      $$PrescriptionsTableTableManager(_db, _db.prescriptions);
  $$NotificationPreferencesTableTableManager get notificationPreferences =>
      $$NotificationPreferencesTableTableManager(
          _db, _db.notificationPreferences);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
}

