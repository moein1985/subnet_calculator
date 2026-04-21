import '../../domain/entities/ipv6_result.dart';
import '../../domain/repositories/ipv6_repository.dart';

class Ipv6RepositoryImpl implements Ipv6Repository {
  const Ipv6RepositoryImpl();

  static final BigInt _ipv4MappedPrefix = BigInt.from(0xFFFF);
  static final BigInt _sixToFourPrefix = BigInt.from(0x2002);
  static final BigInt _teredoPrefix = BigInt.from(0x20010000);

  @override
  Ipv6Result analyze(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('invalid_ipv6');
    }

    final slashIndex = trimmed.indexOf('/');
    final address = slashIndex >= 0
        ? trimmed.substring(0, slashIndex)
        : trimmed;
    final prefixPart = slashIndex >= 0
        ? trimmed.substring(slashIndex + 1)
        : '64';
    final prefixLength = int.tryParse(prefixPart);
    if (prefixLength == null || prefixLength < 0 || prefixLength > 128) {
      throw const FormatException('invalid_ipv6_prefix');
    }

    final hextets = _parseAddress(address);
    final expanded = _toExpanded(hextets);
    final compressed = _toCompressed(hextets);

    final value = _hextetsToBigInt(hextets);
    final networkValue = _networkPrefix(value, prefixLength);
    final hostMask = _hostMask(prefixLength);
    final lastAddressValue = networkValue | hostMask;
    final totalAddresses = BigInt.one << (128 - prefixLength);
    final networkHextets = _bigIntToHextets(networkValue);
    final interfaceIdValue = value ^ networkValue;
    final firstAddress = _toCompressed(networkHextets);
    final lastAddress = _toCompressed(_bigIntToHextets(lastAddressValue));
    final interfaceId = _toCompressed(_bigIntToHextets(interfaceIdValue));
    final networkPrefix = '${_toCompressed(networkHextets)}/$prefixLength';

    final classification = _classify(value);

