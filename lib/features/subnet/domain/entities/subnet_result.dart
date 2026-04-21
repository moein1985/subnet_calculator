import 'package:equatable/equatable.dart';

class SubnetResult extends Equatable {
  const SubnetResult({
    required this.input,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.subnetMask,
    required this.wildcardMask,
    required this.firstHost,
    required this.lastHost,
    required this.usableHosts,
  });

  final String input;
  final String networkAddress;
  final String broadcastAddress;
  final String subnetMask;
  final String wildcardMask;
  final String firstHost;
  final String lastHost;
  final int usableHosts;

  @override
  List<Object> get props => [
    input,
    networkAddress,
    broadcastAddress,
    subnetMask,
    wildcardMask,
    firstHost,
    lastHost,
    usableHosts,
  ];
}
