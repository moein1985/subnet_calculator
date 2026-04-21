import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/localization_extension.dart';
import '../bloc/app_settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment<String>(value: 'fa', label: Text(l10n.persian)),
                  ButtonSegment<String>(value: 'en', label: Text(l10n.english)),
                ],
                selected: {state.locale.languageCode},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) return;
                  final languageCode = selection.first;
                  context.read<AppSettingsBloc>().add(
                    LanguageChanged(Locale(languageCode)),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                l10n.defaultCalculatorTab,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment<String>(value: 'ipv4', label: Text(l10n.ipv4Tab)),
                  ButtonSegment<String>(value: 'ipv6', label: Text(l10n.ipv6)),
                ],
                selected: {state.openIpv6TabByDefault ? 'ipv6' : 'ipv4'},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) return;
                  context.read<AppSettingsBloc>().add(
                    DefaultSubnetTabChanged(
                      openIpv6TabByDefault: selection.first == 'ipv6',
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.privacy,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.offlinePrivacyNote),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
