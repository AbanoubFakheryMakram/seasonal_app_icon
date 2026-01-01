import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'seasonal_app_icon_platform_interface.dart';

/// An implementation of [SeasonalAppIconPlatform] that uses method channels.
class MethodChannelSeasonalAppIcon extends SeasonalAppIconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('seasonal_app_icon');

  @override
  Future<Map<String, dynamic>> setIcon(String? iconName) async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'setIcon',
        {'iconName': iconName},
      );
      return Map<String, dynamic>.from(result ?? {'success': false, 'error': 'No response from platform'});
    } on PlatformException catch (e) {
      return {'success': false, 'error': e.message};
    }
  }

  @override
  Future<String?> getCurrentIcon() async {
    try {
      final iconName = await methodChannel.invokeMethod<String?>('getCurrentIcon');
      return iconName;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<bool> supportsAlternateIcons() async {
    try {
      final supports = await methodChannel.invokeMethod<bool>('supportsAlternateIcons');
      return supports ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<List<String>> getAvailableIcons() async {
    try {
      final icons = await methodChannel.invokeMethod<List<dynamic>>('getAvailableIcons');
      return icons?.cast<String>() ?? [];
    } on PlatformException {
      return [];
    }
  }
}
