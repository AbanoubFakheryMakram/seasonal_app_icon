import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_app_icon/seasonal_app_icon.dart';
import 'package:seasonal_app_icon/seasonal_app_icon_platform_interface.dart';
import 'package:seasonal_app_icon/seasonal_app_icon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSeasonalAppIconPlatform
    with MockPlatformInterfaceMixin
    implements SeasonalAppIconPlatform {

  @override
  Future<Map<String, dynamic>> setIcon(String? iconName) =>
      Future.value({'success': true, 'iconName': iconName});

  @override
  Future<String?> getCurrentIcon() => Future.value(null);

  @override
  Future<bool> supportsAlternateIcons() => Future.value(true);

  @override
  Future<List<String>> getAvailableIcons() =>
      Future.value(['christmas', 'halloween']);
}

void main() {
  final SeasonalAppIconPlatform initialPlatform = SeasonalAppIconPlatform.instance;

  test('$MethodChannelSeasonalAppIcon is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSeasonalAppIcon>());
  });

  test('setIcon returns success', () async {
    SeasonalAppIcon seasonalAppIconPlugin = SeasonalAppIcon();
    MockSeasonalAppIconPlatform fakePlatform = MockSeasonalAppIconPlatform();
    SeasonalAppIconPlatform.instance = fakePlatform;

    final result = await seasonalAppIconPlugin.setIcon('christmas');
    expect(result.success, true);
    expect(result.iconName, 'christmas');
  });

  test('supportsAlternateIcons returns true', () async {
    SeasonalAppIcon seasonalAppIconPlugin = SeasonalAppIcon();
    MockSeasonalAppIconPlatform fakePlatform = MockSeasonalAppIconPlatform();
    SeasonalAppIconPlatform.instance = fakePlatform;

    expect(await seasonalAppIconPlugin.supportsAlternateIcons(), true);
  });

  test('SeasonalIcon isActive works correctly', () {
    final now = DateTime.now();
    final activeIcon = SeasonalIcon(
      iconName: 'test',
      eventName: 'Test Event',
      startDate: now.subtract(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 1)),
    );
    final inactiveIcon = SeasonalIcon(
      iconName: 'test2',
      eventName: 'Test Event 2',
      startDate: now.add(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 20)),
    );

    expect(activeIcon.isActive, true);
    expect(inactiveIcon.isActive, false);
  });

  test('getIconForBrightness returns correct variant', () {
    final icon = SeasonalIcon(
      iconName: 'christmas',
      eventName: 'Christmas',
      startDate: DateTime(2024, 12, 20),
      endDate: DateTime(2024, 12, 26),
      lightIconName: 'christmas_light',
      darkIconName: 'christmas_dark',
    );

    expect(icon.getIconForBrightness(isDarkMode: true), 'christmas_dark');
    expect(icon.getIconForBrightness(isDarkMode: false), 'christmas_light');
  });

  test('getIconForBrightness falls back to iconName', () {
    final icon = SeasonalIcon(
      iconName: 'christmas',
      eventName: 'Christmas',
      startDate: DateTime(2024, 12, 20),
      endDate: DateTime(2024, 12, 26),
    );

    expect(icon.getIconForBrightness(isDarkMode: true), 'christmas');
    expect(icon.getIconForBrightness(isDarkMode: false), 'christmas');
  });
}
