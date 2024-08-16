import 'dart:convert';
import 'package:logging/logging.dart';

class JsonUtils {

  static Logger log = Logger("JsonUtils");

  static String toJson(dynamic dyn) {
    return JsonEncoder().convert(dyn);
  }

  static Map<String, dynamic>? jsonToMap(String? json) {
    if (json==null) {
      return null;
    }
    return castMap(const JsonDecoder().convert(json));
  }

  static Map<String, dynamic> castMap(dynamic mapData) {
    Map<String, dynamic> resultMap = {};
    if (mapData!=null && mapData.runtimeType.toString().contains("HashMap")) {
      mapData.forEach((key, value) {
        resultMap[key.toString()] = value;
      });
    }
    return resultMap;
  }

  static List<dynamic>? jsonToList(String? json) {
    if (json==null) {
      return null;
    }
    return castList(const JsonDecoder().convert(json));
  }

  static List<dynamic> castList(dynamic listData) {
    List<dynamic> resultList = [];
    for (dynamic value in listData) {
      resultList.add(value);
    }
    return resultList;
  }

  static List<Map<String, dynamic>>? jsonToMapList(String? json) {
    if (json==null) {
      return null;
    }
    return castMapList(const JsonDecoder().convert(json));
  }

  static List<Map<String, dynamic>> castMapList(dynamic listData) {
    List<Map<String, dynamic>> resultList = [];
    for (var value in listData) {
      resultList.add(castMap(value));
    }
    return resultList;
  }

  static List<List<Map<String, dynamic>>>? jsonToMapLists(String? json) {
    if (json==null) {
      return null;
    }
    return castMapLists(const JsonDecoder().convert(json));
  }

  static List<List<Map<String, dynamic>>> castMapLists(dynamic listData) {
    List<List<Map<String, dynamic>>> resultList = [];
    for (dynamic value in listData) {
      resultList.add(castMapList(value));
    }
    return resultList;
  }

  static List<String>? jsonToStringList(String? json) {
    if (json==null) {
      return null;
    }
    return castStringList(const JsonDecoder().convert(json));
  }

  static List<String> castStringList(dynamic listData) {
    List<String> resultList = [];
    for (dynamic value in listData) {
      resultList.add(value);
    }
    return resultList;
  }
}