import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {

  test('config test', (){
    String requestHeader = "[{\"token\":\"bbb\"}]";
    String requestUrl = "https://askfalfjfl.afaflsafa.dfd";
    String requestRequestBody = "";
    String bodyKeyIndex = "data.0.body";
    // List<String> keyList = bodyKeyIndex.split(".");
    dynamic bodyResult = const JsonDecoder().convert("{\"data\": [{\"body\":\"hello2\"}]}");
    print(bodyResult["data"][0]["body"]);
  });
}
