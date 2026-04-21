import 'dart:ui';

abstract class SettingsRepository {
  Future<Locale> getLocale();
  Future<void> saveLocale(Locale locale);
  Future<bool> getOpenIpv6TabByDefault();
  Future<void> saveOpenIpv6TabByDefault(bool value);
}
