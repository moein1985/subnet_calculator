import '../../domain/entities/subnet_result.dart';
import '../../domain/repositories/subnet_repository.dart';

class SubnetRepositoryImpl implements SubnetRepository {
  const SubnetRepositoryImpl();

  @override
  SubnetResult calculate({
    required String ipv4Address,
    required String prefixOrMask,
  }) {
    final prefixLength = _parsePrefix(prefixOrMask.trim());
    if (prefixLength < 0 || prefixLength > 32) {
      throw const FormatException('invalid_prefix');
    }

    final octets = ipv4Address.split('.');
    if (octets.length != 4) {
      throw const FormatException('invalid_ip');
    }

    final values = octets.map(int.tryParse).toList();
    if (values.contains(null) ||
        values.whereType<int>().any((item) => item < 0 || item > 255)) {
      throw const FormatException('invalid_ip');
    }

    final ipInt = _toInt(values.cast<int>());
    final mask = prefixLength == 0
        ? 0
        : ((0xFFFFFFFF << (32 - prefixLength)) & 0xFFFFFFFF);

    final network = ipInt & mask;
    final broadcast = network | (~mask & 0xFFFFFFFF);

    final firstHost = prefixLength >= 31 ? network : network + 1;
    final lastHost = prefixLength >= 31 ? broadcast : broadcast - 1;
    final usableHosts = switch (prefixLength) {
      32 => 1,
      31 => 2,
      _ => broadcast - network - 1,
    };

    return SubnetResult(
      input: '$ipv4Address/$prefixLength',
      networkAddress: _toDotted(network),
      broadcastAddress: _toDotted(broadcast),
      subnetMask: _toDotted(mask),
      wildcardMask: _toDotted(~mask & 0xFFFFFFFF),
      firstHost: _toDotted(firstHost),
      lastHost: _toDotted(lastHost),
      usableHosts: usableHosts,
    );
  }

  int _parsePrefix(String value) {
    if (value.isEmpty) {
      throw const FormatException('invalid_prefix');
    }

    final normalized = value.startsWith('/') ? value.substring(1) : value;
    final numericPrefix = int.tryParse(normalized);
    if (numericPrefix != null) {
      return numericPrefix;
    }

    final octets = normalized.split('.');
    if (octets.length != 4) {
      throw const FormatException('invalid_prefix');
    }

    final maskValues = octets.map(int.tryParse).toList();
    if (maskValues.contains(null) ||
        maskValues.whereType<int>().any((item) => item < 0 || item > 255)) {
      throw const FormatException('invalid_prefix');
    }

    final maskInt = _toInt(maskValues.cast<int>());
    final inverted = (~maskInt) & 0xFFFFFFFF;
    if ((inverted & (inverted + 1)) != 0) {
      throw const FormatException('invalid_prefix');
    }

    var count = 0;
    var cursor = maskInt;
    while ((cursor & 0x80000000) != 0) {
      count++;
      cursor = (cursor << 1) & 0xFFFFFFFF;
    }
    return count;
  }

  int _toInt(List<int> octets) {
    return (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
  }

  String _toDotted(int value) {
    return [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ].join('.');
  }
}