    return Ipv6Result(
      input: '$address/$prefixLength',
      addressOnly: address,
      prefixLength: prefixLength,
      compressed: compressed,
      expanded: expanded,
      networkPrefix: networkPrefix,
      interfaceId: interfaceId,
      firstAddress: firstAddress,
      lastAddress: lastAddress,
      totalAddresses: totalAddresses.toString(),
      isIpv4Mapped: _isIpv4Mapped(value),
      networkBitCount: prefixLength,
      hostBitCount: 128 - prefixLength,
      classification: classification.$1,
      classificationDescription: classification.$2,
    );
  }

  List<int> _parseAddress(String input) {
    if (input.isEmpty || input.contains(':::')) {
      throw const FormatException('invalid_ipv6');
    }

    final parts = input.split('::');
    if (parts.length > 2) {
      throw const FormatException('invalid_ipv6');
    }

    List<int> parseChunk(String chunk) {
      if (chunk.isEmpty) return const [];
      final groups = chunk.split(':');
      final result = <int>[];
      for (final group in groups) {
        if (group.isEmpty || group.length > 4) {
          throw const FormatException('invalid_ipv6');
        }
        final value = int.tryParse(group, radix: 16);
        if (value == null || value < 0 || value > 0xFFFF) {
          throw const FormatException('invalid_ipv6');
        }
        result.add(value);
      }
      return result;
    }

    final left = parseChunk(parts[0]);
    if (parts.length == 1) {
      if (left.length != 8) {
        throw const FormatException('invalid_ipv6');
      }
      return left;
    }

    final right = parseChunk(parts[1]);
    final missing = 8 - (left.length + right.length);
    if (missing <= 0) {
      throw const FormatException('invalid_ipv6');
    }

    return [...left, ...List.filled(missing, 0), ...right];
  }

  String _toExpanded(List<int> hextets) {
    return hextets
        .map((value) => value.toRadixString(16).padLeft(4, '0'))
        .join(':');
  }

  String _toCompressed(List<int> hextets) {
    var bestStart = -1;
    var bestLen = 0;
    var currentStart = -1;
    var currentLen = 0;

    for (var index = 0; index < hextets.length; index++) {
      if (hextets[index] == 0) {
        if (currentStart == -1) currentStart = index;
        currentLen++;
      } else {
        if (currentLen > bestLen) {
          bestStart = currentStart;
          bestLen = currentLen;
        }
        currentStart = -1;
        currentLen = 0;
      }
    }

    if (currentLen > bestLen) {
      bestStart = currentStart;
      bestLen = currentLen;
    }

    if (bestLen < 2) {
      bestStart = -1;
      bestLen = 0;
    }

    final buffer = StringBuffer();
    var index = 0;
    while (index < hextets.length) {
      if (index == bestStart) {
        if (buffer.isEmpty) {
          buffer.write('::');
        } else {
          buffer.write(':');
          buffer.write(':');
        }
        index += bestLen;
        continue;
      }

      if (buffer.isNotEmpty && !buffer.toString().endsWith(':')) {
        buffer.write(':');
      }
      buffer.write(hextets[index].toRadixString(16));
      index++;
    }

    final result = buffer.toString();
    return result.isEmpty ? '::' : result;
  }

  BigInt _hextetsToBigInt(List<int> hextets) {
    var value = BigInt.zero;
    for (final hextet in hextets) {
      value = (value << 16) | BigInt.from(hextet);
    }
    return value;
  }

  BigInt _networkPrefix(BigInt value, int prefixLength) {
    if (prefixLength == 0) return BigInt.zero;
    final full = (BigInt.one << 128) - BigInt.one;
    final mask =
        ((BigInt.one << prefixLength) - BigInt.one) << (128 - prefixLength);
    return value & (mask & full);
  }

  BigInt _hostMask(int prefixLength) {
    if (prefixLength == 128) return BigInt.zero;
    return (BigInt.one << (128 - prefixLength)) - BigInt.one;
  }

  List<int> _bigIntToHextets(BigInt value) {
    final list = List<int>.filled(8, 0);
    var cursor = value;
    for (var index = 7; index >= 0; index--) {
      list[index] = (cursor & BigInt.from(0xFFFF)).toInt();
      cursor = cursor >> 16;
    }
    return list;
  }

  (String, String) _classify(BigInt value) {
    if (value == BigInt.zero) {
      return ('Unspecified', 'Used as an unspecified source address.');
    }

    if (value == BigInt.one) {
      return ('Loopback', 'Points to the local host (::1).');
    }

    if ((value >> 120) == BigInt.from(0xFF)) {
      final scope = _multicastScope(value);
      return ('Multicast', 'Delivered to multiple listeners (${scope.$1}). ${scope.$2}');
    }

    if (_isIpv4Mapped(value)) {
      return (
        'IPv4-mapped',
        'Represents an IPv4 endpoint in IPv6 format (::ffff:0:0/96).',
      );
    }

    if ((value >> 112) == _sixToFourPrefix) {
      return (
        '6to4',
        'Transition address for 6to4 tunneling (2002::/16).',
      );
    }

    if ((value >> 96) == _teredoPrefix) {
      return (
        'Teredo',
        'Transition address for Teredo tunneling (2001:0000::/32).',
      );
    }

    if ((value >> 118) == BigInt.from(0x3FA)) {
      return ('Link-local', 'Valid only on local link (fe80::/10).');
    }

    if ((value >> 121) == BigInt.from(0x7E)) {
      return (
        'Unique Local',
        'Private IPv6 range for local routing (fc00::/7).',
      );
    }

    if ((value >> 125) == BigInt.from(0x1)) {
      return ('Global Unicast', 'Publicly routable IPv6 address (2000::/3).');
    }

    return ('Other', 'Address type is valid but uncommon.');
  }

  bool _isIpv4Mapped(BigInt value) {
    return (value >> 32) == _ipv4MappedPrefix;
  }

  (String, String) _multicastScope(BigInt value) {
    final secondByte = ((value >> 112) & BigInt.from(0xFF)).toInt();
    final scopeCode = secondByte & 0x0F;

    return switch (scopeCode) {
      0x1 => ('interface-local scope', 'Traffic stays within one interface.'),
      0x2 => ('link-local scope', 'Traffic stays on the local network link.'),
      0x4 => ('admin-local scope', 'Traffic is limited to an admin-defined domain.'),
      0x5 => ('site-local scope', 'Traffic is limited to a site domain.'),
      0x8 => ('organization-local scope', 'Traffic is limited to an organization.'),
      0xE => ('global scope', 'Traffic can be routed globally.'),
      _ => ('unknown scope', 'Scope value is uncommon but valid.'),
    };
  }
}
