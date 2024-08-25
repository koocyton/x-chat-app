import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {

  test('config test', (){
    String bodyKeyIndex = "data.0.body";
    // List<String> keyList = bodyKeyIndex.split(".");
    dynamic bodyResult = const JsonDecoder().convert("{\"data\": [{\"body\":\"hello2\"}]}");
    print(bodyResult["data"][0]["body"]);
  });
}
