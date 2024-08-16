import 'package:chat_hub/config/static.dart';
import 'package:chat_hub/entity/completions.dart';
import 'package:chat_hub/entity/generations.dart';
import 'package:chat_hub/utils/http_utils.dart';
import 'package:logging/logging.dart';

class ChatApiService {

  static Logger log = Logger("ChatApiService");

  static Future<String> processAsk(Future<String> Function() launcher, Future<String> Function() listener, Future<String> Function() complete) {
    return launcher()
      .then((a)async{
        return await listener();
      })
      .then((b)async{
        return await complete();
      });
  }

  static Future<Generations?> sdText2Img(String ask) {
    Map<String, dynamic> postData = {
      "prompt": ask,
      "n": 2,
      "size": "1024x1024"
    };
    return _SdApiPost(Static.plugins[0].jobStartApi, postData)
      .then((response){
        return Generations.fromJson(response);
    });
  }

  static Future<Generations?> sdProcess(String ask) {
    return _SdApiGet(Static.plugins[0].jobProcessApi)
      .then((response){
        return Generations.fromJson(response);
    });
  }

  static Future<Generations?> imagesGenerations(String ask) {
    Map<String, dynamic> postData = {
      "prompt": ask,
      "n": 2,
      "size": "1024x1024"
    };
    return _ChatApiPost(Static.apiImagesGenerations, postData)
      .then((response){
        return Generations.fromJson(response);
    });
  }

  static Future<Completions?> chatCompletions(String ask) {
    Map<String, dynamic> postData = {
      "model": "gpt-3.5-turbo",
      "messages": [{"role": "user", "content": ask}],
      "temperature": 0.7
    };
    return _ChatApiPost(Static.apiChatCompletions, postData)
      .then((response){
        return Completions.fromJson(response);
    });
  }

  static Future<String?> _ChatApiPost(String url, dynamic postData) {
    Map<String, String> headerMap = {
      "Content-Type": "application/json;charset=UTF-8",
      "Authorization": "Bearer ${Static.chatApiKey}"
    };
    return HttpUtils.stringPost(
      url,
      postData: postData,
      headerMap: headerMap
    ).then((text){
      return text;
    });
  }

  static Future<String?> _SdApiPost(String url, dynamic postData) {
    Map<String, String> headerMap = {
      "Content-Type": "application/json;charset=UTF-8"
    };
    return HttpUtils.stringPost(
      url,
      postData: postData,
      headerMap: headerMap
    ).then((text){
      return text;
    });
  }

  static Future<String?> _SdApiGet(String url) {
    Map<String, String> headerMap = {
      "Content-Type": "application/json;charset=UTF-8"
    };
    return HttpUtils.stringGet(
      url,
      headerMap: headerMap
    ).then((text){
      return text;
    });
  }
}
