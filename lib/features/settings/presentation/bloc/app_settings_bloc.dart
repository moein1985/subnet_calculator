import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_locale_usecase.dart';
import '../../domain/usecases/get_open_ipv6_tab_by_default_usecase.dart';
import '../../domain/usecases/set_locale_usecase.dart';
import '../../domain/usecases/set_open_ipv6_tab_by_default_usecase.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({
    required GetLocaleUseCase getLocaleUseCase,
    required SetLocaleUseCase setLocaleUseCase,
    required GetOpenIpv6TabByDefaultUseCase getOpenIpv6TabByDefaultUseCase,
    required SetOpenIpv6TabByDefaultUseCase setOpenIpv6TabByDefaultUseCase,
  }) : _getLocaleUseCase = getLocaleUseCase,
       _setLocaleUseCase = setLocaleUseCase,
       _getOpenIpv6TabByDefaultUseCase = getOpenIpv6TabByDefaultUseCase,
       _setOpenIpv6TabByDefaultUseCase = setOpenIpv6TabByDefaultUseCase,
       super(
         const AppSettingsState(
           locale: Locale('en'),
           openIpv6TabByDefault: false,
         ),
       ) {
    on<AppSettingsStarted>(_onStarted);
    on<LanguageChanged>(_onLanguageChanged);
    on<DefaultSubnetTabChanged>(_onDefaultSubnetTabChanged);
  }

  final GetLocaleUseCase _getLocaleUseCase;
  final SetLocaleUseCase _setLocaleUseCase;
  final GetOpenIpv6TabByDefaultUseCase _getOpenIpv6TabByDefaultUseCase;
  final SetOpenIpv6TabByDefaultUseCase _setOpenIpv6TabByDefaultUseCase;

  Future<void> _onStarted(
    AppSettingsStarted event,
    Emitter<AppSettingsState> emit,
  ) async {
    final locale = await _getLocaleUseCase();
    final openIpv6TabByDefault = await _getOpenIpv6TabByDefaultUseCase();
    emit(
      state.copyWith(
        locale: locale,
        openIpv6TabByDefault: openIpv6TabByDefault,
      ),
    );
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _setLocaleUseCase(event.locale);
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onDefaultSubnetTabChanged(
    DefaultSubnetTabChanged event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _setOpenIpv6TabByDefaultUseCase(event.openIpv6TabByDefault);
    emit(state.copyWith(openIpv6TabByDefault: event.openIpv6TabByDefault));
  }
}
