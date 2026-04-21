import 'dart:ui';

import '../repositories/settings_repository.dart';

class SetLocaleUseCase {
  SetLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(Locale locale) {
    return _repository.saveLocale(locale);
  }
}
