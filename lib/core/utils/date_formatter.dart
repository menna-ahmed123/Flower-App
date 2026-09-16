const _shortMonthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

extension DateFormatter on DateTime {
  /// Formats this date as "d MMM yyyy" without pulling in the intl package.
  String toShortDate() => '$day ${_shortMonthNames[month - 1]} $year';
}
