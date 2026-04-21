import 'package:flutter_test/flutter_test.dart';

import 'package:subnet_calculator/features/subnet/data/repositories/subnet_repository_impl.dart';

void main() {
  group('SubnetRepositoryImpl prefix/mask parsing', () {
    const repository = SubnetRepositoryImpl();

    test('accepts numeric prefix 24', () {
      final result = repository.calculate(
        ipv4Address: '192.168.1.10',
        prefixOrMask: '24',
      );

      expect(result.subnetMask, '255.255.255.0');
      expect(result.networkAddress, '192.168.1.0');
      expect(result.broadcastAddress, '192.168.1.255');
    });

    test('accepts slash prefix /24', () {
      final result = repository.calculate(
        ipv4Address: '10.10.10.10',
        prefixOrMask: '/24',
      );

      expect(result.subnetMask, '255.255.255.0');
      expect(result.networkAddress, '10.10.10.0');
    });

    test('accepts subnet mask 255.255.255.0', () {
      final result = repository.calculate(
        ipv4Address: '172.16.10.20',
        prefixOrMask: '255.255.255.0',
      );

      expect(result.input, '172.16.10.20/24');
      expect(result.wildcardMask, '0.0.0.255');
    });

    test('rejects non-contiguous mask', () {
      expect(
        () => repository.calculate(
          ipv4Address: '192.168.1.10',
          prefixOrMask: '255.0.255.0',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('SubnetRepositoryImpl edge prefix behavior', () {
    const repository = SubnetRepositoryImpl();

    test('/31 has 2 usable addresses', () {
      final result = repository.calculate(
        ipv4Address: '192.168.1.10',
        prefixOrMask: '31',
      );

      expect(result.usableHosts, 2);
      expect(result.firstHost, '192.168.1.10');
      expect(result.lastHost, '192.168.1.11');
    });

    test('/32 has 1 usable address', () {
      final result = repository.calculate(
        ipv4Address: '192.168.1.10',
        prefixOrMask: '32',
      );

      expect(result.usableHosts, 1);
      expect(result.firstHost, '192.168.1.10');
      expect(result.lastHost, '192.168.1.10');
    });
  });
}
