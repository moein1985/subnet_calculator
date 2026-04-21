import 'package:equatable/equatable.dart';

class HistoryItem extends Equatable {
  const HistoryItem({
    this.toolType = 'subnet_ipv4',
    required this.input,
    required this.summary,
    required this.createdAt,
  });

  final String toolType;
  final String input;
  final String summary;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'toolType': toolType,
      'input': input,
      'summary': summary,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> map) {
    return HistoryItem(
      toolType: map['toolType'] as String? ?? 'subnet_ipv4',
      input: map['input'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  List<Object> get props => [toolType, input, summary, createdAt];
}
