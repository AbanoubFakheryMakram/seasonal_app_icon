# seasonal_app_icon

A Flutter plugin for dynamically changing app icons based on seasonal events (Christmas, Black Friday, etc.). Supports light/dark mode variants.

## Features

- 🎄 Change app icons based on date periods
- 🌙 Support for light and dark mode icon variants
- 📱 Works on both iOS and Android
- ⚡ Simple, declarative API

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  seasonal_app_icon: ^0.0.1
```

## Usage

### Basic Setup

```dart
import 'package:seasonal_app_icon/seasonal_app_icon.dart';

final seasonalIcon = SeasonalAppIcon();

// Configure seasonal icons
seasonalIcon.configure([
  SeasonalIcon(
    iconName: 'christmas',
    eventName: 'Christmas',
    startDate: DateTime(2024, 12, 20),
    endDate: DateTime(2024, 12, 26),
    lightIconName: 'christmas_light',  // Optional
    darkIconName: 'christmas_dark',    // Optional
  ),
  SeasonalIcon(
    iconName: 'black_friday',
    eventName: 'Black Friday',
    startDate: DateTime(2024, 11, 29),
    endDate: DateTime(2024, 12, 2),
  ),
]);

// Apply the appropriate icon based on current date
final result = await seasonalIcon.applySeasonalIcon();
if (!result.success) {
  debugPrint('Icon update failed: ${result.errorMessage}');
}
```

### Manual Icon Control

```dart
// Set a specific icon
final setResult = await seasonalIcon.setIcon('christmas');

// Reset to default icon
final resetResult = await seasonalIcon.resetToDefaultIcon();

// Get current icon name
final currentIcon = await seasonalIcon.getCurrentIcon();

// Check if alternate icons are supported
final supported = await seasonalIcon.supportsAlternateIcons();
```

## Platform Setup

### Icon Files Location & Naming

**Important**: You pass icon **identifiers** (names) in your Dart code, NOT file paths. These identifiers must match your native configuration.

```dart
SeasonalIcon(
  iconName: 'christmas',           // ← This is an IDENTIFIER, not a path
  eventName: 'Christmas',
  startDate: DateTime(2024, 12, 20),
  endDate: DateTime(2024, 12, 26),
  lightIconName: 'christmas_light', // ← Also an identifier
  darkIconName: 'christmas_dark',   // ← Also an identifier
)
```

### iOS Setup

#### 1. Add Icon Files

Add PNG files **directly to your Xcode project** (NOT in Assets.xcassets):

```
ios/Runner/
├── ChristmasIcon@2x.png        (120x120 pixels)
├── ChristmasIcon@3x.png        (180x180 pixels)
├── ChristmasIconLight@2x.png   (120x120 pixels)
├── ChristmasIconLight@3x.png   (180x180 pixels)
├── ChristmasIconDark@2x.png    (120x120 pixels)
├── ChristmasIconDark@3x.png    (180x180 pixels)
```

#### 2. Configure Info.plist

```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconFiles</key>
        <array>
            <string>AppIcon</string>
        </array>
    </dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>christmas</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>ChristmasIcon</string>
            </array>
        </dict>
        <key>christmas_light</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>ChristmasIconLight</string>
            </array>
        </dict>
        <key>christmas_dark</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>ChristmasIconDark</string>
            </array>
        </dict>
    </dict>
