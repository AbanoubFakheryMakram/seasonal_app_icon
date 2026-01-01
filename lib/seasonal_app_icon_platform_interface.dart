import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'seasonal_app_icon_method_channel.dart';

abstract class SeasonalAppIconPlatform extends PlatformInterface {
  /// Constructs a SeasonalAppIconPlatform.
  SeasonalAppIconPlatform() : super(token: _token);

  static final Object _token = Object();

  static SeasonalAppIconPlatform _instance = MethodChannelSeasonalAppIcon();

  /// The default instance of [SeasonalAppIconPlatform] to use.
  ///
  /// Defaults to [MethodChannelSeasonalAppIcon].
  static SeasonalAppIconPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SeasonalAppIconPlatform] when
  /// they register themselves.
  static set instance(SeasonalAppIconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the app icon to the specified icon name.
  ///
  /// [iconName] - The name of the icon to set. Pass `null` to reset to default.
  /// Returns a map with 'success' boolean and optional 'error' message.
  Future<Map<String, dynamic>> setIcon(String? iconName) {
    throw UnimplementedError('setIcon() has not been implemented.');
  }

  /// Gets the current app icon name.
  ///
  /// Returns `null` if the default icon is being used.
  Future<String?> getCurrentIcon() {
    throw UnimplementedError('getCurrentIcon() has not been implemented.');
  }

  /// Checks if the app supports alternate icons.
  Future<bool> supportsAlternateIcons() {
    throw UnimplementedError('supportsAlternateIcons() has not been implemented.');
  }

  /// Gets a list of available alternate icon names.
  Future<List<String>> getAvailableIcons() {
    throw UnimplementedError('getAvailableIcons() has not been implemented.');
  }
}
