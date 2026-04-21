import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/localization_extension.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/bloc/history_bloc.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tools)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.toolsMainSection,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ToolChip(label: l10n.toolVlsm, route: '/tools/vlsm'),
              _ToolChip(
                label: l10n.toolSummarization,
                route: '/tools/summarization',
              ),
              _ToolChip(label: l10n.toolSplitMerge, route: '/tools/split-merge'),
              _ToolChip(label: l10n.toolShareReport, route: '/tools/report'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.toolsMoreSection,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ToolChip(label: l10n.toolTemplates, route: '/tools/templates'),
              _ToolChip(
                label: l10n.toolIpv6PrefixPlanner,
                route: '/tools/ipv6-prefix-planner',
              ),
              _ToolChip(
                label: l10n.toolReverseDns,
                route: '/tools/reverse-dns',
              ),
              _ToolChip(
                label: l10n.toolAddressInspector,
                route: '/tools/address-inspector',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: () => context.push(route));
  }
}

class ToolVlsmPage extends StatefulWidget {
  const ToolVlsmPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolVlsmPage> createState() => _ToolVlsmPageState();
}

class _ToolVlsmPageState extends State<ToolVlsmPage> {
  final _baseController = TextEditingController(text: '192.168.10.0/24');
  final _needsController = TextEditingController(text: '60,30,12');
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      final parts = widget.seed!.split('|');
      if (parts.length >= 2) {
        _baseController.text = parts[0];
        _needsController.text = parts[1];
      }
    }
  }

  void _generate() {
    try {
      final base = _parseCidr(_baseController.text.trim());
      final needs = _needsController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .where((n) => n > 0)
          .toList()
        ..sort((a, b) => b.compareTo(a));
      final lines = <String>[];
      var next = base.$1;
      var used = 0;
      for (final need in needs) {
        final hostBits = math.max(2, (math.log(need + 2) / math.ln2).ceil());
        final prefix = 32 - hostBits;
        final size = 1 << hostBits;
        next = _alignNetwork(next, prefix);
        final broadcast = next + size - 1;
        final line = _advanced
          ? '${_toDotted(next)}/$prefix | ${context.l10n.subnetMask}: ${_prefixToMask(prefix)} | ${context.l10n.firstHost}: ${_toDotted(next + 1)} | ${context.l10n.lastHost}: ${_toDotted(broadcast - 1)} | ${context.l10n.usableHosts}: ${size - 2} | ${context.l10n.waste}: ${size - (need + 2)}'
          : '${_toDotted(next)}/$prefix -> ${context.l10n.usableHosts}: ${size - 2}';
        lines.add(line);
        next = broadcast + 1;
        used += size;
      }
      final baseSize = 1 << (32 - base.$2);
      final remaining = baseSize - used;
      final output = '${lines.join('\n')}\n${context.l10n.remaining}: $remaining';
      setState(() {
        _result = output;
      });
      _saveToHistory(
        context,
        toolType: 'tool_vlsm',
        input: '${_baseController.text.trim()}|${_needsController.text.trim()}',
        summary: lines.isEmpty ? context.l10n.noSubnetsAllocated : lines.first,
      );
    } catch (_) {
      setState(() {
        _result = context.l10n.invalidVlsmInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolVlsm,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _baseController,
            decoration: InputDecoration(labelText: context.l10n.baseNetworkCidr),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _needsController,
            decoration: InputDecoration(
              labelText: context.l10n.hostNeedsCommaSeparated,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _generate, child: Text(context.l10n.generate)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class ToolSummarizationPage extends StatefulWidget {
  const ToolSummarizationPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolSummarizationPage> createState() => _ToolSummarizationPageState();
}

class _ToolSummarizationPageState extends State<ToolSummarizationPage> {
  final _controller = TextEditingController(
    text: '10.0.0.0/24\n10.0.1.0/24\n10.0.2.0/24\n10.0.3.0/24',
  );
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      _controller.text = widget.seed!;
    }
  }

  void _summarize() {
    try {
      final items = _controller.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map(_parseCidr)
          .toList();
      final minIp = items.map((e) => e.$1).reduce(math.min);
      final maxIp = items
          .map((e) => e.$1 + ((1 << (32 - e.$2)) - 1))
          .reduce(math.max);
      final summary = _rangeToCidr(minIp, maxIp);
        final output = _advanced
          ? '${context.l10n.summaryRoute}: ${_toDotted(summary.$1)}/${summary.$2}\n${context.l10n.inputNetworks}: ${items.length}\n${context.l10n.range}: ${_toDotted(minIp)} - ${_toDotted(maxIp)}\n${context.l10n.routePolicyNote}'
          : '${context.l10n.summaryRoute}: ${_toDotted(summary.$1)}/${summary.$2}\n${context.l10n.inputNetworks}: ${items.length}';
      setState(() {
        _result = output;
      });
      _saveToHistory(
        context,
        toolType: 'tool_summarization',
        input: _controller.text.trim(),
        summary: 'Summary: ${_toDotted(summary.$1)}/${summary.$2}',
      );
    } catch (_) {
      setState(() {
        _result = context.l10n.invalidSummarizationInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolSummarization,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: context.l10n.subnetListPerLine,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _summarize, child: Text(context.l10n.summarize)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class ToolSplitMergePage extends StatefulWidget {
  const ToolSplitMergePage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolSplitMergePage> createState() => _ToolSplitMergePageState();
}

class _ToolSplitMergePageState extends State<ToolSplitMergePage> {
  final _cidrController = TextEditingController(text: '192.168.1.0/24');
  final _targetController = TextEditingController(text: '26');
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      final parts = widget.seed!.split('|');
      if (parts.length >= 2) {
        _cidrController.text = parts[0];
        _targetController.text = parts[1];
      }
    }
  }

  void _split() {
    try {
      final base = _parseCidr(_cidrController.text.trim());
      final target = int.parse(_targetController.text.trim());
      if (target <= base.$2 || target > 32) throw Exception();
      final count = 1 << (target - base.$2);
      final size = 1 << (32 - target);
      final lines = List.generate(count, (i) {
        final network = base.$1 + i * size;
        if (_advanced) {
          final first = network + 1;
          final last = network + size - 2;
          return '${_toDotted(network)}/$target | ${context.l10n.firstHost}: ${_toDotted(first)} | ${context.l10n.lastHost}: ${_toDotted(last)} | ${context.l10n.usableHosts}: ${size - 2}';
        }
        return '${_toDotted(network)}/$target';
      });
      setState(() {
        _result = lines.join('\n');
      });
      _saveToHistory(
        context,
        toolType: 'tool_split_merge',
        input: '${_cidrController.text.trim()}|${_targetController.text.trim()}',
        summary: lines.isEmpty ? context.l10n.noSplitResult : lines.first,
      );
    } catch (_) {
      setState(() {
        _result = context.l10n.invalidSplitInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolSplitMerge,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _cidrController,
            decoration: InputDecoration(labelText: context.l10n.baseCidr),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _targetController,
            decoration: InputDecoration(labelText: context.l10n.splitToPrefix),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _split, child: Text(context.l10n.split)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class ToolReportPage extends StatefulWidget {
  const ToolReportPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolReportPage> createState() => _ToolReportPageState();
}

class _ToolReportPageState extends State<ToolReportPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.seed ??
          'Subnet Calculator Report\n- Paste or edit tool outputs here for sharing.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolShareReport,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            minLines: 6,
            maxLines: 10,
            decoration: InputDecoration(labelText: context.l10n.reportText),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              await _shareText(this.context, text);
              if (!mounted) return;
              _saveToHistory(
                this.context,
                toolType: 'tool_report',
                input: 'manual_report',
                summary: text.split('\n').first,
              );
            },
            child: Text(context.l10n.share),
          ),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _controller.text.trim()),
        ],
      ),
    );
  }
}

class ToolTemplatesPage extends StatefulWidget {
  const ToolTemplatesPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolTemplatesPage> createState() => _ToolTemplatesPageState();
}

class _ToolTemplatesPageState extends State<ToolTemplatesPage> {
  bool _advanced = false;

  @override
  Widget build(BuildContext context) {
    const templates = [
      'Small Office|192.168.10.0/24|60,30,12',
      'CCTV Network|10.20.0.0/24|100,20',
      'Branch Office|172.16.0.0/23|200,100,50',
    ];

    return _ToolScaffold(
      title: context.l10n.toolTemplates,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.readyTemplates),
          const SizedBox(height: 8),
          ...templates.map((entry) {
            final parts = entry.split('|');
            final title = parts[0];
            final cidr = parts[1];
            final needs = parts[2];
            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Text(
                  _advanced
                      ? 'Network: $cidr\nHost needs: $needs\nTap to open in VLSM planner'
                      : '$cidr | $needs',
                ),
                onTap: () {
                  final seed = Uri.encodeComponent('$cidr|$needs');
                  context.push('/tools/vlsm?seed=$seed');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ToolIpv6PrefixPlannerPage extends StatefulWidget {
  const ToolIpv6PrefixPlannerPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolIpv6PrefixPlannerPage> createState() =>
      _ToolIpv6PrefixPlannerPageState();
}

class _ToolIpv6PrefixPlannerPageState extends State<ToolIpv6PrefixPlannerPage> {
  final _basePrefix = TextEditingController(text: '2001:db8::/48');
  final _siteCount = TextEditingController(text: '4');
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      final parts = widget.seed!.split('|');
      if (parts.length >= 2) {
        _basePrefix.text = parts[0];
        _siteCount.text = parts[1];
      }
    }
  }

  void _plan() {
    try {
      final parts = _basePrefix.text.trim().split('/');
      if (parts.length != 2) throw Exception();
      final siteCount = int.parse(_siteCount.text.trim());
      final lines = List.generate(siteCount, (i) {
        final hextet = i.toRadixString(16);
        return _advanced
        ? '${context.l10n.site} ${i + 1}: ${parts[0]}:$hextet::/56 -> LAN: ${parts[0]}:$hextet:0::/64'
        : '${context.l10n.site} ${i + 1}: ${parts[0]}:$hextet::/56';
      });
      setState(() {
        _result = lines.join('\n');
      });
      _saveToHistory(
        context,
        toolType: 'tool_ipv6_prefix_planner',
        input: '${_basePrefix.text.trim()}|${_siteCount.text.trim()}',
        summary: lines.isEmpty ? 'No prefix allocated' : lines.first,
      );
    } catch (_) {
      setState(() {
        _result = context.l10n.invalidIpv6PlannerInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolIpv6PrefixPlanner,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _basePrefix,
            decoration: InputDecoration(labelText: context.l10n.basePrefix48),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _siteCount,
            decoration: InputDecoration(labelText: context.l10n.siteCount),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _plan, child: Text(context.l10n.generate)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class ToolReverseDnsPage extends StatefulWidget {
  const ToolReverseDnsPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolReverseDnsPage> createState() => _ToolReverseDnsPageState();
}

class _ToolReverseDnsPageState extends State<ToolReverseDnsPage> {
  final _input = TextEditingController(text: '192.168.1.10');
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      _input.text = widget.seed!;
    }
  }

  void _generate() {
    final value = _input.text.trim();
    if (value.contains('.')) {
      final parts = value.split('.');
      if (parts.length == 4) {
        final ptr = '${parts.reversed.join('.')}.in-addr.arpa';
        setState(() {
          _result = _advanced ? '${context.l10n.ptrRecordIpv4}\n$ptr' : ptr;
        });
        _saveToHistory(
          context,
          toolType: 'tool_reverse_dns',
          input: value,
          summary: ptr,
        );
        return;
      }
    }

    if (value.contains(':')) {
      final expanded = _expandIpv6(value);
      if (expanded != null) {
        final hex = expanded.replaceAll(':', '');
        final ptr = '${hex.split('').reversed.join('.')}.ip6.arpa';
        setState(() {
          _result = _advanced ? '${context.l10n.ptrRecordIpv6}\n$ptr' : ptr;
        });
        _saveToHistory(
          context,
          toolType: 'tool_reverse_dns',
          input: value,
          summary: ptr,
        );
        return;
      }
    }

    setState(() {
      _result = context.l10n.invalidIp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolReverseDns,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _input,
            decoration: InputDecoration(labelText: context.l10n.ipAddress),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _generate, child: Text(context.l10n.generatePtr)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class ToolAddressInspectorPage extends StatefulWidget {
  const ToolAddressInspectorPage({super.key, this.seed});

  final String? seed;

  @override
  State<ToolAddressInspectorPage> createState() =>
      _ToolAddressInspectorPageState();
}

class _ToolAddressInspectorPageState extends State<ToolAddressInspectorPage> {
  final _input = TextEditingController(text: 'fe80::1');
  bool _advanced = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.seed != null && widget.seed!.isNotEmpty) {
      _input.text = widget.seed!;
    }
  }

  void _inspect() {
    final value = _input.text.trim().toLowerCase();
    if (value.contains('.')) {
      final octets = value.split('.').map(int.tryParse).toList();
      if (octets.length == 4 && !octets.contains(null)) {
        final first = octets.first!;
        final type = (first == 10 ||
                (first == 172 && octets[1]! >= 16 && octets[1]! <= 31) ||
                (first == 192 && octets[1] == 168))
          ? context.l10n.ipv4Private
          : context.l10n.ipv4Public;
        final detail = _advanced
          ? '$type\n${context.l10n.addressInspectorIpv4Hint}'
            : type;
        setState(() => _result = detail);
        _saveToHistory(
          context,
          toolType: 'tool_address_inspector',
          input: value,
          summary: type,
        );
        return;
      }
    }

    if (value.contains(':')) {
      String type = context.l10n.ipv6GlobalOther;
      if (value == '::1') {
        type = context.l10n.ipv6Loopback;
      } else if (value.startsWith('fe80')) {
        type = context.l10n.ipv6LinkLocal;
      } else if (value.startsWith('fc') || value.startsWith('fd')) {
        type = context.l10n.ipv6UniqueLocal;
      } else if (value.startsWith('ff')) {
        type = context.l10n.ipv6Multicast;
      }
      final detail = _advanced
          ? '$type\n${context.l10n.addressInspectorIpv6Hint}'
          : type;
      setState(() => _result = detail);
      _saveToHistory(
        context,
        toolType: 'tool_address_inspector',
        input: value,
        summary: type,
      );
      return;
    }

    setState(() => _result = context.l10n.unknownFormat);
  }

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: context.l10n.toolAddressInspector,
      advanced: _advanced,
      onModeChanged: (value) => setState(() => _advanced = value),
      child: Column(
        children: [
          TextField(
            controller: _input,
            decoration: InputDecoration(labelText: context.l10n.address),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _inspect, child: Text(context.l10n.inspect)),
          const SizedBox(height: 8),
          _ReportBox(text: _result),
          const SizedBox(height: 8),
          _ResultActions(textProvider: () => _result),
        ],
      ),
    );
  }
}

class _ToolScaffold extends StatelessWidget {
  const _ToolScaffold({
    required this.title,
    required this.child,
    this.advanced,
    this.onModeChanged,
  });

  final String title;
  final Widget child;
  final bool? advanced;
  final ValueChanged<bool>? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (advanced != null && onModeChanged != null) ...[
            SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(value: false, label: Text(context.l10n.basicMode)),
                ButtonSegment<bool>(value: true, label: Text(context.l10n.advancedMode)),
              ],
              selected: {advanced!},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  onModeChanged!(selection.first);
                }
              },
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _ReportBox extends StatelessWidget {
  const _ReportBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(text.isEmpty ? context.l10n.noResultYet : text),
    );
  }
}

class _ResultActions extends StatelessWidget {
  const _ResultActions({required this.textProvider});

  final String Function() textProvider;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        OutlinedButton(
          onPressed: () async {
            final text = textProvider();
            if (text.trim().isEmpty) return;
            await Clipboard.setData(ClipboardData(text: text));
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(context.l10n.copied)));
          },
          child: Text(context.l10n.copy),
        ),
        FilledButton(
          onPressed: () async {
            final text = textProvider();
            if (text.trim().isEmpty) return;
            await _shareText(context, text);
          },
          child: Text(context.l10n.share),
        ),
      ],
    );
  }
}

Future<void> _shareText(BuildContext context, String text) async {
  const channel = MethodChannel('subnet_calculator/share');
  try {
    await channel.invokeMethod('shareText', {'text': text, 'subject': 'Subnet Calculator'});
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.shareUnavailableCopied)),
    );
  }
}

