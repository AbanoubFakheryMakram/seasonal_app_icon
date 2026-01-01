// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:seasonal_app_icon/seasonal_app_icon.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('supportsAlternateIcons test', (WidgetTester tester) async {
    final SeasonalAppIcon plugin = SeasonalAppIcon();
    final bool supports = await plugin.supportsAlternateIcons();
    // Both iOS and Android support alternate icons
    expect(supports, isA<bool>());
  });

  testWidgets('getCurrentIcon test', (WidgetTester tester) async {
    final SeasonalAppIcon plugin = SeasonalAppIcon();
    final String? currentIcon = await plugin.getCurrentIcon();
    // Default icon should return null
    expect(currentIcon, isNull);
  });

  testWidgets('SeasonalIcon configuration test', (WidgetTester tester) async {
    final SeasonalAppIcon plugin = SeasonalAppIcon();
    
    plugin.configure([
      SeasonalIcon(
        iconName: 'christmas',
        eventName: 'Christmas',
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
      ),
    ]);

    expect(plugin.seasonalIcons.length, 1);
    expect(plugin.seasonalIcons.first.eventName, 'Christmas');
  });
}
