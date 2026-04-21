part of 'subnet_calculator_bloc.dart';

enum SubnetStatus { initial, loading, success, failure }

class SubnetCalculatorState extends Equatable {
  const SubnetCalculatorState({
    this.status = SubnetStatus.initial,
    this.result,
    this.errorCode,
  });

  final SubnetStatus status;
  final SubnetResult? result;
  final String? errorCode;

  SubnetCalculatorState copyWith({
    SubnetStatus? status,
    SubnetResult? result,
    String? errorCode,
  }) {
    return SubnetCalculatorState(
      status: status ?? this.status,
      result: result,
      errorCode: errorCode,
    );
  }

  @override
  List<Object?> get props => [status, result, errorCode];
}
