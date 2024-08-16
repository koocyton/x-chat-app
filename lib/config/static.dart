import 'package:chat_hub/entity/plugin.dart';

class Static {

  static String get chatApiHost => "https://api.openai.com";

  static String get chatApiKey => "";

  static String get apiChatCompletions => "$chatApiHost/v1/chat/completions";

  static String get apiImagesGenerations => "$chatApiHost/v1/images/generations";

  static List<Plugin> get plugins => [
    Plugin()
      ..pluginName="Stable diffusion"
      ..jobStartApi="http://10.12.61.61:7861/sdapi/v1/txt2img"
      ..jobCompleteApi="http://10.12.61.61:7861/sdapi/v1/process"
      ..jobProcessApi="http://10.12.61.61:7861/sdapi/v1/process"
  ];
}
