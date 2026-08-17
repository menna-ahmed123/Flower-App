import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Locale-aware presentation formatters for dates, times, numbers, and currency.
///
/// Use these only for UI display. Do not alter API/domain values.
abstract final class AppFormatters {
  static String date(DateTime value, Locale locale, {String? pattern}) {
    final format = pattern == null
        ? DateFormat.yMMMd(locale.toString())
        : DateFormat(pattern, locale.toString());
    return format.format(value);
  }

  static String time(DateTime value, Locale locale, {String? pattern}) {
    final format = pattern == null
        ? DateFormat.jm(locale.toString())
        : DateFormat(pattern, locale.toString());
    return format.format(value);
  }

  static String dateTime(DateTime value, Locale locale) {
    return DateFormat.yMMMd(locale.toString()).add_jm().format(value);
  }

  static String weekday(DateTime value, Locale locale) {
    return DateFormat.EEEE(locale.toString()).format(value);
  }

  static String month(DateTime value, Locale locale) {
    return DateFormat.MMMM(locale.toString()).format(value);
  }

  static String number(num value, Locale locale) {
    return NumberFormat.decimalPattern(locale.toString()).format(value);
  }

  static String percent(num value, Locale locale) {
    return NumberFormat.percentPattern(locale.toString()).format(value);
  }

  static String currency(
    num value,
    Locale locale, {
    String? symbol,
    String? name,
    int? decimalDigits,
  }) {
    return NumberFormat.currency(
      locale: locale.toString(),
      symbol: symbol,
      name: name,
      decimalDigits: decimalDigits,
    ).format(value);
  }
}
