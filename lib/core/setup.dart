import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks/core/di.dart';
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart';

class Setup {
  final GetIt getIt = GetIt.instance;

  Future<void> init() async {
    await dotenv.load(fileName: '.env');

    final url = dotenv.env['SUPABASE_URL']?.trim();
    final anonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim();
    if (url == null || url.isEmpty) {
      throw StateError(
        'SUPABASE_URL is missing or empty. Copy .env.example to .env and set your Supabase values.',
      );
    }
    if (anonKey == null || anonKey.isEmpty) {
      throw StateError(
        'SUPABASE_ANON_KEY is missing or empty. Copy .env.example to .env and set your Supabase values.',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    await configureDependencies();
    final sync = getIt<TodoSyncService>();
    // One-time: wipe local DB, then refill from cloud. Remove clearLocal() after one run.
    await sync.clearLocal();
    await sync.pullRemoteIntoLocal();
  }
}
