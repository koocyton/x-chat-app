import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chat_hub/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class Easy {

  static Widget twoColorText({String? text1, String? text2, Color color1=Colors.blueGrey, Color color2=Colors.white, double fontSize=30}) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: TextStyle(color: color1, fontSize: fontSize, fontWeight: FontWeight.w900),
        children:[
          TextSpan(text: text2, 
            style: TextStyle(
              color: color2,
              fontSize: fontSize, 
              fontWeight: FontWeight.w900
            )
          )
        ]
      )
    );
  }

  static void imageEvictFromCache(String url) {
      CachedNetworkImage.evictFromCache(url);
  }

  static Widget image (String uri, {int? expireMinutes, String? cacheKey, Color? color, BlendMode? colorBlendMode, BoxFit fit=BoxFit.cover, double? width, double? height, Widget? errorWidget, Function? onloaded}) {
    if (uri.startsWith("assets/")) {
      return Container(
        alignment: Alignment.center,
        child:Image.asset(uri, fit: fit, width:width, height:height)
      );
    }
    else if (uri.startsWith("/")) {
      return Container(
        alignment: Alignment.center,
        child: Image.file(File(uri), fit: fit, width:width, height:height)
      );
    }
    else if (uri.startsWith("http")) {
      return Container(
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: uri,
          // placeholder: (context, url) => const CircularProgressIndicator(),
          // errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: fit,
          width: width,
          color: color,
          colorBlendMode: colorBlendMode,
          height: height,
          progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress downloadProgress) {
            double? value = downloadProgress.progress;
            if (value!=1) {
              return Shimmer.fromColors(
                baseColor: Colors.white24,
                highlightColor: Colors.white70,
                child: Icon(
                  Icons.panorama_outlined,
                  size: width,
                  color: Colors.white24
                ),
              );
            }
            return Container();
          },
          errorWidget: (buildContext, str, dyn){
            if (errorWidget!=null) {
              return errorWidget;
            }
            return Container();
          }
        )
      );
    }
    return Container(
      color:Colors.blueGrey,
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(uri.substring(0, 1), style: TextStyle(fontSize: height!/2, color: color, fontWeight: FontWeight.bold)),
    );
  }

  static void fullDialog({Widget? child, double? height, double? width, Color backgroundColor=Colors.white}) {
    Get.generalDialog(
      pageBuilder:(a,b,c) {
        return Column(
          children:[
            Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  width:30,
                  height:30,
                  child:const Icon(Icons.close, size: 18, color:Colors.black)
                ),
              ),
            ),
            Container(
              color: backgroundColor,
              height: height,
              width: width,
              child: child
            )
          ]
        );
      }
    );
  }

  static void confirm(String message, {String confirmText="confirm", String cancelText="close", Function? onConfirm, Function? onCancel}) {
    return Easy.dialog(
      closeWidget: SizedBox(height: 10),
      backgroundColor: Colors.white,
      height:null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text(message, style:TextStyle(color:Colors.black87)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (onConfirm!=null) 
                ? easyButton(text:confirmText, onPressed: ()=>onConfirm())
                : SizedBox(width: 0),
              SizedBox(
                width: (onConfirm!=null && onCancel!=null) ? 30 : 0
              ),
              (onCancel!=null) 
                ? easyButton(text:cancelText, onPressed: ()=>onCancel())
                : SizedBox(width: 0)
            ]
          )
        ],
      )
    );
  }

  static Widget easyButton({Function? onPressed, 
                  Alignment alignment = Alignment.center,
                  Color fillColor=Colors.blueGrey, 
                  double? width, 
                  double height=40, 
                  EdgeInsets padding=const EdgeInsets.all(0), 
                  double? borderRadius, 
                  String? text, 
                  double fontSize=12,
                  Color backgroundColor=Colors.transparent,
                  Color textColor=Colors.white,
                  List<Shadow>? shadows}) {
    return Container(
      height: height,
      width: width,
      color: backgroundColor,
      alignment: alignment,
      child: RawMaterialButton(
        onPressed: () {
          if (onPressed!=null) {
            onPressed();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius??height/2))
        ),
        padding: padding,
        hoverColor: Colors.grey,
        highlightColor: Colors.grey,
        fillColor: fillColor,
        child: Text(text??"", 
          style: TextStyle(
            fontSize: fontSize,
            color:textColor,
            shadows:shadows
          )
        )
      )
    );
  }

  static void dialog({Color closeColor=Colors.black, Widget? closeWidget, Widget? child, double? height = 300, double width=300, Color backgroundColor=Colors.white}) {
    // Future.delayed(const Duration(milliseconds: 30), () {
    //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     systemNavigationBarColor: Colors.black,
    //   ));
    // });
    Get.defaultDialog(
      barrierDismissible: false,
      title:"Login",
      titlePadding: const EdgeInsets.all(0),
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children:[
          closeWidget!=null 
            ? closeWidget
            : Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  width: 20,
                  height: 20,
                  child: Icon(Icons.close, size: 18, color: closeColor)
                ),
              ),
            ),
          SizedBox(
            height: height,
            width: width,
            child: child
          )
        ]
      ),
      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      radius: 10,
      backgroundColor: backgroundColor
    );
  }

  static void showCenterToast(String text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.center,
    );
  }

  static void showTopToast(String text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.top,
    );
  }

  static void showBottomToast(String text, {Duration duration = const Duration(seconds: 2)}) {
    EasyLoading.dismiss();
    EasyLoading.showToast(
      text,
      duration: duration,
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  static void snackbar(String text, {SnackPosition snackPosition = SnackPosition.TOP, Duration duration = const Duration(seconds: 3)}) {
    Get.snackbar("", text,
      backgroundColor: Colors.white54,
      titleText: const SizedBox(height: 0),
      snackPosition: snackPosition,
      duration: duration,
      colorText: Colors.black54,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16)
    );
  }

  static Widget icon(IconData icon, Color iconColor, String number, {double iconSize=35, double scaleX=1, Function? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap!=null) {
          onTap();
        }
      },
      child: Container(
        height: number=="" ? 60 : 70,
        width: 60,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          // border: Border.all(width: 1, color: Colors.white24),
        ),
        child: Column(
          children: [
            Transform.scale(scaleX: scaleX,
              child: Icon(icon, size: iconSize, color: iconColor, shadows: const <Shadow>[
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black38,
                ),
                Shadow(
                  offset: Offset(-2,2),
                  blurRadius: 2,
                  color: Colors.black38,
                ),
              ]),
            ),
            number.contains(" ")
              ? Row(
                children:[
                  Text(number, style: TextStyle(color: iconColor, fontSize: 15))
                ]
              )
              : Text(number, style: TextStyle(color: iconColor, fontSize: 15))
          ]
        )
      )
    );
  }
  
  static void share(String text) {
    Share.share(text);
  }

  static Widget label(String title, int pageIndex, int currentPageIndex, double width, {Function? onTap, double titleSize=16}) {
    return GestureDetector(
      onTap: (){
        if (onTap!=null) {
          onTap();
        }
      },
      child: Container(
        width: width,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          children:[
            const SizedBox(height:13),
            Text(title, 
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
                leading: 0.5,
              ),
              style: TextStyle(color:Colors.white70, fontSize: titleSize)
            ),
            const SizedBox(height:1),
            Container(
              color: pageIndex==currentPageIndex ? Colors.white70 : Colors.transparent, 
              height: 2, 
              width: 30,
            ),
            const SizedBox(height:5),
          ]
        )
      )
    );
  }

  static Widget topPageWidget({Widget? child, Color backgroundColor=Colors.black}) {
    return Column(
      children: [
        Container(height: appTopHeight, color: appBgColor),
        Expanded(
          child: Container(
            color:backgroundColor,
            child: child ?? const SizedBox(),
          )
        )
      ]
    );
  }

  static Widget fullPageWidget({List<Widget>? children}) {
    return Stack(
      alignment:Alignment.topCenter,
      fit: StackFit.loose,
      children: children ?? []
    );
  }

  static void launchURI(String? url) {
    if (url==null) {
      return;
    }
    if (url.startsWith("/")) {
      Get.toNamed(url);
      return;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
  }

  static void launchApp(String? url) {
    if (url==null) {
      return;
    }
    if (url.startsWith("/")) {
      Get.toNamed(url);
      return;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static void trackLaunchApp(String? url) {
    launchApp(url);
  }

  static void showBottomModal({required BuildContext context, EdgeInsets padding = const EdgeInsets.all(0), double height = 400, String title = "", Widget child = const SizedBox()}) {
    // showModalBottomSheet
    showModalBottomSheet(isScrollControlled: true, context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: height,
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              children:[
                Container(
                  color:Colors.transparent,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      SizedBox(width: 40),
                      Container(
                        height: 40,
                        width: appWidth - 80, 
                        alignment: Alignment.center, 
                        child: Text(title, 
                          style: const TextStyle(
                            color:Colors.black87, 
                            fontWeight: FontWeight.bold,
                            fontSize: 11
                          )
                        )
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          color:Colors.transparent,
                          child:Icon(
                            Icons.close, 
                            color:Colors.black87,
                            size: 18,
                          )
                        )
                      ),
                    ]
                  )
                ),
                Expanded(
                  child: Container(
                    padding: padding,
                    color:Colors.transparent,
                    child: child
                )
              )
            ])
          )
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(15, 15),
          topRight: Radius.elliptical(15, 15),
          bottomLeft: Radius.elliptical(0, 0),
          bottomRight: Radius.elliptical(0, 0),
        ),
      )
    );
  }
}