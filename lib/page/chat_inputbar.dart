import 'package:chat_hub/main.dart';
import 'package:chat_hub/page/chat_controller.dart';
import 'package:chat_hub/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:get/get.dart';

class ChatInputbar extends StatelessWidget {

  Logger get log => Logger("ChatInputbar");

  ChatController get chatController => Get.put(ChatController());

  final ValueChanged? onSubmitText;

  final ChatPage chatPage;

  final TextEditingController messageController;
  
  ChatInputbar({this.onSubmitText, required this.chatPage, required this.messageController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: appBgColor,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.elliptical(25, 25),
          //   topRight: Radius.elliptical(25, 25),
          //   bottomLeft: Radius.elliptical(0, 0),
          //   bottomRight: Radius.elliptical(0, 0),
          // ),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(0),
        child: textInputBar(context)
      ),
    );
  }

  Widget textInputBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38, 
          width: 0.5,
          style: BorderStyle.solid
        ),
        color: Colors.black38,
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      child: Stack(
        alignment:Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          textInputField(context),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
            alignment: Alignment.bottomRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                chatPage.chatIcon(),
                SizedBox(width: 10),
                chatPage.imageIcon(),
                SizedBox(width: 15),
                sendButton()
              ],
            )
          ),
          SizedBox(height: 6)
        ]
      )
    );
  }

  Widget textInputField(BuildContext context) {
    return TextField(
        cursorColor: Colors.white24,
        controller: messageController,
        autofocus: true,
        style: const TextStyle(
          fontSize: 18, 
          color: Colors.white70
        ),
        // 设置键盘按钮为发送
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        onChanged: (text){
          chatController.lastMessage.value = text;
        },
        onEditingComplete: (){
          chatController.lastMessage.value = messageController.text;
        },
        decoration: const InputDecoration(
          hintText: "",
          hintStyle: TextStyle(
            fontSize: 18, 
            color: Colors.white24
          ),
          isDense: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          border: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        minLines: 5,
        maxLines: 5,
      );
  }

  Widget sendButton() {
    return Obx(()=>AnimatedContainer(
      padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
      duration: Duration(milliseconds: 120),
      width: chatController.lastMessage.value.isNotEmpty ? 36 : 0,
      child: chatController.lastMessage.value.isNotEmpty 
        ? chatPage.tapIcon(Icons.send, onTap:() {
            if (chatController.lastMessage.value.isNotEmpty && onSubmitText!=null) {
              onSubmitText!(messageController.text);
            }
          },
          color: Colors.red
        )
        : SizedBox()
      )
    );
  }
}