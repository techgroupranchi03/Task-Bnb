class AppDateFormatter {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  /// Parses a DateTime or ISO date string into a DateTime object.
  static DateTime? parseDate(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input;
    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return null;
      try {
        return DateTime.parse(trimmed).toLocal();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Formats a DateTime or ISO date string into `d MMM yyyy` (e.g. `3 Apr 2026`).
  static String formatDate(dynamic input) {
    final dt = parseDate(input);
    if (dt == null) return '';
    final monthName = _months[dt.month - 1];
    return '${dt.day} $monthName ${dt.year}';
  }

  /// Formats last login string as `Last login 3 Apr 2026` or `Never logged in`.
  static String formatLastLogin(String? lastLoginStr) {
    if (lastLoginStr == null || lastLoginStr.trim().isEmpty) {
      return 'Never logged in';
    }
    final formatted = formatDate(lastLoginStr);
    if (formatted.isEmpty) {
      return 'Never logged in';
    }
    return 'Last login $formatted';
  }
}
