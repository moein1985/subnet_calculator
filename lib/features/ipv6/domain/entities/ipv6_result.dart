import 'package:equatable/equatable.dart';

class Ipv6Result extends Equatable {
  const Ipv6Result({
    required this.input,
    required this.addressOnly,
    required this.prefixLength,
    required this.compressed,
    required this.expanded,
    required this.networkPrefix,
    required this.interfaceId,
    required this.firstAddress,
    required this.lastAddress,
    required this.totalAddresses,
    required this.isIpv4Mapped,
    required this.networkBitCount,
    required this.hostBitCount,
    required this.classification,
    required this.classificationDescription,
  });

  final String input;
  final String addressOnly;
  final int prefixLength;
  final String compressed;
  final String expanded;
  final String networkPrefix;
  final String interfaceId;
  final String firstAddress;
  final String lastAddress;
  final String totalAddresses;
  final bool isIpv4Mapped;
  final int networkBitCount;
  final int hostBitCount;
  final String classification;
  final String classificationDescription;

  @override
  List<Object> get props => [
    input,
    addressOnly,
    prefixLength,
    compressed,
    expanded,
    networkPrefix,
    interfaceId,
    firstAddress,
    lastAddress,
    totalAddresses,
    isIpv4Mapped,
    networkBitCount,
    hostBitCount,
    classification,
    classificationDescription,
  ];
}
