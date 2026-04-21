import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  GetHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  Future<List<HistoryItem>> call() {
    return _repository.getItems();
  }
}
