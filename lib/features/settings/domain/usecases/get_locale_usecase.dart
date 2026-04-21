import 'dart:ui';

import '../repositories/settings_repository.dart';

class GetLocaleUseCase {
  GetLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Locale> call() {
    return _repository.getLocale();
  }
}
