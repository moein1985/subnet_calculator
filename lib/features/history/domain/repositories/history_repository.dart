import '../entities/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getItems();
  Future<void> addItem(HistoryItem item);
  Future<void> removeItem(HistoryItem item);
  Future<void> clearItems();
}
