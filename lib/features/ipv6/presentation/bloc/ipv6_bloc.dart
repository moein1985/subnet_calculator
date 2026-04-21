import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ipv6_result.dart';
import '../../domain/usecases/analyze_ipv6_usecase.dart';

part 'ipv6_event.dart';
part 'ipv6_state.dart';

class Ipv6Bloc extends Bloc<Ipv6Event, Ipv6State> {
  Ipv6Bloc({required AnalyzeIpv6UseCase analyzeIpv6UseCase})
    : _analyzeIpv6UseCase = analyzeIpv6UseCase,
      super(const Ipv6State()) {
    on<Ipv6AnalyzeRequested>(_onAnalyzeRequested);
  }

  final AnalyzeIpv6UseCase _analyzeIpv6UseCase;

  void _onAnalyzeRequested(
    Ipv6AnalyzeRequested event,
    Emitter<Ipv6State> emit,
  ) {
    emit(state.copyWith(status: Ipv6Status.loading, errorCode: null));

    try {
      final result = _analyzeIpv6UseCase(event.input);
      emit(
        state.copyWith(
          status: Ipv6Status.success,
          result: result,
          errorCode: null,
        ),
      );
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: Ipv6Status.failure,
          result: null,
          errorCode: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: Ipv6Status.failure,
          result: null,
          errorCode: 'unknown_error',
        ),
      );
    }
  }
}
