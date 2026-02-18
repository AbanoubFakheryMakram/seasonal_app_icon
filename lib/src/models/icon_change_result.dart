/// Result of an icon change operation.
class IconChangeResult {
  /// Whether the icon change was successful.
  final bool success;

  /// The name of the icon that was set (or attempted to set).
  final String? iconName;

  /// Error message if the operation failed.
  final String? errorMessage;

  /// Creates a successful result.
  const IconChangeResult.success(this.iconName)
    : success = true,
      errorMessage = null;

  /// Creates a failed result.
  const IconChangeResult.failure(this.errorMessage)
    : success = false,
      iconName = null;

  /// Creates a result from a map (used for platform channel responses).
  ///
  /// Expected keys:
  /// - `success` (`bool`)
  /// - `iconName` (`String?`) when successful
  /// - `error` (`String?`) or `errorMessage` (`String?`) when failed
  factory IconChangeResult.fromMap(Map<String, dynamic> map) {
    final success = map['success'] as bool? ?? false;
    if (success) {
      return IconChangeResult.success(map['iconName'] as String?);
    } else {
      final error = map['error'] as String? ?? map['errorMessage'] as String?;
      return IconChangeResult.failure(error);
    }
  }

  @override
  String toString() {
    if (success) {
      return 'IconChangeResult.success(iconName: $iconName)';
    }
    return 'IconChangeResult.failure(error: $errorMessage)';
  }
}
