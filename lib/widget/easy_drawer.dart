import 'package:chat_hub/main.dart';
import 'package:flutter/material.dart';

class EasyDrawer extends StatefulWidget {

  final Widget drawerChild;

  final Widget mainChild;

  final ScrollController scrollController;

  final double? drawerWidth;

  final bool? popupDrawer;

  EasyDrawer({
    required this.drawerChild, 
    required this.mainChild,
    required this.scrollController,
    this.drawerWidth = 0,
    this.popupDrawer = false,
    Key? key})
    : super(key: key);

  @override
  EasyDrawerState createState() => EasyDrawerState();
}

class EasyDrawerState extends State<EasyDrawer> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      controller: widget.scrollController,
      children: [
        drawerBox(),
        mainBox()
      ],
    );
  }

  Widget drawerBox() {
    return Container(
      width: widget.drawerWidth==null ? appWidth * 0.7 : widget.drawerWidth,
      child: widget.drawerChild,
    );
  }

  Widget mainBox() {
    return Container(
      width: appWidth,
      child: widget.mainChild,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}