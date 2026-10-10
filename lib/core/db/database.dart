import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

class StudentProfiles extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  IntColumn get enrolledStandard => integer()();
  IntColumn get activeStandard => integer()();
  IntColumn get streakCount => integer().withDefault(const Constant(0))();
  IntColumn get seedsBalance => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class BktCompetencies extends Table {
  TextColumn get studentId => text()();
  TextColumn get loCode => text()();
  RealColumn get pMastery => real().withDefault(const Constant(0.10))();
  IntColumn get consecutiveFails => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {studentId, loCode};
}

class LevelRecords extends Table {
  TextColumn get studentId => text()();
  IntColumn get levelId => integer()();
  TextColumn get status => text()(); // LOCKED, AVAILABLE, PROFICIENT, MASTERED
  RealColumn get bestAccuracy => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {studentId, levelId};
}

@DriftDatabase(tables: [StudentProfiles, BktCompetencies, LevelRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Android workaround removed as it is not available in the current version of sqlite3_flutter_libs

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