void _saveToHistory(
  BuildContext context, {
  required String toolType,
  required String input,
  required String summary,
}) {
  context.read<HistoryBloc>().add(
    HistoryItemAdded(
      item: HistoryItem(
        toolType: toolType,
        input: input,
        summary: summary,
        createdAt: DateTime.now(),
      ),
    ),
  );
}

(int, int) _parseCidr(String input) {
  final parts = input.split('/');
  if (parts.length != 2) throw Exception();
  final prefix = int.parse(parts[1]);
  if (prefix < 0 || prefix > 32) throw Exception();
  final octets = parts[0].split('.').map(int.parse).toList();
  if (octets.length != 4) throw Exception();
  final value =
      (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3];
  return (_alignNetwork(value, prefix), prefix);
}

int _alignNetwork(int ip, int prefix) {
  final mask = prefix == 0 ? 0 : ((0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF);
  return ip & mask;
}

String _toDotted(int value) {
  return [
    (value >> 24) & 0xFF,
    (value >> 16) & 0xFF,
    (value >> 8) & 0xFF,
    value & 0xFF,
  ].join('.');
}

String _prefixToMask(int prefix) {
  final mask = prefix == 0 ? 0 : ((0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF);
  return _toDotted(mask);
}

(int, int) _rangeToCidr(int minIp, int maxIp) {
  var prefix = 0;
  for (var bit = 31; bit >= 0; bit--) {
    final a = (minIp >> bit) & 1;
    final b = (maxIp >> bit) & 1;
    if (a == b) {
      prefix++;
    } else {
      break;
    }
  }
  final network = _alignNetwork(minIp, prefix);
  return (network, prefix);
}

String? _expandIpv6(String input) {
  final value = input.trim();
  if (value.isEmpty || value.contains(':::')) return null;
  final chunks = value.split('::');
  if (chunks.length > 2) return null;

  List<int> parseChunk(String chunk) {
    if (chunk.isEmpty) return const [];
    final parts = chunk.split(':');
    final result = <int>[];
    for (final p in parts) {
      if (p.isEmpty || p.length > 4) throw Exception();
      final n = int.parse(p, radix: 16);
      if (n < 0 || n > 0xFFFF) throw Exception();
      result.add(n);
    }
    return result;
  }

  try {
    final left = parseChunk(chunks[0]);
    if (chunks.length == 1) {
      if (left.length != 8) return null;
      return left.map((e) => e.toRadixString(16).padLeft(4, '0')).join(':');
    }

    final right = parseChunk(chunks[1]);
    final missing = 8 - (left.length + right.length);
    if (missing <= 0) return null;
    final hextets = [...left, ...List.filled(missing, 0), ...right];
    return hextets.map((e) => e.toRadixString(16).padLeft(4, '0')).join(':');
  } catch (_) {
    return null;
  }
}
