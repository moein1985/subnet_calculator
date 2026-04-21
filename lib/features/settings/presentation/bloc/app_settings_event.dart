part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

final class AppSettingsStarted extends AppSettingsEvent {
  const AppSettingsStarted();
}

final class LanguageChanged extends AppSettingsEvent {
  const LanguageChanged(this.locale);

  final Locale locale;

  @override
  List<Object> get props => [locale];
}

final class DefaultSubnetTabChanged extends AppSettingsEvent {
  const DefaultSubnetTabChanged({required this.openIpv6TabByDefault});

  final bool openIpv6TabByDefault;

  @override
  List<Object> get props => [openIpv6TabByDefault];
}
