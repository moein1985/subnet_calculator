import 'package:flutter_test/flutter_test.dart';

import 'package:subnet_calculator/features/ipv6/data/repositories/ipv6_repository_impl.dart';

void main() {
  group('Ipv6RepositoryImpl analyze', () {
    const repository = Ipv6RepositoryImpl();

    test('normalizes and classifies global unicast', () {
      final result = repository.analyze('2001:db8::1/64');

      expect(result.compressed, '2001:db8::1');
      expect(result.expanded, '2001:0db8:0000:0000:0000:0000:0000:0001');
      expect(result.networkPrefix, '2001:db8::/64');
      expect(result.interfaceId, '::1');
      expect(result.firstAddress, '2001:db8::');
      expect(result.lastAddress, '2001:db8::ffff:ffff:ffff:ffff');
      expect(result.totalAddresses, '18446744073709551616');
      expect(result.isIpv4Mapped, false);
      expect(result.networkBitCount, 64);
      expect(result.hostBitCount, 64);
      expect(result.classification, 'Global Unicast');
    });

    test('classifies link-local', () {
      final result = repository.analyze('fe80::1234/64');
      expect(result.classification, 'Link-local');
    });

    test('classifies loopback', () {
      final result = repository.analyze('::1/128');
      expect(result.classification, 'Loopback');
      expect(result.totalAddresses, '1');
      expect(result.firstAddress, '::1');
      expect(result.lastAddress, '::1');
    });

    test('classifies ipv4-mapped address', () {
      final result = repository.analyze('::ffff:c0a8:10a/128');
      expect(result.classification, 'IPv4-mapped');
      expect(result.isIpv4Mapped, true);
    });

    test('classifies 6to4 address', () {
      final result = repository.analyze('2002:c0a8:0101::1/64');
      expect(result.classification, '6to4');
    });

    test('classifies teredo address', () {
      final result = repository.analyze('2001:0000:4136:e378:8000:63bf:3fff:fdd2/64');
      expect(result.classification, 'Teredo');
    });

    test('throws for invalid prefix', () {
      expect(
        () => repository.analyze('2001:db8::1/129'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws for invalid address', () {
      expect(
        () => repository.analyze('2001:::1/64'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
