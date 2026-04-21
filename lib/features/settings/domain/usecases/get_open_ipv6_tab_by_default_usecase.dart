import '../repositories/settings_repository.dart';

class GetOpenIpv6TabByDefaultUseCase {
  GetOpenIpv6TabByDefaultUseCase(this._repository);

  final SettingsRepository _repository;

  Future<bool> call() {
    return _repository.getOpenIpv6TabByDefault();
  }
}
