import 'package:flutter/widgets.dart';

import 'seasonal_app_icon_platform_interface.dart';
import 'src/models/seasonal_icon.dart';
import 'src/models/icon_change_result.dart';

export 'src/models/seasonal_icon.dart';
export 'src/models/icon_change_result.dart';

/// Main class for managing seasonal app icons.
///
/// This plugin allows you to change app icons based on seasonal events
/// like Christmas, Black Friday, etc. It supports light/dark mode variants.
///
/// ## Usage
///
/// ```dart
/// final seasonalIcon = SeasonalAppIcon();
///
/// // Configure seasonal icons
/// seasonalIcon.configure([
///   SeasonalIcon(
///     iconName: 'christmas',
///     eventName: 'Christmas',
///     startDate: DateTime(2024, 12, 20),
///     endDate: DateTime(2024, 12, 26),
///     lightIconName: 'christmas_light',
///     darkIconName: 'christmas_dark',
///   ),
/// ]);
///
/// // Apply the appropriate icon based on current date
/// await seasonalIcon.applySeasonalIcon();
/// ```
class SeasonalAppIcon {
  /// List of configured seasonal icons.
  final List<SeasonalIcon> _seasonalIcons = [];

  /// Callback for when the icon changes.
  void Function(IconChangeResult result)? onIconChanged;

  /// Configures the list of seasonal icons.
  ///
  /// This replaces any previously configured icons.
  void configure(List<SeasonalIcon> icons) {
    _seasonalIcons.clear();
    _seasonalIcons.addAll(icons);
  }

  /// Adds a single seasonal icon to the configuration.
  void addSeasonalIcon(SeasonalIcon icon) {
    _seasonalIcons.add(icon);
  }

  /// Removes a seasonal icon by its icon name.
  void removeSeasonalIcon(String iconName) {
    _seasonalIcons.removeWhere((icon) => icon.iconName == iconName);
  }

  /// Clears all configured seasonal icons.
  void clearSeasonalIcons() {
    _seasonalIcons.clear();
  }

  /// Gets the list of configured seasonal icons.
  List<SeasonalIcon> get seasonalIcons => List.unmodifiable(_seasonalIcons);

  /// Finds the currently active seasonal icon based on the current date.
  ///
  /// Returns `null` if no seasonal icon is active.
  SeasonalIcon? getActiveSeasonalIcon() {
    for (final icon in _seasonalIcons) {
      if (icon.isActive) {
        return icon;
      }
    }
    return null;
  }

  /// Finds the active seasonal icon for a specific date.
  ///
  /// Returns `null` if no seasonal icon is active for that date.
  SeasonalIcon? getSeasonalIconForDate(DateTime date) {
    for (final icon in _seasonalIcons) {
      if (icon.isActiveOn(date)) {
        return icon;
      }
    }
    return null;
  }

  /// Applies the appropriate seasonal icon based on the current date.
  ///
  /// If [isDarkMode] is provided, it will use the appropriate light/dark variant.
  /// If no seasonal icon is active, it resets to the default icon.
  ///
  /// Returns an [IconChangeResult] indicating success or failure.
  Future<IconChangeResult> applySeasonalIcon({bool? isDarkMode}) async {
    final activeIcon = getActiveSeasonalIcon();

    if (activeIcon == null) {
      // No seasonal icon active, reset to default
      return await resetToDefaultIcon();
    }

    // Determine which icon variant to use
    final darkMode = isDarkMode ?? _getSystemDarkMode();
    final iconName = activeIcon.getIconForBrightness(isDarkMode: darkMode);

    return await setIcon(iconName);
  }

  /// Sets a specific icon by name.
  ///
  /// Returns an [IconChangeResult] indicating success or failure.
  Future<IconChangeResult> setIcon(String iconName) async {
    final result = await SeasonalAppIconPlatform.instance.setIcon(iconName);
    final changeResult = IconChangeResult.fromMap(result);
    onIconChanged?.call(changeResult);
    return changeResult;
  }

  /// Resets the app icon to the default icon.
  ///
  /// Returns an [IconChangeResult] indicating success or failure.
  Future<IconChangeResult> resetToDefaultIcon() async {
    final result = await SeasonalAppIconPlatform.instance.setIcon(null);
    final changeResult = IconChangeResult.fromMap(result);
    onIconChanged?.call(changeResult);
    return changeResult;
  }

  /// Gets the name of the currently active icon.
  ///
  /// Returns `null` if the default icon is being used.
  Future<String?> getCurrentIcon() {
    return SeasonalAppIconPlatform.instance.getCurrentIcon();
  }

  /// Checks if the platform supports alternate icons.
  Future<bool> supportsAlternateIcons() {
    return SeasonalAppIconPlatform.instance.supportsAlternateIcons();
  }

  /// Gets a list of available alternate icon names from the native platform.
  Future<List<String>> getAvailableIcons() {
    return SeasonalAppIconPlatform.instance.getAvailableIcons();
  }

  /// Attempts to detect system dark mode.
  /// Falls back to false if unable to determine.
  bool _getSystemDarkMode() {
    try {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } catch (_) {
      return false;
    }
  }
}
