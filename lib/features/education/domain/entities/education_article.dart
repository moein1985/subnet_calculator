import 'package:equatable/equatable.dart';

enum EducationTrack { ipv4, ipv6 }

class EducationArticle extends Equatable {
  const EducationArticle({
    required this.track,
    required this.titleEn,
    required this.titleFa,
    required this.contentEn,
    required this.contentFa,
  });

  final EducationTrack track;
  final String titleEn;
  final String titleFa;
  final String contentEn;
  final String contentFa;

  @override
  List<Object> get props => [track, titleEn, titleFa, contentEn, contentFa];
}
