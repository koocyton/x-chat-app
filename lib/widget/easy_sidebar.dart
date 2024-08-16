
import 'package:flutter/material.dart';

class EasySidebar extends StatefulWidget {

  final Widget sidebar;
  final Widget Function(BuildContext, EasySidebarController) childBuild;

  EasySidebar({required this.sidebar, required this.childBuild, Key? key}) : super(key: key);

  @override
  EasySidebarState createState() => EasySidebarState();
}

class EasySidebarController {

  late final EasySidebarState sidebarState;

  late final double contextWidth;
  late final double contextHeight;
  late final double sidebarWidth;

  late final ScrollController sidebarScroll;

  bool showOperation = false;

  EasySidebarController(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    contextWidth = contextSize.width;
    sidebarWidth = (contextSize.width * 0.618).toInt().toDouble();
    contextHeight = contextSize.height; 
    sidebarScroll = ScrollController(initialScrollOffset:sidebarWidth);
  }

  void switchOperation() {
    sidebarState.switchOperation();
  }

  bool isOperation() {
    return showOperation;
  }
}

class EasySidebarState extends State<EasySidebar> {

  EasySidebarController? sidebarController;

  @override
  Widget build(BuildContext context) {
    if (sidebarController==null) {
      sidebarController = EasySidebarController(context);
      sidebarController!.sidebarState = this;
    }
    return ListView(
      controller: sidebarController!.sidebarScroll,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children:[
        Container(
          width: sidebarController!.sidebarWidth,
          height: sidebarController!.contextHeight,
          color:Colors.white,
          child: widget.sidebar
        ),
        Container(
          width: sidebarController!.contextWidth,
          height: sidebarController!.contextHeight,
          color:Colors.black54,
          child: Stack(
            alignment:Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              widget.childBuild(context, sidebarController!),
              sidebarController!.showOperation
                ? GestureDetector(
                    onTap: (){
                      sidebarController!.switchOperation();
                    },
                    child:Container(
                      height: sidebarController!.contextHeight,
                      width: sidebarController!.contextWidth,
                      alignment: Alignment.center,
                      color:Colors.black12
                    )
                  )
                : SizedBox(width: 0, height: 0)
            ]
          )
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void switchOperation() {
    if (this.mounted) {
      setState(() {
        sidebarController!.showOperation = !sidebarController!.showOperation;
        sidebarController!.sidebarScroll.animateTo(
          sidebarController!.showOperation ? 0 : sidebarController!.sidebarWidth, 
          duration: Duration(milliseconds: 120), 
          curve: Curves.easeOut
        );
      });
    }
  }
}