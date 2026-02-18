import 'package:flutter/material.dart';
import 'package:seasonal_app_icon/seasonal_app_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _seasonalAppIcon = SeasonalAppIcon();
  String? _currentIcon;
  bool _supportsAlternateIcons = false;
  List<String> _availableIcons = [];
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initPlugin();
  }

  Future<void> _initPlugin() async {
    // Configure seasonal icons
    _seasonalAppIcon.configure([
      SeasonalIcon(
        iconName: 'christmas',
        eventName: 'Christmas',
        startDate: DateTime(DateTime.now().year, 12, 20),
        endDate: DateTime(DateTime.now().year, 12, 31),
      ),
    ]);

    // Set up callback
    _seasonalAppIcon.onIconChanged = (result) {
      setState(() {
        _statusMessage = _formatChangeResult(result);
      });
    };

    // Load initial state
    await _refreshState();
  }

  Future<void> _refreshState() async {
    final supports = await _seasonalAppIcon.supportsAlternateIcons();
    final current = await _seasonalAppIcon.getCurrentIcon();
    final available = await _seasonalAppIcon.getAvailableIcons();

    if (!mounted) return;

    setState(() {
      _supportsAlternateIcons = supports;
      _currentIcon = current;
      _availableIcons = available;
    });
  }

  Future<void> _applySeasonalIcon() async {
    final result = await _seasonalAppIcon.applySeasonalIcon();
    await _refreshState();
    setState(() {
      if (result.success) {
        final activeIcon = _seasonalAppIcon.getActiveSeasonalIcon();
        _statusMessage = activeIcon != null
            ? 'Applied ${activeIcon.eventName} icon - ${_formatChangeResult(result)}'
            : 'No seasonal icon active, reset to default - ${_formatChangeResult(result)}';
      } else {
        _statusMessage = _formatChangeResult(result);
      }
    });
  }

  Future<void> _setIcon(String iconName) async {
    final result = await _seasonalAppIcon.setIcon(iconName);
    await _refreshState();
    if (!mounted) return;
    setState(() {
      _statusMessage = _formatChangeResult(result);
    });
  }

  Future<void> _resetToDefault() async {
    final result = await _seasonalAppIcon.resetToDefaultIcon();
    await _refreshState();
    if (!mounted) return;
    setState(() {
      _statusMessage = _formatChangeResult(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeSeasonalIcon = _seasonalAppIcon.getActiveSeasonalIcon();

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Seasonal App Icon'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Supports Alternate Icons: $_supportsAlternateIcons',
                      ),
                      Text('Current Icon: ${_currentIcon ?? "default"}'),
                      if (activeSeasonalIcon != null)
                        Text(
                          'Active Event: ${activeSeasonalIcon.eventName}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      if (_statusMessage.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _statusMessage,
                          style: TextStyle(
                            color: _statusMessage.startsWith('Error')
                                ? Colors.red
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions
              ElevatedButton.icon(
                onPressed: _applySeasonalIcon,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Apply Seasonal Icon'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _resetToDefault,
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Default'),
              ),
              const SizedBox(height: 16),

              // Configured Seasonal Icons
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configured Seasonal Icons',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._seasonalAppIcon.seasonalIcons.map(
                        (icon) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            icon.isActive
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: icon.isActive ? Colors.green : Colors.grey,
                          ),
                          title: Text(icon.eventName),
                          subtitle: Text(
                            '${_formatDate(icon.startDate)} - ${_formatDate(icon.endDate)}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _setIcon(icon.iconName),
                            child: const Text('Set'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Available Icons from Platform
              if (_availableIcons.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Platform Icons',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableIcons
                              .map(
                                (icon) => ActionChip(
                                  label: Text(icon),
                                  onPressed: () => _setIcon(icon),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _formatChangeResult(IconChangeResult result) {
    if (result.success) {
      return 'IconChangeResult.success(iconName: ${result.iconName ?? "default"})';
    }
    return 'IconChangeResult.failure(error: ${result.errorMessage ?? "Unknown error"})';
  }
}
