part of 'app_settings_bloc.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({
    required this.locale,
    required this.openIpv6TabByDefault,
  });

  final Locale locale;
  final bool openIpv6TabByDefault;

  AppSettingsState copyWith({Locale? locale, bool? openIpv6TabByDefault}) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      openIpv6TabByDefault:
          openIpv6TabByDefault ?? this.openIpv6TabByDefault,
    );
  }

  @override
  List<Object> get props => [locale, openIpv6TabByDefault];
}
