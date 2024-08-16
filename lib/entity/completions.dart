import 'dart:convert';

class CompletionsUsage{
  int? prompt_tokens;
  int? completion_tokens;
  int? total_tokens;

  static CompletionsUsage fromDynamic(dynamic dyn) {
    CompletionsUsage u = CompletionsUsage();
    u.prompt_tokens = dyn["prompt_tokens"]??0;
    u.completion_tokens = dyn["completion_tokens"]??0;
    u.total_tokens = dyn["total_tokens"]??0;
    return u;
  }
}

class CompletionsChoice{
  CompletionsMessage? message;
  String? finish_reason;
  int? index;

  static List<CompletionsChoice> listFromDynamic(List<dynamic> dyn) {
    List<CompletionsChoice> cl = [];
    for (dynamic choiceDyn in dyn) {
      CompletionsChoice choice = CompletionsChoice();
      choice.message = CompletionsMessage.fromDynamic(choiceDyn["message"]);
      choice.finish_reason = choiceDyn["finish_reason"]??"";
      choice.index = choiceDyn["index"]??0;
      cl.add(choice);
    }
    return cl;
  }
}

class CompletionsMessage{
  String? role;
  String? content;

  static CompletionsMessage fromDynamic(dynamic dyn) {
    CompletionsMessage u = CompletionsMessage();
    u.role = dyn["role"]??"";
    u.content = dyn["content"]??"";
    return u;
  }
}

class Completions {
   String? id;
   String? object;
   int? created;
   String? model;
   CompletionsUsage? usage;
   List<CompletionsChoice> choices = List.empty();

   static Completions? fromJson(String? json) {
     if (json==null) {
      return null;
     }
     dynamic mapData = const JsonDecoder().convert(json);
     if (mapData==null) {
        return null;
     }
     Completions c = Completions();
     c.id = mapData["id"]??"";
     c.object = mapData["object"]??"";
     c.created = mapData["created"]??0;
     c.model = mapData["model"]??"";
     c.usage = CompletionsUsage.fromDynamic(mapData["usage"]);
     c.choices = CompletionsChoice.listFromDynamic(mapData["choices"]);
     return c;
   }
}