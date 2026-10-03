import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/student_repository.dart';

final bootLogicProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  final profiles = await repository.getAllStudentProfiles();
  return profiles.isNotEmpty;
});

final activeStudentProvider = FutureProvider((ref) async {
  final repository = ref.watch(studentRepositoryProvider);
  final profiles = await repository.getAllStudentProfiles();
  return profiles.first;
});

final studentLevelsProvider = FutureProvider((ref) async {
  final student = await ref.watch(activeStudentProvider.future);
  final repository = ref.watch(studentRepositoryProvider);
  return repository.getUnlockedLevels(student.id);
});
