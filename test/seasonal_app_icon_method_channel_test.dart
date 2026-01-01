import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_app_icon/seasonal_app_icon_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSeasonalAppIcon platform = MethodChannelSeasonalAppIcon();
  const MethodChannel channel = MethodChannel('seasonal_app_icon');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'setIcon':
            final args = methodCall.arguments as Map<dynamic, dynamic>;
            return {'success': true, 'iconName': args['iconName']};
          case 'getCurrentIcon':
            return null;
          case 'supportsAlternateIcons':
            return true;
          case 'getAvailableIcons':
            return ['christmas', 'halloween'];
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('setIcon returns success', () async {
    final result = await platform.setIcon('christmas');
    expect(result['success'], true);
    expect(result['iconName'], 'christmas');
  });

  test('getCurrentIcon returns null for default', () async {
    expect(await platform.getCurrentIcon(), null);
  });

  test('supportsAlternateIcons returns true', () async {
    expect(await platform.supportsAlternateIcons(), true);
  });

  test('getAvailableIcons returns list', () async {
    final icons = await platform.getAvailableIcons();
    expect(icons, ['christmas', 'halloween']);
  });
}
