import 'dart:convert';

import 'package:xposedev_desktop/utils/json_deep_utils.dart';

class JsonListItem {
  final int index;
  final int deep;
  final Map data;

  JsonListItem(this.index, this.deep, this.data);

  String get title {
    return "${data["className"]}";
  }

  String toSingleJson(int indies) {
    Map map = {};
    data.entries.forEach((element) {
      if (element.value is Map) return;
      if (element.value is List) return;
      map[element.key] = element.value;
    });
    return JsonDeepUtils.deepToString(jsonEncode(map), indies);
  }
}
