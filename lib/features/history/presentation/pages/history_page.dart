import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/localization_extension.dart';
import '../bloc/history_bloc.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l10n.clearHistory,
            onPressed: () async {
              final shouldClear = await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text(l10n.clearHistory),
                    content: Text(l10n.clearHistoryConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: Text(l10n.clear),
                      ),
                    ],
                  );
                },
              );

              if (shouldClear != true || !context.mounted) return;
              context.read<HistoryBloc>().add(const HistoryCleared());
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return Center(child: Text(l10n.noHistory));
          }

          final localeCode = Localizations.localeOf(context).languageCode;
          final formatter = DateFormat('yyyy/MM/dd HH:mm', localeCode);

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    context.read<HistoryBloc>().add(
                      HistoryItemReuseRequested(item: item),
                    );
                    final seed = Uri.encodeComponent(item.input);
                    final route = switch (item.toolType) {
                      'subnet_ipv4' || 'subnet_ipv6' => '/',
                      'tool_vlsm' => '/tools/vlsm?seed=$seed',
                      'tool_summarization' => '/tools/summarization?seed=$seed',
                      'tool_split_merge' => '/tools/split-merge?seed=$seed',
                      'tool_report' => '/tools/report?seed=$seed',
                      'tool_templates' => '/tools/templates?seed=$seed',
                      'tool_ipv6_prefix_planner' =>
                        '/tools/ipv6-prefix-planner?seed=$seed',
                      'tool_reverse_dns' => '/tools/reverse-dns?seed=$seed',
                      'tool_address_inspector' =>
                        '/tools/address-inspector?seed=$seed',
                      _ => '/',
                    };
                    context.go(route);
                  },
                  title: Text('${_toolLabel(context, item.toolType)} | ${item.input}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.summary),
                      const SizedBox(height: 2),
                      Text(
                        formatter.format(item.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.delete,
                    onPressed: () {
                      context.read<HistoryBloc>().add(
                        HistoryItemRemoved(item: item),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _toolLabel(BuildContext context, String toolType) {
  final l10n = context.l10n;

  return switch (toolType) {
    'subnet_ipv4' => l10n.historyLabelSubnetIpv4,
    'subnet_ipv6' => l10n.historyLabelSubnetIpv6,
    'tool_vlsm' => l10n.toolVlsm,
    'tool_summarization' => l10n.toolSummarization,
    'tool_split_merge' => l10n.toolSplitMerge,
    'tool_report' => l10n.toolShareReport,
    'tool_templates' => l10n.toolTemplates,
    'tool_ipv6_prefix_planner' => l10n.toolIpv6PrefixPlanner,
    'tool_reverse_dns' => l10n.toolReverseDns,
    'tool_address_inspector' => l10n.toolAddressInspector,
    _ => l10n.tools,
  };
}
