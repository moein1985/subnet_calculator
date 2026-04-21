import '../repositories/history_repository.dart';

class ClearHistoryUseCase {
  ClearHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  Future<void> call() {
    return _repository.clearItems();
  }
}
