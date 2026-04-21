import '../entities/ipv6_result.dart';
import '../repositories/ipv6_repository.dart';

class AnalyzeIpv6UseCase {
  AnalyzeIpv6UseCase(this._repository);

  final Ipv6Repository _repository;

  Ipv6Result call(String input) {
    return _repository.analyze(input);
  }
}
