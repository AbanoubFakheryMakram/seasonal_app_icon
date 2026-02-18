/// Represents a seasonal app icon configuration.
///
/// This model defines an icon variant that should be displayed during
/// a specific date period (e.g., Christmas, Black Friday, etc.).
class SeasonalIcon {
  /// Unique identifier for this seasonal icon.
  /// This must match the icon name configured in native platforms.
  /// - iOS: The alternate icon name in Info.plist
  /// - Android: The activity-alias name in AndroidManifest.xml
  final String iconName;

  /// Display name for this seasonal event (e.g., "Christmas", "Black Friday").
  final String eventName;

  /// The start date when this icon should become active.
  final DateTime startDate;

  /// The end date when this icon should stop being active.
  ///
  /// This boundary is inclusive (`date == endDate` is treated as active).
  final DateTime endDate;

  /// Optional light mode icon name.
  /// If provided, this icon will be used when the device is in light mode.
  /// Falls back to [iconName] if not specified.
  final String? lightIconName;

  /// Optional dark mode icon name.
  /// If provided, this icon will be used when the device is in dark mode.
  /// Falls back to [iconName] if not specified.
  final String? darkIconName;

  /// Creates a new [SeasonalIcon] instance.
  ///
  /// [iconName] is required and must match the native icon configuration.
  /// [eventName] is a human-readable name for the event.
  /// [startDate] and [endDate] define the active period.
  /// [lightIconName] and [darkIconName] are optional variants for theme modes.
  const SeasonalIcon({
    required this.iconName,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    this.lightIconName,
    this.darkIconName,
  });

  /// Checks if this seasonal icon is currently active based on the current date.
  bool get isActive {
    final now = DateTime.now();
    return (now.isAfter(startDate) && now.isBefore(endDate)) ||
        now.isAtSameMomentAs(startDate) ||
        now.isAtSameMomentAs(endDate);
  }

  /// Checks if this seasonal icon is active for a given date.
  bool isActiveOn(DateTime date) {
    return (date.isAfter(startDate) && date.isBefore(endDate)) ||
        date.isAtSameMomentAs(startDate) ||
        date.isAtSameMomentAs(endDate);
  }

  /// Returns the appropriate icon name based on the brightness mode.
  ///
  /// [isDarkMode] - Whether the device is currently in dark mode.
  /// Returns [darkIconName] if in dark mode and available,
  /// [lightIconName] if in light mode and available,
  /// otherwise falls back to [iconName].
  String getIconForBrightness({required bool isDarkMode}) {
    if (isDarkMode && darkIconName != null) {
      return darkIconName!;
    }
    if (!isDarkMode && lightIconName != null) {
      return lightIconName!;
    }
    return iconName;
  }

  /// Creates a copy of this [SeasonalIcon] with the given fields replaced.
  SeasonalIcon copyWith({
    String? iconName,
    String? eventName,
    DateTime? startDate,
    DateTime? endDate,
    String? lightIconName,
    String? darkIconName,
  }) {
    return SeasonalIcon(
      iconName: iconName ?? this.iconName,
      eventName: eventName ?? this.eventName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lightIconName: lightIconName ?? this.lightIconName,
      darkIconName: darkIconName ?? this.darkIconName,
    );
  }

  @override
  String toString() {
    return 'SeasonalIcon(iconName: $iconName, eventName: $eventName, '
        'startDate: $startDate, endDate: $endDate, '
        'lightIconName: $lightIconName, darkIconName: $darkIconName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SeasonalIcon &&
        other.iconName == iconName &&
        other.eventName == eventName &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.lightIconName == lightIconName &&
        other.darkIconName == darkIconName;
  }

  @override
  int get hashCode {
    return Object.hash(
      iconName,
      eventName,
      startDate,
      endDate,
      lightIconName,
      darkIconName,
    );
  }
}
