import 'package:go_router/go_router.dart';

import '../features/education/presentation/pages/education_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/subnet/presentation/pages/subnet_page.dart';
import '../features/tools/presentation/pages/tools_page.dart';
import 'app_shell.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              return AppShell(location: state.uri.path, child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const SubnetPage(),
              ),
              GoRoute(
                path: '/tools',
                builder: (context, state) => const ToolsPage(),
              ),
              GoRoute(
                path: '/education',
                builder: (context, state) => const EducationPage(),
              ),
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
              GoRoute(
                path: '/tools/vlsm',
                builder: (context, state) =>
                    ToolVlsmPage(seed: state.uri.queryParameters['seed']),
              ),
              GoRoute(
                path: '/tools/summarization',
                builder: (context, state) => ToolSummarizationPage(
                  seed: state.uri.queryParameters['seed'],
                ),
              ),
              GoRoute(
                path: '/tools/split-merge',
                builder: (context, state) =>
                    ToolSplitMergePage(seed: state.uri.queryParameters['seed']),
              ),
              GoRoute(
                path: '/tools/report',
                builder: (context, state) =>
                    ToolReportPage(seed: state.uri.queryParameters['seed']),
              ),
              GoRoute(
                path: '/tools/templates',
                builder: (context, state) => ToolTemplatesPage(
                  seed: state.uri.queryParameters['seed'],
                ),
              ),
              GoRoute(
                path: '/tools/ipv6-prefix-planner',
                builder: (context, state) => ToolIpv6PrefixPlannerPage(
                  seed: state.uri.queryParameters['seed'],
                ),
              ),
              GoRoute(
                path: '/tools/reverse-dns',
                builder: (context, state) =>
                    ToolReverseDnsPage(seed: state.uri.queryParameters['seed']),
              ),
              GoRoute(
                path: '/tools/address-inspector',
                builder: (context, state) => ToolAddressInspectorPage(
                  seed: state.uri.queryParameters['seed'],
                ),
              ),
            ],
          ),
        ],
      );

  final GoRouter router;
}
