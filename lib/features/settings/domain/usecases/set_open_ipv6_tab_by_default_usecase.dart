import '../repositories/settings_repository.dart';

class SetOpenIpv6TabByDefaultUseCase {
  SetOpenIpv6TabByDefaultUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(bool value) {
    return _repository.saveOpenIpv6TabByDefault(value);
  }
}
