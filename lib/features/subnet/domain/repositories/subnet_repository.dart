import '../entities/subnet_result.dart';

abstract class SubnetRepository {
  SubnetResult calculate({
    required String ipv4Address,
    required String prefixOrMask,
  });
}
