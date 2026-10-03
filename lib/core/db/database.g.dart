// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StudentProfilesTable extends StudentProfiles
    with TableInfo<$StudentProfilesTable, StudentProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrolledStandardMeta = const VerificationMeta(
    'enrolledStandard',
  );
  @override
  late final GeneratedColumn<int> enrolledStandard = GeneratedColumn<int>(
    'enrolled_standard',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeStandardMeta = const VerificationMeta(
    'activeStandard',
  );
  @override
  late final GeneratedColumn<int> activeStandard = GeneratedColumn<int>(
    'active_standard',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _streakCountMeta = const VerificationMeta(
    'streakCount',
  );
  @override
  late final GeneratedColumn<int> streakCount = GeneratedColumn<int>(
    'streak_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _seedsBalanceMeta = const VerificationMeta(
    'seedsBalance',
  );
  @override
  late final GeneratedColumn<int> seedsBalance = GeneratedColumn<int>(
    'seeds_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    enrolledStandard,
    activeStandard,
    streakCount,
    seedsBalance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enrolled_standard')) {
      context.handle(
        _enrolledStandardMeta,
        enrolledStandard.isAcceptableOrUnknown(
          data['enrolled_standard']!,
          _enrolledStandardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_enrolledStandardMeta);
    }
    if (data.containsKey('active_standard')) {
      context.handle(
        _activeStandardMeta,
        activeStandard.isAcceptableOrUnknown(
          data['active_standard']!,
          _activeStandardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeStandardMeta);
    }
    if (data.containsKey('streak_count')) {
      context.handle(
        _streakCountMeta,
        streakCount.isAcceptableOrUnknown(
          data['streak_count']!,
          _streakCountMeta,
        ),
      );
    }
    if (data.containsKey('seeds_balance')) {
      context.handle(
        _seedsBalanceMeta,
        seedsBalance.isAcceptableOrUnknown(
          data['seeds_balance']!,
          _seedsBalanceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      enrolledStandard: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enrolled_standard'],
      )!,
      activeStandard: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_standard'],
      )!,
      streakCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_count'],
      )!,
      seedsBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seeds_balance'],
      )!,
    );
  }

  @override
  $StudentProfilesTable createAlias(String alias) {
    return $StudentProfilesTable(attachedDatabase, alias);
  }
}

