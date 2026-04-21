import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/localization_extension.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../ipv6/presentation/bloc/ipv6_bloc.dart';
import '../../../settings/presentation/bloc/app_settings_bloc.dart';
import '../bloc/subnet_calculator_bloc.dart';

class SubnetPage extends StatefulWidget {
  const SubnetPage({super.key});

  @override
  State<SubnetPage> createState() => _SubnetPageState();
}

class _SubnetPageState extends State<SubnetPage> {
  final TextEditingController _ipController = TextEditingController(
    text: '192.168.1.10',
  );
  final TextEditingController _prefixController = TextEditingController(
    text: '24',
  );
  final TextEditingController _ipv6Controller = TextEditingController(
    text: '2001:db8::1/64',
  );
  bool _ipv6Advanced = false;

  @override
  void dispose() {
    _ipController.dispose();
    _prefixController.dispose();
    _ipv6Controller.dispose();
    super.dispose();
  }

  void _calculate() {
    context.read<SubnetCalculatorBloc>().add(
      SubnetRequested(
        ipv4Address: _ipController.text.trim(),
        prefixOrMask: _prefixController.text.trim(),
      ),
    );
  }

  void _analyzeIpv6() {
    context.read<Ipv6Bloc>().add(
      Ipv6AnalyzeRequested(input: _ipv6Controller.text.trim()),
    );
  }

