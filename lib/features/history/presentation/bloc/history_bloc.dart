import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/history_item.dart';
import '../../domain/usecases/add_history_item_usecase.dart';
import '../../domain/usecases/clear_history_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/remove_history_item_usecase.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

final class HistoryLoaded extends HistoryEvent {
  const HistoryLoaded();
}

final class HistoryItemAdded extends HistoryEvent {
  const HistoryItemAdded({required this.item});

  final HistoryItem item;

  @override
  List<Object?> get props => [item];
}

final class HistoryItemRemoved extends HistoryEvent {
  const HistoryItemRemoved({required this.item});

  final HistoryItem item;

  @override
  List<Object?> get props => [item];
}

final class HistoryCleared extends HistoryEvent {
  const HistoryCleared();
}

final class HistoryItemReuseRequested extends HistoryEvent {
  const HistoryItemReuseRequested({required this.item});

  final HistoryItem item;

  @override
  List<Object?> get props => [item];
}

enum HistoryStatus { initial, loading, success }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.items = const [],
    this.reuseItem,
    this.reuseToken = 0,
  });

  final HistoryStatus status;
  final List<HistoryItem> items;
  final HistoryItem? reuseItem;
  final int reuseToken;

  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryItem>? items,
    HistoryItem? reuseItem,
    bool clearReuseItem = false,
    int? reuseToken,
  }) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      reuseItem: clearReuseItem ? null : (reuseItem ?? this.reuseItem),
      reuseToken: reuseToken ?? this.reuseToken,
    );
  }

  @override
  List<Object?> get props => [status, items, reuseItem, reuseToken];
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required GetHistoryUseCase getHistoryUseCase,
    required AddHistoryItemUseCase addHistoryItemUseCase,
    required RemoveHistoryItemUseCase removeHistoryItemUseCase,
    required ClearHistoryUseCase clearHistoryUseCase,
  }) : _getHistoryUseCase = getHistoryUseCase,
       _addHistoryItemUseCase = addHistoryItemUseCase,
       _removeHistoryItemUseCase = removeHistoryItemUseCase,
       _clearHistoryUseCase = clearHistoryUseCase,
       super(const HistoryState()) {
    on<HistoryLoaded>(_onHistoryLoaded);
    on<HistoryItemAdded>(_onHistoryItemAdded);
    on<HistoryItemRemoved>(_onHistoryItemRemoved);
    on<HistoryCleared>(_onHistoryCleared);
    on<HistoryItemReuseRequested>(_onHistoryItemReuseRequested);
  }

  final GetHistoryUseCase _getHistoryUseCase;
  final AddHistoryItemUseCase _addHistoryItemUseCase;
  final RemoveHistoryItemUseCase _removeHistoryItemUseCase;
  final ClearHistoryUseCase _clearHistoryUseCase;

  Future<void> _onHistoryLoaded(
    HistoryLoaded event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    final items = await _getHistoryUseCase();
    emit(state.copyWith(status: HistoryStatus.success, items: items));
  }

  Future<void> _onHistoryItemAdded(
    HistoryItemAdded event,
    Emitter<HistoryState> emit,
  ) async {
    await _addHistoryItemUseCase(event.item);
    final items = await _getHistoryUseCase();
    emit(state.copyWith(status: HistoryStatus.success, items: items));
  }

  Future<void> _onHistoryItemRemoved(
    HistoryItemRemoved event,
    Emitter<HistoryState> emit,
  ) async {
    await _removeHistoryItemUseCase(event.item);
    final items = await _getHistoryUseCase();
    emit(state.copyWith(status: HistoryStatus.success, items: items));
  }

  Future<void> _onHistoryCleared(
    HistoryCleared event,
    Emitter<HistoryState> emit,
  ) async {
    await _clearHistoryUseCase();
    emit(
      state.copyWith(
        status: HistoryStatus.success,
        items: const [],
        clearReuseItem: true,
      ),
    );
  }

  void _onHistoryItemReuseRequested(
    HistoryItemReuseRequested event,
    Emitter<HistoryState> emit,
  ) {
    emit(
      state.copyWith(
        reuseItem: event.item,
        reuseToken: state.reuseToken + 1,
      ),
    );
  }
}