</dict>
```

### Android Setup

#### 1. Add Icon Files

Add icon PNG files to each mipmap density folder:

```
android/app/src/main/res/
├── mipmap-mdpi/
│   ├── ic_launcher_christmas.png        (48x48 pixels)
│   ├── ic_launcher_christmas_light.png  (48x48 pixels)
│   └── ic_launcher_christmas_dark.png   (48x48 pixels)
├── mipmap-hdpi/
│   ├── ic_launcher_christmas.png        (72x72 pixels)
│   ├── ic_launcher_christmas_light.png  (72x72 pixels)
│   └── ic_launcher_christmas_dark.png   (72x72 pixels)
├── mipmap-xhdpi/
│   ├── ic_launcher_christmas.png        (96x96 pixels)
│   ├── ic_launcher_christmas_light.png  (96x96 pixels)
│   └── ic_launcher_christmas_dark.png   (96x96 pixels)
├── mipmap-xxhdpi/
│   ├── ic_launcher_christmas.png        (144x144 pixels)
│   ├── ic_launcher_christmas_light.png  (144x144 pixels)
│   └── ic_launcher_christmas_dark.png   (144x144 pixels)
├── mipmap-xxxhdpi/
│   ├── ic_launcher_christmas.png        (192x192 pixels)
│   ├── ic_launcher_christmas_light.png  (192x192 pixels)
│   └── ic_launcher_christmas_dark.png   (192x192 pixels)
```

#### 2. Configure AndroidManifest.xml

Add activity-aliases for each alternate icon:

```xml
<application ...>
    <!-- Main Activity -->
    <activity
        android:name=".MainActivity"
        android:exported="true"
        android:icon="@mipmap/ic_launcher">
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity>

    <!-- Christmas Icon Alias -->
    <activity-alias
        android:name=".christmas"
        android:enabled="false"
        android:exported="true"
        android:icon="@mipmap/ic_launcher_christmas"
        android:targetActivity=".MainActivity">
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity-alias>

    <!-- Christmas Light Icon Alias -->
    <activity-alias
        android:name=".christmas_light"
        android:enabled="false"
        android:exported="true"
        android:icon="@mipmap/ic_launcher_christmas_light"
        android:targetActivity=".MainActivity">
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity-alias>

    <!-- Christmas Dark Icon Alias -->
    <activity-alias
        android:name=".christmas_dark"
        android:enabled="false"
        android:exported="true"
        android:icon="@mipmap/ic_launcher_christmas_dark"
        android:targetActivity=".MainActivity">
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity-alias>
</application>
```

## API Reference

### SeasonalIcon

| Property        | Type       | Description                              |
|-----------------|------------|------------------------------------------|
| `iconName`      | `String`   | Unique identifier matching native config |
| `eventName`     | `String`   | Human-readable event name                |
| `startDate`     | `DateTime` | When the icon becomes active             |
| `endDate`       | `DateTime` | When the icon stops being active         |
| `lightIconName` | `String?`  | Optional light mode variant              |
| `darkIconName`  | `String?`  | Optional dark mode variant               |

### SeasonalAppIcon

| Method                                  | Description                      |
|-----------------------------------------|----------------------------------|
| `configure(List<SeasonalIcon>) -> void`                         | Set up seasonal icons            |
| `applySeasonalIcon({bool? isDarkMode}) -> Future<IconChangeResult>` | Apply icon based on current date |
| `setIcon(String) -> Future<IconChangeResult>`                  | Set a specific icon              |
| `resetToDefaultIcon() -> Future<IconChangeResult>`             | Reset to default icon            |
| `getCurrentIcon() -> Future<String?>`                          | Get current icon name            |
| `supportsAlternateIcons() -> Future<bool>`                     | Check platform support           |
| `getAvailableIcons() -> Future<List<String>>`                  | List available icons             |

## Quick Reference

| Platform | Icon Location      | Identifier Mapping                       |
|----------|--------------------|------------------------------------------|
| iOS      | `ios/Runner/*.png` | Key name in `CFBundleAlternateIcons`     |
| Android  | `res/mipmap-*/`    | Activity-alias name (e.g., `.christmas`) |

## Platform Response Contract

`IconChangeResult.fromMap` expects these keys from platform implementations:

- `success` (`bool`)
- `iconName` (`String?`) for successful responses
- `error` (`String?`) or `errorMessage` (`String?`) for failure responses

Example:

```dart
{
  'success': true,
  'iconName': 'christmas',
}
```

```dart
{
  'success': false,
  'error': 'Alternate icons are not supported on this device',
}
```

## Date Range Semantics

- `SeasonalIcon.startDate` and `SeasonalIcon.endDate` are inclusive.
- The comparison is moment-based (`DateTime`), not automatic end-of-day handling.
- If you want "active through end of day", pass an `endDate` at the end of that day (for example, `23:59:59.999`).

## Known Limitations

- **iOS**: Icon changes show a system alert (iOS limitation)
- **Android**: Icon changes may take a moment to reflect in the launcher
- **macOS/Windows**: Alternate app icon switching is not supported by this plugin
- Icons must be pre-configured in native projects before use
- Pass icon **identifiers** in Dart code, not file paths

## Status

> ⚠️ **Early Release**: This is the first version of the plugin. It works on both Android and iOS but is not 100% stable yet and needs more work. Use with caution in production environments.

## Contributing

Contributions are welcome! If you'd like to help improve this plugin:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

If you find this plugin helpful, consider:

- Giving it a ⭐ on GitHub
- Reporting bugs or suggesting features via [Issues](../../issues)
- Contributing code or documentation improvements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
