class ToolReport {
  const ToolReport({
    required this.toolType,
    required this.title,
    required this.inputSummary,
    required this.outputSummary,
    required this.fullText,
  });

  final String toolType;
  final String title;
  final String inputSummary;
  final String outputSummary;
  final String fullText;
}
