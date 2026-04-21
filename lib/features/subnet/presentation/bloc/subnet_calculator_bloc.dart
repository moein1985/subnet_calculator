import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/subnet_result.dart';
import '../../domain/usecases/calculate_subnet_usecase.dart';

part 'subnet_calculator_event.dart';
part 'subnet_calculator_state.dart';

class SubnetCalculatorBloc
    extends Bloc<SubnetCalculatorEvent, SubnetCalculatorState> {
  SubnetCalculatorBloc({required CalculateSubnetUseCase calculateSubnetUseCase})
    : _calculateSubnetUseCase = calculateSubnetUseCase,
      super(const SubnetCalculatorState()) {
    on<SubnetRequested>(_onSubnetRequested);
  }

  final CalculateSubnetUseCase _calculateSubnetUseCase;

  void _onSubnetRequested(
    SubnetRequested event,
    Emitter<SubnetCalculatorState> emit,
  ) {
    emit(state.copyWith(status: SubnetStatus.loading, errorCode: null));

    try {
      final result = _calculateSubnetUseCase(
        ipv4Address: event.ipv4Address,
        prefixOrMask: event.prefixOrMask,
      );

      emit(
        state.copyWith(
          status: SubnetStatus.success,
          result: result,
          errorCode: null,
        ),
      );
    } on FormatException catch (error) {
      emit(
        state.copyWith(
          status: SubnetStatus.failure,
          errorCode: error.message,
          result: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SubnetStatus.failure,
          errorCode: 'unknown_error',
          result: null,
        ),
      );
    }
  }
}
