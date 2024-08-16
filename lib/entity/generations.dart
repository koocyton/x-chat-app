import 'dart:convert';
import 'package:logging/logging.dart';

class Generations {

   static Logger log = Logger("Generations"); 

   late int created;
   List<String> urls = [];

   static Generations? fromJson(String? json) {
     if (json==null) {
      return null;
     }
     dynamic mapData = const JsonDecoder().convert(json);
     if (mapData==null) {
        return null;
     }
     Generations c = Generations();
     c.created = mapData["created"]??DateTime.now().millisecondsSinceEpoch;
     for (dynamic dyn in mapData["data"]) {
       if (dyn["url"]!=null && dyn["url"]!="") {
         c.urls.add(dyn["url"]);
       }
     }
     return c;
   }
}