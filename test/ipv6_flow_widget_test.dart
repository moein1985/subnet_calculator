import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:subnet_calculator/app.dart';
import 'package:subnet_calculator/core/di/service_locator.dart';

void main() {
  testWidgets('IPv6 tab flow smoke test', (WidgetTester tester) async {
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();

    await tester.pumpWidget(SubnetCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tab_ipv6')), findsOneWidget);

    final BuildContext tabBarContext = tester.element(find.byType(TabBar));
    final TabController tabController = DefaultTabController.of(tabBarContext);
    tabController.animateTo(1);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(tabController.index, 1);
    expect(find.byKey(const Key('tab_ipv4')), findsOneWidget);
  });
}
