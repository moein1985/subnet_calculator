import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/service_locator.dart';
import 'core/l10n/app_localizations.dart';
import 'features/education/presentation/bloc/education_bloc.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/ipv6/presentation/bloc/ipv6_bloc.dart';
import 'features/settings/presentation/bloc/app_settings_bloc.dart';
import 'features/subnet/presentation/bloc/subnet_calculator_bloc.dart';
import 'router/app_router.dart';

class SubnetCalculatorApp extends StatelessWidget {
  SubnetCalculatorApp({super.key});

  final AppRouter _appRouter = sl<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(
          create: (_) => sl<AppSettingsBloc>()..add(const AppSettingsStarted()),
        ),
        BlocProvider<SubnetCalculatorBloc>(
          create: (_) => sl<SubnetCalculatorBloc>(),
        ),
        BlocProvider<Ipv6Bloc>(create: (_) => sl<Ipv6Bloc>()),
        BlocProvider<HistoryBloc>(
          create: (_) => sl<HistoryBloc>()..add(const HistoryLoaded()),
        ),
        BlocProvider<EducationBloc>(
          create: (_) => sl<EducationBloc>()..add(const EducationLoaded()),
        ),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Subnet Calculator',
            locale: state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0F766E),
              ),
              useMaterial3: true,
            ),
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
