import 'package:chat_hub/entity/completions.dart';
import 'package:chat_hub/entity/dialogue.dart';
import 'package:chat_hub/entity/generations.dart';
import 'package:chat_hub/enums/dialogue_type_enum.dart';
import 'package:chat_hub/main.dart';
import 'package:chat_hub/service/chat_api_service.dart';
import 'package:chat_hub/service/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {

  int currentPage = 0;

  int receiveDialogueId = 0;

  final RxInt readyDeleteId = 0.obs;

  final ScrollController dialogueScrollController = ScrollController();

  final ScrollController operationScrollController = ScrollController(initialScrollOffset: appWidth*0.68);

  final RxList<Dialogue> dialogueList = RxList.empty();

  final RxString askType = DailogueTypeEnum.CHAT.name.obs;

  final RxBool inputSwitch = false.obs;

  final RxString lastMessage = "".obs;

  // final RxBool showOperation = false.obs;

  final double operationWidth = appWidth * 0.68;

  // late Worker _ever;

  @override
  onInit() {
    super.onInit();
    // dialogueScrollController.addListener(() {
    //   if (receiveDialogueId!=0) {
    //     scrollToBottom();
    //   }
    // });
    DBService.getDialogueList(currentPage).then((data){
      if (data.length>0) {
        dialogueList.addAll(data.reversed);
        lastMessage.value = dialogueList.last.ask;
        currentPage++;
      }
      scrollToBottom();
    });
  }

  loadMoreDialogue() {
    DBService.getDialogueList(currentPage).then((data){
      if (data.length>=1) {
        currentPage++;
        dialogueList.insertAll(0, data.reversed);
      }
    });
  }

  deleteDialogue(int id) {
    int? targetIdx;
    int? targetId;
    for(int ii=0; ii<dialogueList.length; ii++) {
      if (id==dialogueList[ii].id) {
        targetIdx = ii;
        targetId = id;
      }
    }
    if (targetIdx!=null && targetId!=null) {
      DBService.deleteDialogue(id);
      dialogueList.removeAt(targetIdx);
    }
  }

  Future<Dialogue?> sendAsk(String ask) {
    // 1. 检索旧 ASK
    return DBService.getDialogue(askType.value, ask).then((__d) async {
      // 2. 插入新的 ASK
      Dialogue _d = await DBService.createDialogueByAsk(askType.value, ask);
      // 3. 如果有旧 ASK
      if (__d!=null) {
        deleteDialogue(__d.id);
        DBService.addDialogueReply(_d, __d.reply);
      }
      return _d;
    })
    .then((_d) async {
      // 当前对话 id
      receiveDialogueId = _d.id;
      // 加入到对话列表
      dialogueList.add(_d);
      // 滑动到底部
      scrollToBottom();
      // 如果没有回复
      if (_d.reply=="") {
        if (_d.type==DailogueTypeEnum.IMAGE.name) {
          // 图片 ASK
          Generations? generations = await ChatApiService.imagesGenerations(ask);
          if (generations!=null && generations.urls.length>0) {
            _d.reply = generations.urls.join(";");
            DBService.addDialogueReply(_d, _d.reply);
          }
        }
        // else if (_d.type==DailogueTypeEnum.SD.name) {
        //   // Stable Diffusion ASK
        //   Generations? generations = await ChatApiService.imagesGenerations(ask);
        //   if (generations!=null && generations.urls.length>0) {
        //     _d.reply = generations.urls.join(";");
        //     DBService.addDialogueReply(_d, _d.reply);
        //   }
        // }
        else {
          // 文字 ASK
          Completions? completions = await ChatApiService.chatCompletions(ask);
          if (completions!=null && completions.choices.length>0) {
            _d.reply = completions.choices[0].message!.content!;
            DBService.addDialogueReply(_d, _d.reply);
          }
        }
      }
      // 刷新界面
      dialogueList.refresh();
      scrollToBottom();
      return _d;
    });
  }

  void receiveReply(Dialogue dialogue, String text) {
    DBService.addDialogueReply(dialogue, text);
    for (int ii=0; ii<dialogueList.length; ii++) {
      if (dialogueList[ii].id==dialogue.id) {
        dialogueList[ii].reply = dialogue.reply = text;
      }
    }
    dialogueList.refresh();
  }

  void clickVoiceOnce() {
    askType.value = DailogueTypeEnum.VOICE.name ;
  }

  void clickImageOnce() {
    askType.value = DailogueTypeEnum.IMAGE.name ;
  }

  void clickSdOnce() {
    askType.value = DailogueTypeEnum.SD.name ;
  }

  void clickChatOnce() {
    askType.value = DailogueTypeEnum.CHAT.name;
  }

  // bool isOperation() {
  //   return showOperation.value;
  // }

  bool isChatAsk() {
    return askType.value==DailogueTypeEnum.CHAT.name;
  }

  bool isVoiceAsk() {
    return askType.value==DailogueTypeEnum.VOICE.name;
  }

  bool isImageAsk() {
    return askType.value==DailogueTypeEnum.IMAGE.name;
  }

  bool isSdAsk() {
    return askType.value==DailogueTypeEnum.SD.name;
  }

  String shortAsk() {
    String lastInputText = lastMessage.value.replaceAll("\n", " ");
    if (lastInputText.length>12) {
      return lastInputText.substring(0, 10) + ".";
    }
    return lastInputText;
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 200), (){
      dialogueScrollController.animateTo(
        dialogueScrollController.position.maxScrollExtent,
        curve: Curves.ease,
        duration: Duration(milliseconds: 400)
      );
    });
  }

  // void switchOperation() {
  //   showOperation.value = !showOperation.value;
  //   operationScrollController.animateTo(
  //     showOperation.value ? 0 : operationWidth, 
  //     duration: Duration(milliseconds: 150), 
  //     curve: Curves.easeOut
  //   );
  // }
}