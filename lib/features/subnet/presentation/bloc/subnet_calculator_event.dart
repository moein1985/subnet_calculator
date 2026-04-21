part of 'subnet_calculator_bloc.dart';

sealed class SubnetCalculatorEvent extends Equatable {
  const SubnetCalculatorEvent();

  @override
  List<Object> get props => [];
}

final class SubnetRequested extends SubnetCalculatorEvent {
  const SubnetRequested({
    required this.ipv4Address,
    required this.prefixOrMask,
  });

  final String ipv4Address;
  final String prefixOrMask;

  @override
  List<Object> get props => [ipv4Address, prefixOrMask];
}
