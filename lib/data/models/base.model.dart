class BaseModel {
  // Safe parse for int values with error handling and nullability
  static int? parseInt(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Safe parse for double values with error handling and nullability
  static double? parseDouble(dynamic value) {
    try {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Safe parse for num values with error handling and nullability
  static num? parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  // Safe parse for string values with error handling and nullability
  static String? parseString(dynamic value) {
    try {
      return value?.toString();
    } catch (_) {}
    return null;
  }

  // Safe parse for DateTime values with error handling and nullability
  static DateTime? parseDateTime(dynamic value) {
    try {
      if (value == null) return null;
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        return parsed?.toLocal();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Safe parse for boolean values with error handling and nullability
  static bool? parseBool(dynamic value) {
    try {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase().trim() == 'true';
      if (value is int) return value != 0;
      return null;
    } catch (e) {
      return null;
    }
  }

  // Safe toJson method for lists of models with error handling
  static List<T> parseList<T>({
    required dynamic data,
    required T Function(Map<String, dynamic>?) fromJson,
  }) {
    try {
      if (data == null) return <T>[];
      if (data is List) {
        return data.map((e) => fromJson(e)).toList();
      }
    } catch (_) {
      return <T>[];
    }
    return <T>[];
  }

  /// Helper: Parse List(String)
  static List<String>? parseStringList(dynamic list) {
    if (list is List) {
      return list.map((e) => e?.toString() ?? '').toList();
    }
    return null;
  }

  /// Helper: Parse List(int)
  static List<int>? parseIntList(dynamic list) {
    if (list is List) {
      return list.map((e) {
        if (e is int) return e;
        if (e is String) return int.tryParse(e) ?? 0;
        return 0;
      }).toList();
    }
    return null;
  }
}
