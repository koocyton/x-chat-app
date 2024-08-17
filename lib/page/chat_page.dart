import 'package:chat_hub/entity/dialogue.dart';
import 'package:chat_hub/enums/dialogue_type_enum.dart';
import 'package:chat_hub/page/chat_controller.dart';
import 'package:chat_hub/page/chat_sidebar.dart';
import 'package:chat_hub/widget/easy.dart';
import 'package:chat_hub/widget/easy_refresh.dart';
import 'package:chat_hub/widget/easy_sidebar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chat_hub/main.dart';
import 'package:chat_hub/page/chat_inputbar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:logging/logging.dart';
import 'package:chat_hub/widget/spin_kit.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatPage extends StatelessWidget {

  ChatController get chatController => Get.put(ChatController());

  final TextEditingController messageEditingController = TextEditingController();

  Logger get log => Logger("ChatPage");

  ChatPage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: EasySidebar(
        sidebar: const ChatSetbar(),
        childBuild: (_context, _sidebarController){
          return Column(
            children:[
              Container(height:appTopHeight, color:appBgColor),
              Expanded(
                child:GestureDetector(
                  onTap:(){
                    chatController.inputSwitch.value = false;
                    chatController.readyDeleteId.value = 0;
                    chatController.dialogueList.refresh();
                  },
                  child: dialogueList(_context)
                )
              ),
              Obx(()=>AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: chatController.inputSwitch.value ? 148 : 71,
                child: chatController.inputSwitch.value 
                  ? inputBar(_context) 
                  : popupBar(_context, _sidebarController)
                )
              )
            ]
          );
        }
      ),
    );
  }

  Widget popupBar(BuildContext context, EasySidebarController sidebarController) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 3),
      child: Column(
        children:[
          Row(
            children:[
              Container(
                height:50,
                child:operationIcon(context, sidebarController),
              ),
              SizedBox(width:10),
              Expanded(
                child: Container(
                  height:50,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textInput(context),
                      SizedBox(width: 10),
                      chatIcon(),
                      // SizedBox(width: 10),
                      // voiceIcon(),
                      SizedBox(width: 10),
                      imageIcon(),
                      // SizedBox(width: 10),
                      // sdIcon(),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(25)
                  )
                )
              )
            ]
          ),
          SizedBox(height:3)
        ]
      ),
      decoration: BoxDecoration(
        color: appBgColor,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.elliptical(25, 25),
        //   topRight: Radius.elliptical(25, 25),
        //   bottomLeft: Radius.elliptical(0, 0),
        //   bottomRight: Radius.elliptical(0, 0),
        // ),
      )
    );
  }

  Widget inputBar(BuildContext context) {
    return ChatInputbar(
      chatPage:this,
      messageController: messageEditingController,
      onSubmitText: (ask){
        chatController.sendAsk(ask).then((_d){
        });
      }
    );
  }

  Widget dialogueList(BuildContext context) {
    return easyRefresh(
      onRefresh: (){
        chatController.loadMoreDialogue();
      },
      childBuilder:(_context, _physics) { 
        return Obx(()=>ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          physics: _physics,
          controller: chatController.dialogueScrollController,
          itemCount: chatController.dialogueList.length + 1,
          itemBuilder: (context, ii){
            if (ii>=chatController.dialogueList.length) {
              return copyRight();
            }
            return dialogue(context, chatController.dialogueList[ii]);
          }
        ));
      }
    );
  }

  Widget dialogue(BuildContext context, Dialogue dialogue) {
    return Column(
      children:[
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color:Colors.black26,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              dialogueFace(dialogue.askUser),
              SizedBox(width: 8),
              dialogueAsk(dialogue)
            ]
          )
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color:Color(0x02FFFFFF),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              dialogueFace(dialogue.replyUser),
              SizedBox(width: 8),
              dialogueReply(dialogue)
            ]
          )
        )
      ]
    );
  }

  Widget dialogueFace(String name) {
    return Container(
      alignment: Alignment.topCenter,
      width: appWidth * 0.1,
      height: appWidth * 0.1,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          name, 
          style:TextStyle(
            color:Colors.white70,
            fontSize: appWidth * 0.05
          )
        ),
        decoration: BoxDecoration(
          color:Colors.white12,
          borderRadius: BorderRadius.circular(appWidth * 0.05)
        )
      )
    );
  }

  Widget dialogueAsk(Dialogue dialogue) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        alignment: Alignment.centerLeft,
        child: Text(
          dialogue.ask, 
          style: TextStyle(
            color: Colors.white70,
            fontSize: appWidth * 0.04,
          )
        )
      )
    );
  }

  Widget dialogueReply(Dialogue dialogue) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 6, 3),
        alignment: Alignment.centerLeft,
        child: dialogue.reply==""
         ? loadingReply(dialogue)
         : dialogue.type == DailogueTypeEnum.IMAGE.name
          ? dialogueImageReply(dialogue)
          : dialogueChatReply(dialogue)
      )
    );
  }

  Widget loadingReply(Dialogue dialogue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpinKit.cubeGrid(size: 20, color:appFgColor),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            deleteIcon(dialogue),
            SizedBox(width: 16)
          ],
        )
      ]
    );
  }

  Widget dialogueImageReply(Dialogue dialogue) {
    // images
    List<Widget> children = [];
    dialogue.reply.split(";").reversed.forEach((url) {
      children.add(Easy.image(url, width: appWidth*0.8));
      children.add(SizedBox(height: 15));
    });
    children.add(userOperation(dialogue));
    // box
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
    );
  }

  Widget dialogueChatReply(Dialogue dialogue) {
    return chatController.receiveDialogueId==dialogue.id
      ? DefaultTextStyle(
        style: TextStyle(
          color: Colors.white70,
          fontSize: appWidth * 0.04,
        ),
        child: AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            TypewriterAnimatedText(dialogue.reply, speed: Duration(milliseconds: 100)),
          ],
          onTap:() {
            chatController.receiveDialogueId = 0;
            chatController.dialogueList.refresh();
            chatController.scrollToBottom();
          },
          onFinished: (){
            chatController.receiveDialogueId = 0;
            chatController.dialogueList.refresh();
            chatController.scrollToBottom();
          },
        ),
      )
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            MarkdownBody(
              selectable: true,
              data: dialogue.reply,
              styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
              styleSheet: MarkdownStyleSheet(
                a:TextStyle(color: Colors.white70),
                p:TextStyle(color: Colors.white70),
                code:TextStyle(color: Colors.black87),
                h1:TextStyle(color: Colors.white70),
                h2:TextStyle(color: Colors.white70)
              ),
            ),
            // Text(
            //   dialogue.reply, 
            //   style: TextStyle(
            //     color: Colors.white70,
            //     fontSize: appWidth * 0.04,
            //   )
            // ),
            SizedBox(height: 15),
            userOperation(dialogue)
          ]
        );
  }

  Widget textInput(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          chatController.inputSwitch.value = true;
          messageEditingController.text = chatController.lastMessage.value;
        },
        child: Container(
          // height: 50,
          alignment: Alignment.centerLeft,
          color: Colors.transparent,
          child: Obx((){
            return Text(
              chatController.shortAsk(), 
              style: TextStyle(
                fontSize: 18, 
                color: Colors.white24
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
                leading: 0.5,
              )
            );
        })
      )
    ));
  }

  Widget userOperation(Dialogue dialogue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        shareIcon(dialogue),
        SizedBox(width: 16),
        copyIcon(dialogue),
        SizedBox(width: 16),
        deleteIcon(dialogue),
        SizedBox(width: 16)
      ],
    );
  }

  Widget shareIcon(Dialogue dialogue) {
    return Transform.scale(
      scaleX: -1,
      child: tapIcon(
        Icons.reply_outlined, 
        size: 22,
        onTap: (){
          Easy.share(dialogue.ask + "\n  " +  dialogue.reply);
        }
      ),
    );
  }

  Widget copyIcon(Dialogue dialogue) {
    return tapIcon(
      Icons.copy_outlined,
      size: 18,
      onTap: () {
        Clipboard.setData(ClipboardData(text: dialogue.ask + "\n  " +  dialogue.reply)).then((v){
          Easy.showBottomToast(
            "copy successfully", 
            duration: Duration(milliseconds: 2000)
          );
        });
      });
  }

  Widget thumbDownIcon() {
    return tapIcon(Icons.thumb_down_outlined, size: 19);
  }

  Widget thumbUpIcon() {
    return tapIcon(Icons.thumb_up_outlined, size: 19);
  }

  Widget deleteIcon(Dialogue dialogue) {
    return tapIcon(
      chatController.readyDeleteId.value==dialogue.id ? Icons.delete : Icons.delete_outline,
      size: 22,
      color: chatController.readyDeleteId.value==dialogue.id ?  Colors.red : Colors.white24,
      onTap: () {
        if (chatController.readyDeleteId.value == dialogue.id) {
          chatController.deleteDialogue(dialogue.id);
          return;
        }
        chatController.readyDeleteId.value = dialogue.id;
        chatController.dialogueList.refresh();
      }
    );
  }

  Widget operationIcon(BuildContext context, EasySidebarController sidebarController) {
    return tapIcon(
      Icons.sort_outlined,
      onTap:() {
        sidebarController.switchOperation();
      },
      color: sidebarController.isOperation() ? Colors.green : Colors.white24
    );
  }

  Widget chatIcon() {
    return tapIcon(
      Icons.chat_outlined,
      onTap:() {
        chatController.clickChatOnce();
      },
      color: chatController.isChatAsk() ? Colors.green : Colors.white24
    );
  }

  Widget voiceIcon() {
    return tapIcon(
      Icons.graphic_eq_outlined,
      onTap:() {
        chatController.clickVoiceOnce();
      },
      color: chatController.isVoiceAsk() ? Colors.green : Colors.white24
    );
  }

  Widget imageIcon() {
    return tapIcon(
      Icons.panorama_outlined,
      onTap:() {
        chatController.clickImageOnce();
      },
      color: chatController.isImageAsk() ? Colors.green : Colors.white24
    );
  }

  Widget cameraIcon() {
    return tapIcon(Icons.camera_outlined);
  }

  Widget sdIcon() {
    return tapIcon(
      Icons.sd_outlined,
      onTap:() {
        chatController.clickSdOnce();
      },
      color: chatController.isSdAsk() ? Colors.green : Colors.white24
    );
  }

  Widget tapIcon(IconData iconData, {Function? onTap, Color color=Colors.white24, double size = 30}) {
    return GestureDetector(
      onTap: () {
        if (onTap!=null) {
          onTap();
        }
      },
      child: Container(
        height: size + 4,
        width: size + 4,
        color:Colors.transparent,
        alignment: Alignment.center,
        child: Icon(
          iconData, 
          size: size, 
          color: color
        ),
      )
    );
  }

  Widget netQuery() {
    return Container(
      alignment: Alignment.center,
      child: SpinKit.threeBounce(size: 20, color:appFgColor)
    );
  }

  Widget copyRight() {
    return Container(
      alignment: Alignment.center,
      child:Text(
        "ChatGPT 3.5", 
        style: TextStyle(
          fontSize: 12, 
          color: Color(0x1FFFFFFF)
        ),
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
          leading: 0.5,
        )
      )
    );
  }
}
