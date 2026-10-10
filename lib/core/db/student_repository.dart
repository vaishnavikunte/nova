import 'database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentRepository {
  final AppDatabase _db;

  StudentRepository(this._db);

  /// Insert a new student profile
  Future<void> insertStudentProfile(StudentProfilesCompanion profile) async {
    await _db.into(_db.studentProfiles).insert(profile);
  }

  Future<List<StudentProfile>> getAllStudentProfiles() async {
    return await _db.select(_db.studentProfiles).get();
  }

  /// Fetch unlocked levels for a specific student
  /// Unlocked levels include those with status AVAILABLE, PROFICIENT, or MASTERED.
  Future<List<LevelRecord>> getUnlockedLevels(String studentId) async {
    return await (_db.select(_db.levelRecords)
          ..where((l) => l.studentId.equals(studentId))
          ..where(
            (l) => l.status.isIn(['AVAILABLE', 'PROFICIENT', 'MASTERED']),
          ))
        .get();
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StudentRepository(db);
});
