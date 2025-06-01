import 'package:easy_localization/easy_localization.dart';
import 'constants_utils/app_strings.constants.dart';

abstract class DateTimeUtils {
  /// Format: yyyy-MM-dd
  static String formatDate(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('yyyy-MM-dd', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: dd/MM/yyyy
  static String formatReadableDate(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('dd/MM/yyyy', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: hh:mm a (e.g., 03:45 PM)
  static String formatTime12Hour(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('hh:mm a', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: HH:mm (e.g., 15:45)
  static String formatTime24Hour(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('HH:mm', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: yyyy-MM-dd HH:mm:ss
  static String formatFullDateTime(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: EEE, dd MMM yyyy (e.g., Mon, 06 Apr 2025)
  static String formatShortWeekdayDate(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('EEE, dd MMM yyyy', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: MMMM dd, yyyy (e.g., April 06, 2025)
  static String formatLongDate(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('MMMM dd, yyyy', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Format: relative time (e.g., "3 days ago", "in 2 hours")
  static String formatRelative(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return AppStrings.justNow.tr();
      } else if (difference.inMinutes < 60) {
        return AppStrings.minutesAgo.tr(
          namedArgs: {'count': difference.inMinutes.toString()},
        );
      } else if (difference.inHours < 24) {
        return AppStrings.hoursAgo.tr(
          namedArgs: {'count': difference.inHours.toString()},
        );
      } else if (difference.inDays < 7) {
        return AppStrings.daysAgo.tr(
          namedArgs: {'count': difference.inDays.toString()},
        );
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return AppStrings.weeksAgo.tr(namedArgs: {'count': weeks.toString()});
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return AppStrings.monthsAgo.tr(namedArgs: {'count': months.toString()});
      } else {
        return formatReadableDate(dateTime, locale: locale);
      }
    } catch (e) {
      return '';
    }
  }

  static String formatRelativeShort(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return AppStrings.justNow.tr();
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}${AppStrings.minutesShort.tr()}';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}${AppStrings.hoursShort.tr()}';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}${AppStrings.daysShort.tr()}';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks${AppStrings.weeksShort.tr()}';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months${AppStrings.monthsShort.tr()}';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years${AppStrings.yearsShort.tr()}';
      }
    } catch (e) {
      return '';
    }
  }

  /// Parse string to DateTime with format
  static DateTime? parse(
    String? dateString, {
    String format = 'yyyy-MM-dd',
    String? locale,
  }) {
    if (dateString == null) return null;
    try {
      return DateFormat(format, locale).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Format: dd MMM yyyy, hh:mm a (e.g., 06 Apr 2025, 03:45 PM)
  static String formatDateTimeWithAmPm(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('dd MMM yyyy, hh:mm a', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Get day name (e.g., Monday, Tuesday)
  static String getDayName(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('EEEE', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Get month name (e.g., January, February)
  static String getMonthName(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return '';
    try {
      return DateFormat('MMMM', locale).format(dateTime);
    } catch (e) {
      return '';
    }
  }

  /// Get ISO String
  static String toIsoString(DateTime? dateTime) {
    if (dateTime == null) return '';
    try {
      return dateTime.toIso8601String();
    } catch (e) {
      return '';
    }
  }

  /// Formate Datetime to utc Formate for api calls
  static String formatDateForApi(DateTime date) {
    final utcDate = DateTime.utc(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
    return utcDate.toIso8601String();
  }

  /// Formate Duration
  static String formatDurationShort(Duration duration, {String? locale}) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];

    if (days > 0) {
      parts.add('$days${AppStrings.daySymbol.tr()}');
    }
    if (hours > 0 || days > 0) {
      parts.add('$hours${AppStrings.hourSymbol.tr()}');
    }
    if (minutes > 0 || parts.isEmpty || hours > 0 || days > 0) {
      parts.add('$minutes${AppStrings.minuteSymbol.tr()}');
    }

    return parts.join(' : ');
  }
}
