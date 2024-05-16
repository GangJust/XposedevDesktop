import 'dart:convert';

typedef DeepRunnable = Future<void> Function(dynamic data, int deep);

class JsonDeepUtils {
  /// 格式化json字符串
  /// [str] json字符串
  /// [indies] 缩进空格数
  static String deepToString(String str, int indies) {
    try {
      var list = json.decode(str);
      return _deepToString(list, indies, 1);
    } catch (e) {
      return "";
    }
  }

  static String _getDeepSpace(int indies, int deep) {
    return " " * (indies * deep);
  }

  static String _deepToString(dynamic data, int indies, int deep) {
    if (data is List) {
      return _listToString(data, indies, deep);
    } else if (data is Map) {
      return _mapToString(data, indies, deep);
    } else if (data is String) {
      return '"$data"';
    } else if (data is num || data is bool) {
      return data.toString();
    } else {
      return "null";
    }
  }

  static String _listToString(List list, int indies, int deep) {
    var buffer = StringBuffer();
    if (list.isEmpty) {
      buffer.write("[");
      buffer.write("]");
    } else {
      buffer.write('[\n');
      for (var i = 0; i < list.length; i++) {
        buffer.write(_getDeepSpace(indies, deep));
        buffer.write(_deepToString(list[i], indies, deep + 1));
        if (i != list.length - 1) {
          buffer.write(",\n");
        } else {
          buffer.write("\n");
        }
      }
      buffer.write(_getDeepSpace(indies, deep - 1));
      buffer.write("]");
    }
    return buffer.toString();
  }

  static String _mapToString(Map map, int indies, int deep) {
    var buffer = StringBuffer();
    if (map.isEmpty) {
      buffer.write("{");
      buffer.write("}");
    } else {
      buffer.write("{\n");
      var keys = map.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        buffer.write(_getDeepSpace(indies, deep));
        buffer.write('"${keys[i]}": ');
        buffer.write(_deepToString(map[keys[i]], indies, deep + 1));
        if (i != keys.length - 1) {
          buffer.write(",\n");
        } else {
          buffer.write("\n");
        }
      }
      buffer.write(_getDeepSpace(indies, deep - 1));
      buffer.write("}");
    }
    return buffer.toString();
  }

  /// 层级遍历json，每次遍历都将回调
  static void deepRunnable(String str, DeepRunnable function) async {
    try {
      var list = json.decode(str);
      _deepRunnable(list, 0, function);
    } catch (e) {
      await function(str, -1);
    }
  }

  static void _deepRunnable(dynamic data, int deep, DeepRunnable function) async {
    await function(data, deep);
    if (data is List) {
      for (var i = 0; i < data.length; i++) {
        _deepRunnable(data[i], deep + 1, function);
      }
    } else if (data is Map) {
      var keys = data.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        _deepRunnable(data[keys[i]], deep + 1, function);
      }
    }
  }
}
