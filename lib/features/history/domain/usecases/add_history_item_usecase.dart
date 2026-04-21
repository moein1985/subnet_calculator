import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class AddHistoryItemUseCase {
  AddHistoryItemUseCase(this._repository);

  final HistoryRepository _repository;

  Future<void> call(HistoryItem item) {
    return _repository.addItem(item);
  }
}
