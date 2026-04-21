import '../entities/ipv6_result.dart';

abstract class Ipv6Repository {
  Ipv6Result analyze(String input);
}