  void _setIpv6Mode(bool advanced) {
    if (_ipv6Advanced == advanced) return;

    setState(() {
      _ipv6Advanced = advanced;
    });

    final l10n = context.l10n;
    final message = advanced
        ? l10n.advancedModeEnabledHint
        : l10n.basicModeEnabledHint;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showAboutDialog() {
    final l10n = context.l10n;
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      children: [
        Text(l10n.aboutSummary),
        const SizedBox(height: 8),
        Text('${l10n.developedBy}: ${l10n.developerName}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final openIpv6TabByDefault = context.select<AppSettingsBloc, bool>(
      (bloc) => bloc.state.openIpv6TabByDefault,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<SubnetCalculatorBloc, SubnetCalculatorState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) {
            if (state.status == SubnetStatus.failure) {
              final message = switch (state.errorCode) {
                'invalid_prefix' => l10n.invalidPrefix,
                'invalid_ip' => l10n.invalidIp,
                _ => l10n.invalidIp,
              };

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }

            if (state.status == SubnetStatus.success && state.result != null) {
              context.read<HistoryBloc>().add(
                HistoryItemAdded(
                  item: HistoryItem(
                    toolType: 'subnet_ipv4',
                    input: state.result!.input,
                    summary:
                        '${l10n.networkAddress}: ${state.result!.networkAddress}',
                    createdAt: DateTime.now(),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<Ipv6Bloc, Ipv6State>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == Ipv6Status.success && state.result != null) {
              context.read<HistoryBloc>().add(
                HistoryItemAdded(
                  item: HistoryItem(
                    toolType: 'subnet_ipv6',
                    input: state.result!.input,
                    summary:
                        '${l10n.classification}: ${state.result!.classification}',
                    createdAt: DateTime.now(),
                  ),
                ),
              );
              return;
            }

            if (state.status != Ipv6Status.failure) return;

            final message = switch (state.errorCode) {
              'invalid_ipv6_prefix' => l10n.invalidIpv6Prefix,
              'invalid_ipv6' => l10n.invalidIpv6,
              _ => l10n.invalidIpv6,
            };
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
        BlocListener<HistoryBloc, HistoryState>(
          listenWhen: (previous, current) {
            return previous.reuseToken != current.reuseToken;
          },
          listener: (context, state) {
            final item = state.reuseItem;
            if (item == null) return;

            final input = item.input.trim();
            if (input.contains(':')) {
              _ipv6Controller.text = input;
              _analyzeIpv6();
              return;
            }

            final parts = input.split('/');
            if (parts.isNotEmpty) {
              _ipController.text = parts.first;
            }
            if (parts.length > 1) {
              _prefixController.text = parts[1];
            }

            _calculate();
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        initialIndex: openIpv6TabByDefault ? 1 : 0,
        child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(
                  tooltip: l10n.aboutApp,
                  icon: const Icon(Icons.info_outline),
                  onPressed: _showAboutDialog,
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(key: const Key('tab_ipv4'), text: l10n.ipv4Tab),
                  Tab(key: const Key('tab_ipv6'), text: l10n.ipv6),
                ],
              ),
            ),
            body: TabBarView(
              children: [_buildIpv4Tab(context), _buildIpv6Tab(context)],
            ),
          ),
        ),
    );
  }

  Widget _buildIpv4Tab(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.calculateSubnet,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ipController,
          decoration: InputDecoration(
            labelText: l10n.ipv4Address,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _prefixController,
          decoration: InputDecoration(
            labelText: l10n.prefixLength,
            hintText: l10n.prefixMaskHint,
            helperText: l10n.prefixMaskHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9./]')),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _calculate,
          icon: const Icon(Icons.calculate),
          label: Text(l10n.calculate),
        ),
        const SizedBox(height: 16),
        BlocBuilder<SubnetCalculatorBloc, SubnetCalculatorState>(
          builder: (context, state) {
            if (state.status == SubnetStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status != SubnetStatus.success || state.result == null) {
              return const SizedBox.shrink();
            }

            final result = state.result!;
            final rows = <(String, String)>[
              (l10n.networkAddress, result.networkAddress),
              (l10n.broadcastAddress, result.broadcastAddress),
              (l10n.subnetMask, result.subnetMask),
              (l10n.wildcardMask, result.wildcardMask),
              (l10n.firstHost, result.firstHost),
              (l10n.lastHost, result.lastHost),
              (l10n.usableHosts, result.usableHosts.toString()),
            ];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.result,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...rows.map((row) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(row.$1),
                        subtitle: Text(row.$2),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: row.$2),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.copied)),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIpv6Tab(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment<String>(value: 'basic', label: Text(l10n.basicMode)),
            ButtonSegment<String>(
              value: 'advanced',
              label: Text(l10n.advancedMode),
            ),
          ],
          selected: {_ipv6Advanced ? 'advanced' : 'basic'},
          onSelectionChanged: (selection) {
            if (selection.isEmpty) return;
            _setIpv6Mode(selection.first == 'advanced');
          },
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _ipv6Advanced
                  ? l10n.advancedModeDetailsHint
                  : l10n.basicModeDetailsHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _ipv6Controller,
          decoration: InputDecoration(
            labelText: l10n.ipv6Input,
            hintText: l10n.ipv6InputHint,
            helperText: l10n.ipv6InputHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          key: const Key('ipv6_analyze_button'),
          onPressed: _analyzeIpv6,
          icon: const Icon(Icons.travel_explore),
          label: Text(l10n.analyzeIpv6),
        ),
        const SizedBox(height: 14),
        BlocBuilder<Ipv6Bloc, Ipv6State>(
          builder: (context, state) {
            if (state.status == Ipv6Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status != Ipv6Status.success || state.result == null) {
              return const SizedBox.shrink();
            }

            final result = state.result!;
            final basicRows = <(String, String)>[
              (l10n.networkPrefix, result.networkPrefix),
              (l10n.firstAddress, result.firstAddress),
              (l10n.lastAddress, result.lastAddress),
              (l10n.totalAddresses, result.totalAddresses),
              (l10n.classification, result.classification),
            ];

            final advancedRows = <(String, String)>[
              (l10n.compressed, result.compressed),
              (l10n.expanded, result.expanded),
              (l10n.input, result.addressOnly),
              (l10n.prefixLength, result.prefixLength.toString()),
              (l10n.networkPrefix, result.networkPrefix),
              (l10n.firstAddress, result.firstAddress),
              (l10n.lastAddress, result.lastAddress),
              (l10n.totalAddresses, result.totalAddresses),
              (l10n.classification, result.classification),
              (
                l10n.classificationDescription,
                result.classificationDescription,
              ),
              (l10n.ipv4Mapped, result.isIpv4Mapped ? l10n.yes : l10n.no),
              (l10n.interfaceId, result.interfaceId),
              (l10n.networkBits, result.networkBitCount.toString()),
              (l10n.hostBits, result.hostBitCount.toString()),
            ];

            final rows = _ipv6Advanced ? advancedRows : basicRows;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.result,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...rows.map((row) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(row.$1),
                        subtitle: Text(row.$2),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: row.$2),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.copied)),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
