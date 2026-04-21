part of 'ipv6_bloc.dart';

sealed class Ipv6Event extends Equatable {
  const Ipv6Event();

  @override
  List<Object> get props => [];
}

final class Ipv6AnalyzeRequested extends Ipv6Event {
  const Ipv6AnalyzeRequested({required this.input});

  final String input;

  @override
  List<Object> get props => [input];
}
