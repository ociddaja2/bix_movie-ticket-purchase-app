import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bixcinema/core/models/teater_model.dart';
import 'package:bixcinema/core/repo/teater_repo.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedTeaterProvider = StateProvider<String?>((ref) => null);

final selectedTeaterDetailProvider = FutureProvider<TeaterModel?>((ref) async {
  final teaterId = ref.watch(selectedTeaterProvider);
  if (teaterId == null) return null;
  return TeaterRepository().fetchTeaterById(teaterId);
});