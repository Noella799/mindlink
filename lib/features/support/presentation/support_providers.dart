import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/support/data/local_support_repository.dart';
import 'package:mindlink/features/support/domain/support_contact.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) => const LocalSupportRepository());

final supportContactsProvider = FutureProvider<List<SupportContact>>((ref) {
  return ref.watch(supportRepositoryProvider).getContacts();
});
