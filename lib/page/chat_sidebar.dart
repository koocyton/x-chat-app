import 'package:chat_hub/main.dart';
import 'package:chat_hub/page/chat_controller.dart';
import 'package:chat_hub/widget/scroll_utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:get/get.dart';

class ChatSetbar extends StatelessWidget {

  Logger get log => Logger("ChatSetbar");

  ChatController get chatController => Get.put(ChatController());

  const ChatSetbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: FastBouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10, appTopHeight + 20, 10, 20),
      children: [
        oneSet(iconData:Icons.payment_outlined, title:"充值"),
        oneSet(iconData:Icons.attach_money_outlined, title:"余额"),
        Divider(color: Colors.black26, height: 1, indent: 10, endIndent: 10),
        SizedBox(height: 40),
        oneSet(
          iconData:Icons.apps_outlined, 
          title:"插件", 
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          extendChild: GestureDetector(
            onTap: (){
            },
            child: Container(
              width: 20,
              height: 20,
              color: Colors.transparent,
              child:Icon(Icons.edit_outlined, size:22, color: Colors.grey)
            )
          )
        ),
        apps()
      ],
    );
  }

  Widget oneSet({required IconData iconData,
                required String title, 
                Function? onTap, 
                EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 0, 40), 
                Widget extendChild = const SizedBox()}) {
    return GestureDetector(
      onTap: (){
        if (onTap!=null) {
          onTap();
        }
      },
      child:Container(
        padding: padding,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Center(child:Icon(iconData, size:22, color: Colors.black54)),
            SizedBox(width: 12),
            Center(child:Text(title, style: TextStyle(color: Colors.black87, fontSize: 14))),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: extendChild
              )
            )
          ],
        )
      )
    );
  }

  Widget apps() {
    return GridView(
      shrinkWrap:true,
      physics: FastBouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children:<Widget>[
        addApp(),
        oneApp(Icons.ac_unit),
        oneApp(Icons.airport_shuttle),
        oneApp(Icons.all_inclusive),
        oneApp(Icons.beach_access),
        oneApp(Icons.cake)
      ]
    );
  }

  Widget addApp() {
    return oneApp(Icons.add_outlined, backgroundColor: Colors.grey[200], onTap: (){
    
    });
  }

  Widget oneApp(IconData iconData, {Color? backgroundColor, Function? onTap}) {
    return GestureDetector(
      onTap: (){
        if (onTap!=null) {
          onTap();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.black26, width: 0.5),
          color: backgroundColor,
          borderRadius: new BorderRadius.circular((9.0))
        ),
        child: Icon(iconData, size:30, color: Colors.black54)
      )
    );
  }
}