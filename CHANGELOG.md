## 0.0.2

* Improve API/docs clarity for `IconChangeResult` and method return types
* Document platform response contract and known limitations
* Improve example status logging for success/failure icon change results

## 0.0.1

* Initial release
* Support for changing app icons based on date periods
* Light and dark mode icon variants support
* iOS implementation using `setAlternateIconName`
* Android implementation using activity-alias
* Auto-detection of system brightness for icon selection
* Methods: `configure`, `applySeasonalIcon`, `setIcon`, `resetToDefaultIcon`, `getCurrentIcon`, `supportsAlternateIcons`, `getAvailableIcons`
