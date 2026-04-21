import 'dart:ui';

import '../../../../core/storage/local_storage_service.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  static const _languageCodeKey = 'language_code';
  static const _openIpv6TabByDefaultKey = 'open_ipv6_tab_by_default';

  final LocalStorageService _localStorageService;

  @override
  Future<Locale> getLocale() async {
    final value = _localStorageService.readString(_languageCodeKey);
    switch (value) {
      case 'fa':
        return const Locale('fa');
      case 'en':
        return const Locale('en');
      default:
        return const Locale('en');
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _localStorageService.writeString(
      _languageCodeKey,
      locale.languageCode,
    );
  }

  @override
  Future<bool> getOpenIpv6TabByDefault() async {
    final value = _localStorageService.readString(_openIpv6TabByDefaultKey);
    return value == 'true';
  }

  @override
  Future<void> saveOpenIpv6TabByDefault(bool value) async {
    await _localStorageService.writeString(
      _openIpv6TabByDefaultKey,
      value ? 'true' : 'false',
    );
  }
}
