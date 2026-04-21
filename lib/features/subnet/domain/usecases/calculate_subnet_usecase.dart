import '../entities/subnet_result.dart';
import '../repositories/subnet_repository.dart';

class CalculateSubnetUseCase {
  CalculateSubnetUseCase(this._repository);

  final SubnetRepository _repository;

  SubnetResult call({
    required String ipv4Address,
    required String prefixOrMask,
  }) {
    return _repository.calculate(
      ipv4Address: ipv4Address,
      prefixOrMask: prefixOrMask,
    );
  }
}
