import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/education/data/repositories/education_repository_impl.dart';
import '../../features/education/domain/repositories/education_repository.dart';
import '../../features/education/domain/usecases/get_education_articles_usecase.dart';
import '../../features/education/presentation/bloc/education_bloc.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/add_history_item_usecase.dart';
import '../../features/history/domain/usecases/clear_history_usecase.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';
import '../../features/history/domain/usecases/remove_history_item_usecase.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/ipv6/data/repositories/ipv6_repository_impl.dart';
import '../../features/ipv6/domain/repositories/ipv6_repository.dart';
import '../../features/ipv6/domain/usecases/analyze_ipv6_usecase.dart';
import '../../features/ipv6/presentation/bloc/ipv6_bloc.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_locale_usecase.dart';
import '../../features/settings/domain/usecases/get_open_ipv6_tab_by_default_usecase.dart';
import '../../features/settings/domain/usecases/set_locale_usecase.dart';
import '../../features/settings/domain/usecases/set_open_ipv6_tab_by_default_usecase.dart';
import '../../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../../features/subnet/data/repositories/subnet_repository_impl.dart';
import '../../features/subnet/domain/repositories/subnet_repository.dart';
import '../../features/subnet/domain/usecases/calculate_subnet_usecase.dart';
import '../../features/subnet/presentation/bloc/subnet_calculator_bloc.dart';
import '../../router/app_router.dart';
import '../storage/local_storage_service.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<SharedPreferences>(() => preferences)
    ..registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localStorageService: sl()),
    )
    ..registerLazySingleton<SubnetRepository>(
      () => const SubnetRepositoryImpl(),
    )
    ..registerLazySingleton<EducationRepository>(
      () => const EducationRepositoryImpl(),
    )
    ..registerLazySingleton<Ipv6Repository>(() => const Ipv6RepositoryImpl())
    ..registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(localStorageService: sl()),
    )
    ..registerLazySingleton<GetLocaleUseCase>(() => GetLocaleUseCase(sl()))
    ..registerLazySingleton<GetOpenIpv6TabByDefaultUseCase>(
      () => GetOpenIpv6TabByDefaultUseCase(sl()),
    )
    ..registerLazySingleton<SetLocaleUseCase>(() => SetLocaleUseCase(sl()))
    ..registerLazySingleton<SetOpenIpv6TabByDefaultUseCase>(
      () => SetOpenIpv6TabByDefaultUseCase(sl()),
    )
    ..registerLazySingleton<CalculateSubnetUseCase>(
      () => CalculateSubnetUseCase(sl()),
    )
    ..registerLazySingleton<AnalyzeIpv6UseCase>(() => AnalyzeIpv6UseCase(sl()))
    ..registerLazySingleton<GetEducationArticlesUseCase>(
      () => GetEducationArticlesUseCase(sl()),
    )
    ..registerLazySingleton<GetHistoryUseCase>(() => GetHistoryUseCase(sl()))
    ..registerLazySingleton<AddHistoryItemUseCase>(
      () => AddHistoryItemUseCase(sl()),
    )
    ..registerLazySingleton<RemoveHistoryItemUseCase>(
      () => RemoveHistoryItemUseCase(sl()),
    )
    ..registerLazySingleton<ClearHistoryUseCase>(
      () => ClearHistoryUseCase(sl()),
    )
    ..registerFactory<AppSettingsBloc>(
      () => AppSettingsBloc(
        getLocaleUseCase: sl(),
        setLocaleUseCase: sl(),
        getOpenIpv6TabByDefaultUseCase: sl(),
        setOpenIpv6TabByDefaultUseCase: sl(),
      ),
    )
    ..registerFactory<SubnetCalculatorBloc>(
      () => SubnetCalculatorBloc(calculateSubnetUseCase: sl()),
    )
    ..registerFactory<Ipv6Bloc>(() => Ipv6Bloc(analyzeIpv6UseCase: sl()))
    ..registerFactory<EducationBloc>(() => EducationBloc(sl()))
    ..registerFactory<HistoryBloc>(
      () => HistoryBloc(
        getHistoryUseCase: sl(),
        addHistoryItemUseCase: sl(),
        removeHistoryItemUseCase: sl(),
        clearHistoryUseCase: sl(),
      ),
    )
    ..registerLazySingleton<AppRouter>(AppRouter.new);
}
