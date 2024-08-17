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
      physics: const FastBouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10, appTopHeight + 20, 10, 20),
      children: [
        labelView(
          iconData:Icons.payment_outlined,
          title:"充值"
        ),
        labelView(
          iconData:Icons.attach_money_outlined,
          title:"余额", 
          extendChild:const Text("0.19 \$")
        ),
        const Divider(color: Colors.black12, height: 1, indent: 10, endIndent: 10),
        const SizedBox(height: 40),
        labelView(
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
              child:const Icon(Icons.edit_outlined, size:22, color: Colors.grey)
            )
          )
        ),
        plugList(),
        const Divider(color: Colors.black12, height: 1, indent: 10, endIndent: 10),
        const SizedBox(height: 40),
        labelView(
          iconData:Icons.list_outlined, 
          title:"AI", 
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          extendChild: GestureDetector(
            onTap: (){
            },
            child: Container(
              width: 20,
              height: 20,
              color: Colors.transparent,
              child:const Icon(Icons.edit_outlined, size:22, color: Colors.grey)
            )
          )
        ),
        const SizedBox(height: 20),
        labelView(iconData:Icons.health_and_safety_outlined, title:"OpenAI"),
        labelView(iconData:Icons.face_2, title:"Grok"),
        labelView(iconData:Icons.sticky_note_2, title:"天工"),
        labelView(iconData:Icons.bakery_dining_rounded, title:"文心一言"),
        labelView(iconData:Icons.follow_the_signs, title:"华为智障"),
        labelView(iconData:Icons.chat_bubble, title:"腾讯"),
        labelView(iconData:Icons.attach_money_sharp, title:"蚂蚁"),
        labelView(iconData:Icons.fax_outlined, title:"FoxShop")
      ],
    );
  }

  Widget labelView({required IconData iconData,
                required String title, 
                Function? onTap, 
                EdgeInsets padding = const EdgeInsets.fromLTRB(20, 0, 20, 40), 
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
            const SizedBox(width: 12),
            Center(child:Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14))),
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

  Widget plugList() {
    return GridView(
      shrinkWrap:true,
      physics: const FastBouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children:<Widget>[
        plugButton(Icons.ac_unit),
        plugButton(Icons.airport_shuttle),
        plugButton(Icons.all_inclusive),
        plugButton(Icons.beach_access),
        plugButton(Icons.cake),
        plugButton(Icons.add_outlined, backgroundColor: Colors.grey[200], onTap: (){
        })
      ]
    );
  }

  Widget plugButton(IconData iconData, {Color? backgroundColor, Function? onTap}) {
    return GestureDetector(
      onTap: (){
        if (onTap!=null) {
          onTap();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 0.5),
          color: backgroundColor,
          borderRadius: BorderRadius.circular((9.0))
        ),
        child: Icon(iconData, size:30, color: Colors.black54)
      )
    );
  }
}
