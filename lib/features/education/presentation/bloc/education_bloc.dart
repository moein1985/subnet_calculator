import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/education_article.dart';
import '../../domain/usecases/get_education_articles_usecase.dart';

sealed class EducationEvent extends Equatable {
  const EducationEvent();

  @override
  List<Object> get props => [];
}

final class EducationLoaded extends EducationEvent {
  const EducationLoaded();
}

enum EducationStatus { initial, loading, success, failure }

class EducationState extends Equatable {
  const EducationState({
    this.status = EducationStatus.initial,
    this.articles = const [],
  });

  final EducationStatus status;
  final List<EducationArticle> articles;

  EducationState copyWith({
    EducationStatus? status,
    List<EducationArticle>? articles,
  }) {
    return EducationState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object> get props => [status, articles];
}

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  EducationBloc(this._getEducationArticlesUseCase)
    : super(const EducationState()) {
    on<EducationLoaded>(_onEducationLoaded);
  }

  final GetEducationArticlesUseCase _getEducationArticlesUseCase;

  Future<void> _onEducationLoaded(
    EducationLoaded event,
    Emitter<EducationState> emit,
  ) async {
    emit(state.copyWith(status: EducationStatus.loading));
    try {
      final items = await _getEducationArticlesUseCase();
      emit(state.copyWith(status: EducationStatus.success, articles: items));
    } catch (_) {
      emit(state.copyWith(status: EducationStatus.failure));
    }
  }
}
