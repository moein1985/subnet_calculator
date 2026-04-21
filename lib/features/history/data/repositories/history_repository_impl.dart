import 'dart:convert';

import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({required LocalStorageService localStorageService})
    : _localStorageService = localStorageService;

  static const _historyKey = 'subnet_history_items';
  static const _maxItems = 20;

  final LocalStorageService _localStorageService;

  @override
  Future<void> addItem(HistoryItem item) async {
    final current = await getItems();
    final updated = [item, ...current].take(_maxItems).toList();
    final encoded = jsonEncode(updated.map((entry) => entry.toJson()).toList());
    await _localStorageService.writeString(_historyKey, encoded);
  }

  @override
  Future<List<HistoryItem>> getItems() async {
    final jsonString = _localStorageService.readString(_historyKey);
    if (jsonString == null || jsonString.isEmpty) return const [];

    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(HistoryItem.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> removeItem(HistoryItem item) async {
    final current = await getItems();
    final updated = current.where((entry) => entry != item).toList();
    final encoded = jsonEncode(updated.map((entry) => entry.toJson()).toList());
    await _localStorageService.writeString(_historyKey, encoded);
  }

  @override
  Future<void> clearItems() async {
    await _localStorageService.remove(_historyKey);
  }
}