class StudentProfile extends DataClass implements Insertable<StudentProfile> {
  final String id;
  final String name;
  final int enrolledStandard;
  final int activeStandard;
  final int streakCount;
  final int seedsBalance;
  const StudentProfile({
    required this.id,
    required this.name,
    required this.enrolledStandard,
    required this.activeStandard,
    required this.streakCount,
    required this.seedsBalance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['enrolled_standard'] = Variable<int>(enrolledStandard);
    map['active_standard'] = Variable<int>(activeStandard);
    map['streak_count'] = Variable<int>(streakCount);
    map['seeds_balance'] = Variable<int>(seedsBalance);
    return map;
  }

  StudentProfilesCompanion toCompanion(bool nullToAbsent) {
    return StudentProfilesCompanion(
      id: Value(id),
      name: Value(name),
      enrolledStandard: Value(enrolledStandard),
      activeStandard: Value(activeStandard),
      streakCount: Value(streakCount),
      seedsBalance: Value(seedsBalance),
    );
  }

  factory StudentProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      enrolledStandard: serializer.fromJson<int>(json['enrolledStandard']),
      activeStandard: serializer.fromJson<int>(json['activeStandard']),
      streakCount: serializer.fromJson<int>(json['streakCount']),
      seedsBalance: serializer.fromJson<int>(json['seedsBalance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'enrolledStandard': serializer.toJson<int>(enrolledStandard),
      'activeStandard': serializer.toJson<int>(activeStandard),
      'streakCount': serializer.toJson<int>(streakCount),
      'seedsBalance': serializer.toJson<int>(seedsBalance),
    };
  }

  StudentProfile copyWith({
    String? id,
    String? name,
    int? enrolledStandard,
    int? activeStandard,
    int? streakCount,
    int? seedsBalance,
  }) => StudentProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    enrolledStandard: enrolledStandard ?? this.enrolledStandard,
    activeStandard: activeStandard ?? this.activeStandard,
    streakCount: streakCount ?? this.streakCount,
    seedsBalance: seedsBalance ?? this.seedsBalance,
  );
  StudentProfile copyWithCompanion(StudentProfilesCompanion data) {
    return StudentProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      enrolledStandard: data.enrolledStandard.present
          ? data.enrolledStandard.value
          : this.enrolledStandard,
      activeStandard: data.activeStandard.present
          ? data.activeStandard.value
          : this.activeStandard,
      streakCount: data.streakCount.present
          ? data.streakCount.value
          : this.streakCount,
      seedsBalance: data.seedsBalance.present
          ? data.seedsBalance.value
          : this.seedsBalance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enrolledStandard: $enrolledStandard, ')
          ..write('activeStandard: $activeStandard, ')
          ..write('streakCount: $streakCount, ')
          ..write('seedsBalance: $seedsBalance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    enrolledStandard,
    activeStandard,
    streakCount,
    seedsBalance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.enrolledStandard == this.enrolledStandard &&
          other.activeStandard == this.activeStandard &&
          other.streakCount == this.streakCount &&
          other.seedsBalance == this.seedsBalance);
}

class StudentProfilesCompanion extends UpdateCompanion<StudentProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> enrolledStandard;
  final Value<int> activeStandard;
  final Value<int> streakCount;
  final Value<int> seedsBalance;
  final Value<int> rowid;
  const StudentProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.enrolledStandard = const Value.absent(),
    this.activeStandard = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.seedsBalance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentProfilesCompanion.insert({
    required String id,
    required String name,
    required int enrolledStandard,
    required int activeStandard,
    this.streakCount = const Value.absent(),
    this.seedsBalance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       enrolledStandard = Value(enrolledStandard),
       activeStandard = Value(activeStandard);
  static Insertable<StudentProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? enrolledStandard,
    Expression<int>? activeStandard,
    Expression<int>? streakCount,
    Expression<int>? seedsBalance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (enrolledStandard != null) 'enrolled_standard': enrolledStandard,
      if (activeStandard != null) 'active_standard': activeStandard,
      if (streakCount != null) 'streak_count': streakCount,
      if (seedsBalance != null) 'seeds_balance': seedsBalance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? enrolledStandard,
    Value<int>? activeStandard,
    Value<int>? streakCount,
    Value<int>? seedsBalance,
    Value<int>? rowid,
  }) {
    return StudentProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      enrolledStandard: enrolledStandard ?? this.enrolledStandard,
      activeStandard: activeStandard ?? this.activeStandard,
      streakCount: streakCount ?? this.streakCount,
      seedsBalance: seedsBalance ?? this.seedsBalance,
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
    if (enrolledStandard.present) {
      map['enrolled_standard'] = Variable<int>(enrolledStandard.value);
    }
    if (activeStandard.present) {
      map['active_standard'] = Variable<int>(activeStandard.value);
    }
    if (streakCount.present) {
      map['streak_count'] = Variable<int>(streakCount.value);
    }
    if (seedsBalance.present) {
      map['seeds_balance'] = Variable<int>(seedsBalance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('enrolledStandard: $enrolledStandard, ')
          ..write('activeStandard: $activeStandard, ')
          ..write('streakCount: $streakCount, ')
          ..write('seedsBalance: $seedsBalance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BktCompetenciesTable extends BktCompetencies
    with TableInfo<$BktCompetenciesTable, BktCompetency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BktCompetenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loCodeMeta = const VerificationMeta('loCode');
  @override
  late final GeneratedColumn<String> loCode = GeneratedColumn<String>(
    'lo_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pMasteryMeta = const VerificationMeta(
    'pMastery',
  );
  @override
  late final GeneratedColumn<double> pMastery = GeneratedColumn<double>(
    'p_mastery',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.10),
  );
  static const VerificationMeta _consecutiveFailsMeta = const VerificationMeta(
    'consecutiveFails',
  );
  @override
  late final GeneratedColumn<int> consecutiveFails = GeneratedColumn<int>(
    'consecutive_fails',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    loCode,
    pMastery,
    consecutiveFails,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bkt_competencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<BktCompetency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lo_code')) {
      context.handle(
        _loCodeMeta,
        loCode.isAcceptableOrUnknown(data['lo_code']!, _loCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_loCodeMeta);
    }
    if (data.containsKey('p_mastery')) {
      context.handle(
        _pMasteryMeta,
        pMastery.isAcceptableOrUnknown(data['p_mastery']!, _pMasteryMeta),
      );
    }
    if (data.containsKey('consecutive_fails')) {
      context.handle(
        _consecutiveFailsMeta,
        consecutiveFails.isAcceptableOrUnknown(
          data['consecutive_fails']!,
          _consecutiveFailsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, loCode};
  @override
  BktCompetency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BktCompetency(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      loCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lo_code'],
      )!,
      pMastery: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}p_mastery'],
      )!,
      consecutiveFails: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_fails'],
      )!,
    );
  }

  @override
  $BktCompetenciesTable createAlias(String alias) {
    return $BktCompetenciesTable(attachedDatabase, alias);
  }
}

class BktCompetency extends DataClass implements Insertable<BktCompetency> {
  final String studentId;
  final String loCode;
  final double pMastery;
  final int consecutiveFails;
  const BktCompetency({
    required this.studentId,
    required this.loCode,
    required this.pMastery,
    required this.consecutiveFails,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['lo_code'] = Variable<String>(loCode);
    map['p_mastery'] = Variable<double>(pMastery);
    map['consecutive_fails'] = Variable<int>(consecutiveFails);
    return map;
  }

  BktCompetenciesCompanion toCompanion(bool nullToAbsent) {
    return BktCompetenciesCompanion(
      studentId: Value(studentId),
      loCode: Value(loCode),
      pMastery: Value(pMastery),
      consecutiveFails: Value(consecutiveFails),
    );
  }

  factory BktCompetency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BktCompetency(
      studentId: serializer.fromJson<String>(json['studentId']),
      loCode: serializer.fromJson<String>(json['loCode']),
      pMastery: serializer.fromJson<double>(json['pMastery']),
      consecutiveFails: serializer.fromJson<int>(json['consecutiveFails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'loCode': serializer.toJson<String>(loCode),
      'pMastery': serializer.toJson<double>(pMastery),
      'consecutiveFails': serializer.toJson<int>(consecutiveFails),
    };
  }

  BktCompetency copyWith({
    String? studentId,
    String? loCode,
    double? pMastery,
    int? consecutiveFails,
  }) => BktCompetency(
    studentId: studentId ?? this.studentId,
    loCode: loCode ?? this.loCode,
    pMastery: pMastery ?? this.pMastery,
    consecutiveFails: consecutiveFails ?? this.consecutiveFails,
  );
  BktCompetency copyWithCompanion(BktCompetenciesCompanion data) {
    return BktCompetency(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      loCode: data.loCode.present ? data.loCode.value : this.loCode,
      pMastery: data.pMastery.present ? data.pMastery.value : this.pMastery,
      consecutiveFails: data.consecutiveFails.present
          ? data.consecutiveFails.value
          : this.consecutiveFails,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BktCompetency(')
          ..write('studentId: $studentId, ')
          ..write('loCode: $loCode, ')
          ..write('pMastery: $pMastery, ')
          ..write('consecutiveFails: $consecutiveFails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(studentId, loCode, pMastery, consecutiveFails);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BktCompetency &&
          other.studentId == this.studentId &&
          other.loCode == this.loCode &&
          other.pMastery == this.pMastery &&
          other.consecutiveFails == this.consecutiveFails);
}

class BktCompetenciesCompanion extends UpdateCompanion<BktCompetency> {
  final Value<String> studentId;
  final Value<String> loCode;
  final Value<double> pMastery;
  final Value<int> consecutiveFails;
  final Value<int> rowid;
  const BktCompetenciesCompanion({
    this.studentId = const Value.absent(),
    this.loCode = const Value.absent(),
    this.pMastery = const Value.absent(),
    this.consecutiveFails = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BktCompetenciesCompanion.insert({
    required String studentId,
    required String loCode,
    this.pMastery = const Value.absent(),
    this.consecutiveFails = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       loCode = Value(loCode);
  static Insertable<BktCompetency> custom({
    Expression<String>? studentId,
    Expression<String>? loCode,
    Expression<double>? pMastery,
    Expression<int>? consecutiveFails,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (loCode != null) 'lo_code': loCode,
      if (pMastery != null) 'p_mastery': pMastery,
      if (consecutiveFails != null) 'consecutive_fails': consecutiveFails,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BktCompetenciesCompanion copyWith({
    Value<String>? studentId,
    Value<String>? loCode,
    Value<double>? pMastery,
    Value<int>? consecutiveFails,
    Value<int>? rowid,
  }) {
    return BktCompetenciesCompanion(
      studentId: studentId ?? this.studentId,
      loCode: loCode ?? this.loCode,
      pMastery: pMastery ?? this.pMastery,
      consecutiveFails: consecutiveFails ?? this.consecutiveFails,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (loCode.present) {
      map['lo_code'] = Variable<String>(loCode.value);
    }
    if (pMastery.present) {
      map['p_mastery'] = Variable<double>(pMastery.value);
    }
    if (consecutiveFails.present) {
      map['consecutive_fails'] = Variable<int>(consecutiveFails.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BktCompetenciesCompanion(')
          ..write('studentId: $studentId, ')
          ..write('loCode: $loCode, ')
          ..write('pMastery: $pMastery, ')
          ..write('consecutiveFails: $consecutiveFails, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelRecordsTable extends LevelRecords
    with TableInfo<$LevelRecordsTable, LevelRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestAccuracyMeta = const VerificationMeta(
    'bestAccuracy',
  );
  @override
  late final GeneratedColumn<double> bestAccuracy = GeneratedColumn<double>(
    'best_accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    studentId,
    levelId,
    status,
    bestAccuracy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('best_accuracy')) {
      context.handle(
        _bestAccuracyMeta,
        bestAccuracy.isAcceptableOrUnknown(
          data['best_accuracy']!,
          _bestAccuracyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, levelId};
  @override
  LevelRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelRecord(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bestAccuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}best_accuracy'],
      )!,
    );
  }

  @override
  $LevelRecordsTable createAlias(String alias) {
    return $LevelRecordsTable(attachedDatabase, alias);
  }
}

class LevelRecord extends DataClass implements Insertable<LevelRecord> {
  final String studentId;
  final int levelId;
  final String status;
  final double bestAccuracy;
  const LevelRecord({
    required this.studentId,
    required this.levelId,
    required this.status,
    required this.bestAccuracy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<String>(studentId);
    map['level_id'] = Variable<int>(levelId);
    map['status'] = Variable<String>(status);
    map['best_accuracy'] = Variable<double>(bestAccuracy);
    return map;
  }

  LevelRecordsCompanion toCompanion(bool nullToAbsent) {
    return LevelRecordsCompanion(
      studentId: Value(studentId),
      levelId: Value(levelId),
      status: Value(status),
      bestAccuracy: Value(bestAccuracy),
    );
  }

  factory LevelRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelRecord(
      studentId: serializer.fromJson<String>(json['studentId']),
      levelId: serializer.fromJson<int>(json['levelId']),
      status: serializer.fromJson<String>(json['status']),
      bestAccuracy: serializer.fromJson<double>(json['bestAccuracy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<String>(studentId),
      'levelId': serializer.toJson<int>(levelId),
      'status': serializer.toJson<String>(status),
      'bestAccuracy': serializer.toJson<double>(bestAccuracy),
    };
  }

  LevelRecord copyWith({
    String? studentId,
    int? levelId,
    String? status,
    double? bestAccuracy,
  }) => LevelRecord(
    studentId: studentId ?? this.studentId,
    levelId: levelId ?? this.levelId,
    status: status ?? this.status,
    bestAccuracy: bestAccuracy ?? this.bestAccuracy,
  );
  LevelRecord copyWithCompanion(LevelRecordsCompanion data) {
    return LevelRecord(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      status: data.status.present ? data.status.value : this.status,
      bestAccuracy: data.bestAccuracy.present
          ? data.bestAccuracy.value
          : this.bestAccuracy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelRecord(')
          ..write('studentId: $studentId, ')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('bestAccuracy: $bestAccuracy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(studentId, levelId, status, bestAccuracy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelRecord &&
          other.studentId == this.studentId &&
          other.levelId == this.levelId &&
          other.status == this.status &&
          other.bestAccuracy == this.bestAccuracy);
}

class LevelRecordsCompanion extends UpdateCompanion<LevelRecord> {
  final Value<String> studentId;
  final Value<int> levelId;
  final Value<String> status;
  final Value<double> bestAccuracy;
  final Value<int> rowid;
  const LevelRecordsCompanion({
    this.studentId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.status = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelRecordsCompanion.insert({
    required String studentId,
    required int levelId,
    required String status,
    this.bestAccuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       levelId = Value(levelId),
       status = Value(status);
  static Insertable<LevelRecord> custom({
    Expression<String>? studentId,
    Expression<int>? levelId,
    Expression<String>? status,
    Expression<double>? bestAccuracy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (levelId != null) 'level_id': levelId,
      if (status != null) 'status': status,
      if (bestAccuracy != null) 'best_accuracy': bestAccuracy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelRecordsCompanion copyWith({
    Value<String>? studentId,
    Value<int>? levelId,
    Value<String>? status,
    Value<double>? bestAccuracy,
    Value<int>? rowid,
  }) {
    return LevelRecordsCompanion(
      studentId: studentId ?? this.studentId,
      levelId: levelId ?? this.levelId,
      status: status ?? this.status,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bestAccuracy.present) {
      map['best_accuracy'] = Variable<double>(bestAccuracy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelRecordsCompanion(')
          ..write('studentId: $studentId, ')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentProfilesTable studentProfiles = $StudentProfilesTable(
    this,
  );
  late final $BktCompetenciesTable bktCompetencies = $BktCompetenciesTable(
    this,
  );
  late final $LevelRecordsTable levelRecords = $LevelRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studentProfiles,
    bktCompetencies,
    levelRecords,
  ];
}

typedef $$StudentProfilesTableCreateCompanionBuilder =
    StudentProfilesCompanion Function({
      required String id,
      required String name,
      required int enrolledStandard,
      required int activeStandard,
      Value<int> streakCount,
      Value<int> seedsBalance,
      Value<int> rowid,
    });
typedef $$StudentProfilesTableUpdateCompanionBuilder =
    StudentProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> enrolledStandard,
      Value<int> activeStandard,
      Value<int> streakCount,
      Value<int> seedsBalance,
      Value<int> rowid,
    });

class $$StudentProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enrolledStandard => $composableBuilder(
    column: $table.enrolledStandard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeStandard => $composableBuilder(
    column: $table.activeStandard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seedsBalance => $composableBuilder(
    column: $table.seedsBalance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enrolledStandard => $composableBuilder(
    column: $table.enrolledStandard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeStandard => $composableBuilder(
    column: $table.activeStandard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seedsBalance => $composableBuilder(
    column: $table.seedsBalance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableAnnotationComposer({
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

  GeneratedColumn<int> get enrolledStandard => $composableBuilder(
    column: $table.enrolledStandard,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeStandard => $composableBuilder(
    column: $table.activeStandard,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seedsBalance => $composableBuilder(
    column: $table.seedsBalance,
    builder: (column) => column,
  );
}

class $$StudentProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentProfilesTable,
          StudentProfile,
          $$StudentProfilesTableFilterComposer,
          $$StudentProfilesTableOrderingComposer,
          $$StudentProfilesTableAnnotationComposer,
          $$StudentProfilesTableCreateCompanionBuilder,
          $$StudentProfilesTableUpdateCompanionBuilder,
          (
            StudentProfile,
            BaseReferences<
              _$AppDatabase,
              $StudentProfilesTable,
              StudentProfile
            >,
          ),
          StudentProfile,
          PrefetchHooks Function()
        > {
  $$StudentProfilesTableTableManager(
    _$AppDatabase db,
    $StudentProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> enrolledStandard = const Value.absent(),
                Value<int> activeStandard = const Value.absent(),
                Value<int> streakCount = const Value.absent(),
                Value<int> seedsBalance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion(
                id: id,
                name: name,
                enrolledStandard: enrolledStandard,
                activeStandard: activeStandard,
                streakCount: streakCount,
                seedsBalance: seedsBalance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int enrolledStandard,
                required int activeStandard,
                Value<int> streakCount = const Value.absent(),
                Value<int> seedsBalance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion.insert(
                id: id,
                name: name,
                enrolledStandard: enrolledStandard,
                activeStandard: activeStandard,
                streakCount: streakCount,
                seedsBalance: seedsBalance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentProfilesTable, StudentProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StudentProfilesTable,
                    StudentProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentProfilesTable,
      StudentProfile,
      $$StudentProfilesTableFilterComposer,
      $$StudentProfilesTableOrderingComposer,
      $$StudentProfilesTableAnnotationComposer,
      $$StudentProfilesTableCreateCompanionBuilder,
      $$StudentProfilesTableUpdateCompanionBuilder,
      (
        StudentProfile,
        BaseReferences<_$AppDatabase, $StudentProfilesTable, StudentProfile>,
      ),
      StudentProfile,
      PrefetchHooks Function()
    >;
typedef $$BktCompetenciesTableCreateCompanionBuilder =
    BktCompetenciesCompanion Function({
      required String studentId,
      required String loCode,
      Value<double> pMastery,
      Value<int> consecutiveFails,
      Value<int> rowid,
    });
typedef $$BktCompetenciesTableUpdateCompanionBuilder =
    BktCompetenciesCompanion Function({
      Value<String> studentId,
      Value<String> loCode,
      Value<double> pMastery,
      Value<int> consecutiveFails,
      Value<int> rowid,
    });

class $$BktCompetenciesTableFilterComposer
    extends Composer<_$AppDatabase, $BktCompetenciesTable> {
  $$BktCompetenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loCode => $composableBuilder(
    column: $table.loCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pMastery => $composableBuilder(
    column: $table.pMastery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveFails => $composableBuilder(
    column: $table.consecutiveFails,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BktCompetenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $BktCompetenciesTable> {
  $$BktCompetenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loCode => $composableBuilder(
    column: $table.loCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pMastery => $composableBuilder(
    column: $table.pMastery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveFails => $composableBuilder(
    column: $table.consecutiveFails,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BktCompetenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BktCompetenciesTable> {
  $$BktCompetenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get loCode =>
      $composableBuilder(column: $table.loCode, builder: (column) => column);

  GeneratedColumn<double> get pMastery =>
      $composableBuilder(column: $table.pMastery, builder: (column) => column);

  GeneratedColumn<int> get consecutiveFails => $composableBuilder(
    column: $table.consecutiveFails,
    builder: (column) => column,
  );
}

class $$BktCompetenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BktCompetenciesTable,
          BktCompetency,
          $$BktCompetenciesTableFilterComposer,
          $$BktCompetenciesTableOrderingComposer,
          $$BktCompetenciesTableAnnotationComposer,
          $$BktCompetenciesTableCreateCompanionBuilder,
          $$BktCompetenciesTableUpdateCompanionBuilder,
          (
            BktCompetency,
            BaseReferences<_$AppDatabase, $BktCompetenciesTable, BktCompetency>,
          ),
          BktCompetency,
          PrefetchHooks Function()
        > {
  $$BktCompetenciesTableTableManager(
    _$AppDatabase db,
    $BktCompetenciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BktCompetenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BktCompetenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BktCompetenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<String> loCode = const Value.absent(),
                Value<double> pMastery = const Value.absent(),
                Value<int> consecutiveFails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BktCompetenciesCompanion(
                studentId: studentId,
                loCode: loCode,
                pMastery: pMastery,
                consecutiveFails: consecutiveFails,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required String loCode,
                Value<double> pMastery = const Value.absent(),
                Value<int> consecutiveFails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BktCompetenciesCompanion.insert(
                studentId: studentId,
                loCode: loCode,
                pMastery: pMastery,
                consecutiveFails: consecutiveFails,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BktCompetenciesTable, BktCompetency>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BktCompetenciesTable,
                    BktCompetency
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BktCompetenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BktCompetenciesTable,
      BktCompetency,
      $$BktCompetenciesTableFilterComposer,
      $$BktCompetenciesTableOrderingComposer,
      $$BktCompetenciesTableAnnotationComposer,
      $$BktCompetenciesTableCreateCompanionBuilder,
      $$BktCompetenciesTableUpdateCompanionBuilder,
      (
        BktCompetency,
        BaseReferences<_$AppDatabase, $BktCompetenciesTable, BktCompetency>,
      ),
      BktCompetency,
      PrefetchHooks Function()
    >;
typedef $$LevelRecordsTableCreateCompanionBuilder =
    LevelRecordsCompanion Function({
      required String studentId,
      required int levelId,
      required String status,
      Value<double> bestAccuracy,
      Value<int> rowid,
    });
typedef $$LevelRecordsTableUpdateCompanionBuilder =
    LevelRecordsCompanion Function({
      Value<String> studentId,
      Value<int> levelId,
      Value<String> status,
      Value<double> bestAccuracy,
      Value<int> rowid,
    });

class $$LevelRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $LevelRecordsTable> {
  $$LevelRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelRecordsTable> {
  $$LevelRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelRecordsTable> {
  $$LevelRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<int> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get bestAccuracy => $composableBuilder(
    column: $table.bestAccuracy,
    builder: (column) => column,
  );
}

class $$LevelRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelRecordsTable,
          LevelRecord,
          $$LevelRecordsTableFilterComposer,
          $$LevelRecordsTableOrderingComposer,
          $$LevelRecordsTableAnnotationComposer,
          $$LevelRecordsTableCreateCompanionBuilder,
          $$LevelRecordsTableUpdateCompanionBuilder,
          (
            LevelRecord,
            BaseReferences<_$AppDatabase, $LevelRecordsTable, LevelRecord>,
          ),
          LevelRecord,
          PrefetchHooks Function()
        > {
  $$LevelRecordsTableTableManager(_$AppDatabase db, $LevelRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> studentId = const Value.absent(),
                Value<int> levelId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> bestAccuracy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelRecordsCompanion(
                studentId: studentId,
                levelId: levelId,
                status: status,
                bestAccuracy: bestAccuracy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String studentId,
                required int levelId,
                required String status,
                Value<double> bestAccuracy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelRecordsCompanion.insert(
                studentId: studentId,
                levelId: levelId,
                status: status,
                bestAccuracy: bestAccuracy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelRecordsTable, LevelRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LevelRecordsTable,
                    LevelRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelRecordsTable,
      LevelRecord,
      $$LevelRecordsTableFilterComposer,
      $$LevelRecordsTableOrderingComposer,
      $$LevelRecordsTableAnnotationComposer,
      $$LevelRecordsTableCreateCompanionBuilder,
      $$LevelRecordsTableUpdateCompanionBuilder,
      (
        LevelRecord,
        BaseReferences<_$AppDatabase, $LevelRecordsTable, LevelRecord>,
      ),
      LevelRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentProfilesTableTableManager get studentProfiles =>
      $$StudentProfilesTableTableManager(_db, _db.studentProfiles);
  $$BktCompetenciesTableTableManager get bktCompetencies =>
      $$BktCompetenciesTableTableManager(_db, _db.bktCompetencies);
  $$LevelRecordsTableTableManager get levelRecords =>
      $$LevelRecordsTableTableManager(_db, _db.levelRecords);
}
