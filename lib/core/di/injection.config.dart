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
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart'
    as _i905;
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart' as _i616;
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i546;
import 'package:math_trainer_app/features/auth/data/datasources/firebase_auth_remote_data_source.dart'
    as _i1009;
import 'package:math_trainer_app/features/auth/data/datasources/offline_auth_remote_data_source.dart'
    as _i553;
import 'package:math_trainer_app/features/auth/data/firestore/firebase_firestore_gateway.dart'
    as _i450;
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart'
    as _i39;
import 'package:math_trainer_app/features/auth/data/firestore/offline_firestore_gateway.dart'
    as _i192;
import 'package:math_trainer_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i173;
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart'
    as _i856;
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart'
    as _i375;
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart'
    as _i1062;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _offline = 'offline';
const String _firebase = 'firebase';

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
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i590.AppRouter>(() => _i590.AppRouter());
    gh.lazySingleton<_i546.AuthRemoteDataSource>(
      () => _i553.OfflineAuthRemoteDataSource(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => registerModule.firebaseAuth,
      registerFor: {_firebase},
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerModule.firestore,
      registerFor: {_firebase},
    );
    gh.lazySingleton<_i495.RestClient>(
      () => registerModule.restClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i39.FirestoreGateway>(
      () => _i192.OfflineFirestoreGateway(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i905.LocaleCubit>(
      () => _i905.LocaleCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i616.ThemeCubit>(
      () => _i616.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i39.FirestoreGateway>(
      () => _i450.FirebaseFirestoreGateway(gh<_i974.FirebaseFirestore>()),
      registerFor: {_firebase},
    );
    gh.lazySingleton<_i546.AuthRemoteDataSource>(
      () => _i1009.FirebaseAuthRemoteDataSource(gh<_i59.FirebaseAuth>()),
      registerFor: {_firebase},
    );
    gh.lazySingleton<_i856.AuthRepository>(
      () => _i173.AuthRepositoryImpl(
        gh<_i546.AuthRemoteDataSource>(),
        gh<_i39.FirestoreGateway>(),
      ),
    );
    gh.lazySingleton<_i375.AuthSessionCubit>(
      () => _i375.AuthSessionCubit(gh<_i856.AuthRepository>()),
    );
    gh.factory<_i1062.SignInCubit>(
      () => _i1062.SignInCubit(gh<_i856.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i363.RegisterModule {}
