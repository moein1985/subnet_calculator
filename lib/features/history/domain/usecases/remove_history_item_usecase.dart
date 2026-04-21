import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class RemoveHistoryItemUseCase {
  RemoveHistoryItemUseCase(this._repository);

  final HistoryRepository _repository;

  Future<void> call(HistoryItem item) {
    return _repository.removeItem(item);
  }
}
