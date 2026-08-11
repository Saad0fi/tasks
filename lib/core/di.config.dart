// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar_community/isar.dart' as _i214;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;
import 'package:tasks/core/client_mode/client_mode_service.dart' as _i112;
import 'package:tasks/core/isar_module.dart' as _i553;
import 'package:tasks/core/supabase_module.dart' as _i328;
import 'package:tasks/features/todo/data/data_source/todo_local_data_source.dart'
    as _i456;
import 'package:tasks/features/todo/data/data_source/todo_remote_data_source.dart'
    as _i944;
import 'package:tasks/features/todo/data/repositories/todo_loacl_repository.dart'
    as _i726;
import 'package:tasks/features/todo/data/repositories/todo_repository_data.dart'
    as _i508;
import 'package:tasks/features/todo/data/repositories/todo_repository_facade.dart'
    as _i471;
import 'package:tasks/features/todo/data/sync/todo_sync_service.dart' as _i733;
import 'package:tasks/features/todo/domain/repositories/task_repository_domain.dart'
    as _i779;
import 'package:tasks/features/todo/domain/use_cases/todos_use_case.dart'
    as _i781;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final isarModule = _$IsarModule();
    final supabaseModule = _$SupabaseModule();
    gh.lazySingleton<_i112.ClientModeService>(() => _i112.ClientModeService());
    await gh.lazySingletonAsync<_i214.Isar>(
      () => isarModule.isar,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i456.BaseTodoLocalDataSource>(
      () => _i456.TodoLocalDataSource(gh<_i214.Isar>()),
    );
    gh.lazySingleton<_i726.TodoLocalRepository>(
      () => _i726.TodoLocalRepository(
        gh<_i456.BaseTodoLocalDataSource>(),
        gh<_i733.TodoSyncService>(),
      ),
    );
    gh.lazySingleton<_i944.BaseTodoRemoteDataSource>(
      () => _i944.TodoRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i733.TodoSyncService>(
      () => _i733.TodoSyncService(
        gh<_i944.BaseTodoRemoteDataSource>(),
        gh<_i456.BaseTodoLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i508.TodoRepositoryData>(
      () => _i508.TodoRepositoryData(
        gh<_i944.BaseTodoRemoteDataSource>(),
        gh<_i733.TodoSyncService>(),
      ),
    );
    gh.lazySingleton<_i779.TaskRepositoryDomain>(
      () => _i471.TodoRepositoryFacade(
        gh<_i508.TodoRepositoryData>(),
        gh<_i726.TodoLocalRepository>(),
        gh<_i112.ClientModeService>(),
      ),
    );
    gh.lazySingleton<_i781.TodosUseCase>(
      () => _i781.TodosUseCase(gh<_i779.TaskRepositoryDomain>()),
    );
    return this;
  }
}

class _$IsarModule extends _i553.IsarModule {}

class _$SupabaseModule extends _i328.SupabaseModule {}
