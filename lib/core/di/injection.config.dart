// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:math_trainer_app/core/di/register_module.dart' as _i363;
import 'package:math_trainer_app/core/network/rest_client.dart' as _i495;
import 'package:math_trainer_app/core/router/app_router.dart' as _i590;
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart'
    as _i88;
import 'package:math_trainer_app/core/settings/hide_solved_repository_impl.dart'
    as _i757;
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart'
    as _i905;
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart' as _i616;
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i546;
import 'package:math_trainer_app/features/auth/data/datasources/firebase_auth_remote_data_source.dart'
    as _i1009;
import 'package:math_trainer_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i173;
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart'
    as _i856;
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart'
    as _i375;
import 'package:math_trainer_app/features/catalog/data/datasources/catalog_remote_data_source.dart'
    as _i878;
import 'package:math_trainer_app/features/catalog/data/datasources/firebase_catalog_remote_data_source.dart'
    as _i730;
import 'package:math_trainer_app/features/catalog/data/matching/topic_matcher_impl.dart'
    as _i278;
import 'package:math_trainer_app/features/catalog/data/repositories/catalog_repository_impl.dart'
    as _i343;
import 'package:math_trainer_app/features/catalog/domain/matching.dart' as _i82;
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart'
    as _i579;
import 'package:math_trainer_app/features/topics/data/datasources/firebase_progress_remote_data_source.dart'
    as _i851;
import 'package:math_trainer_app/features/topics/data/datasources/firebase_sections_remote_data_source.dart'
    as _i461;
import 'package:math_trainer_app/features/topics/data/datasources/firebase_tasks_remote_data_source.dart'
    as _i996;
import 'package:math_trainer_app/features/topics/data/datasources/firebase_topics_remote_data_source.dart'
    as _i319;
import 'package:math_trainer_app/features/topics/data/datasources/progress_remote_data_source.dart'
    as _i1066;
import 'package:math_trainer_app/features/topics/data/datasources/sections_remote_data_source.dart'
    as _i564;
import 'package:math_trainer_app/features/topics/data/datasources/tasks_remote_data_source.dart'
    as _i924;
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart'
    as _i879;
import 'package:math_trainer_app/features/topics/data/generation/task_generator_impl.dart'
    as _i1030;
import 'package:math_trainer_app/features/topics/data/repositories/progress_repository_impl.dart'
    as _i132;
import 'package:math_trainer_app/features/topics/data/repositories/sections_repository_impl.dart'
    as _i1022;
import 'package:math_trainer_app/features/topics/data/repositories/tasks_repository_impl.dart'
    as _i935;
import 'package:math_trainer_app/features/topics/data/repositories/topics_repository_impl.dart'
    as _i662;
import 'package:math_trainer_app/features/topics/domain/generation.dart'
    as _i184;
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart'
    as _i36;
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart'
    as _i817;
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart'
    as _i959;
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart'
    as _i936;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.preferences,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i88.HideSolvedRepository>(
      () => _i757.HideSolvedRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i82.TopicMatcher>(() => _i278.TopicMatcherImpl());
    gh.lazySingleton<_i495.RestClient>(
      () => registerModule.restClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i184.TaskGenerator>(() => _i1030.TaskGeneratorImpl());
    gh.lazySingleton<_i905.LocaleCubit>(
      () => _i905.LocaleCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i616.ThemeCubit>(
      () => _i616.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i878.CatalogRemoteDataSource>(
      () =>
          _i730.FirebaseCatalogRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i879.TopicsRemoteDataSource>(
      () => _i319.FirebaseTopicsRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i546.AuthRemoteDataSource>(
      () => _i1009.FirebaseAuthRemoteDataSource(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i564.SectionsRemoteDataSource>(
      () =>
          _i461.FirebaseSectionsRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i924.TasksRemoteDataSource>(
      () => _i996.FirebaseTasksRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i1066.ProgressRemoteDataSource>(
      () =>
          _i851.FirebaseProgressRemoteDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i36.ProgressRepository>(
      () => _i132.ProgressRepositoryImpl(gh<_i1066.ProgressRemoteDataSource>()),
    );
    gh.lazySingleton<_i856.AuthRepository>(
      () => _i173.AuthRepositoryImpl(gh<_i546.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i375.AuthSessionCubit>(
      () => _i375.AuthSessionCubit(gh<_i856.AuthRepository>()),
    );
    gh.lazySingleton<_i590.AppRouter>(
      () => _i590.AppRouter(gh<_i375.AuthSessionCubit>()),
    );
    gh.lazySingleton<_i817.SectionsRepository>(
      () => _i1022.SectionsRepositoryImpl(gh<_i564.SectionsRemoteDataSource>()),
    );
    gh.lazySingleton<_i579.CatalogRepository>(
      () => _i343.CatalogRepositoryImpl(gh<_i878.CatalogRemoteDataSource>()),
    );
    gh.lazySingleton<_i959.TasksRepository>(
      () => _i935.TasksRepositoryImpl(gh<_i924.TasksRemoteDataSource>()),
    );
    gh.lazySingleton<_i936.TopicsRepository>(
      () => _i662.TopicsRepositoryImpl(gh<_i879.TopicsRemoteDataSource>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i363.RegisterModule {}
