part of 'ipv6_bloc.dart';

enum Ipv6Status { initial, loading, success, failure }

class Ipv6State extends Equatable {
  const Ipv6State({
    this.status = Ipv6Status.initial,
    this.result,
    this.errorCode,
  });

  final Ipv6Status status;
  final Ipv6Result? result;
  final String? errorCode;

  Ipv6State copyWith({
    Ipv6Status? status,
    Ipv6Result? result,
    String? errorCode,
  }) {
    return Ipv6State(
      status: status ?? this.status,
      result: result,
      errorCode: errorCode,
    );
  }

  @override
  List<Object?> get props => [status, result, errorCode];
}
