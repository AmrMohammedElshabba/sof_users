// lib/injection_container.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sof_users/features/reputation_items/data/repository/imp_repository.dart';
import 'package:sof_users/features/sof_users/data/repository/imp_repository.dart';

import '../../features/reputation_items/domain/repository/repository.dart';
import '../../features/reputation_items/domain/usecases/get_reputation_item_usecase.dart';
import '../../features/sof_users/domain/repository/repository.dart';
import '../../features/sof_users/domain/usecases/get_users_usecase.dart';
import '../local_storage/shared_pref_service.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../utilities/app_bloc_observer.dart';

final getIt = GetIt.instance; // getIt = service locator

Future<void> init() async {
  Bloc.observer = AppBlocObserver();
  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  //! External
  getIt.registerLazySingleton(() => Connectivity());

  //! Api Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(networkInfo: getIt()));

  // Shared Preferences instance
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Services
  getIt.registerLazySingleton<SharedPrefsService>(() => SharedPrefsService());

  getIt.registerLazySingleton<GetSOFUsersRepo>(
    () => GetSOFUsersImpRepo(apiClient: getIt()),
  );
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getSOFUsersRepo: getIt()),
  );

  getIt.registerLazySingleton<GetReputationItemRepo>(
    () => GetReputationItemImpRepo(apiClient: getIt()),
  );
  getIt.registerLazySingleton<GetReputationItemUseCase>(
    () => GetReputationItemUseCase(getReputationItemRepo: getIt()),
  );
}
