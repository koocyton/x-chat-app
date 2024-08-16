import 'dart:ui';

import 'package:chat_hub/service/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chat_hub/config/routes.dart';
import 'package:chat_hub/locale/translations.dart';
import 'package:chat_hub/widget/easy.dart';
import 'package:chat_hub/widget/spin_kit.dart';
import 'package:wakelock/wakelock.dart';
import 'package:logging/logging.dart';
import 'package:get/get.dart';

MediaQueryData get windowMediaQueryData => MediaQueryData.fromView(window);
double get appTopHeight => windowMediaQueryData.padding.top;
double get appWidth     => windowMediaQueryData.size.width;
double get appHeight    => windowMediaQueryData.size.height;
Color  get appBgColor   => Color(0xFF222222);
Color  get appFgColor   => Colors.amber;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name} [${record.time.toString().substring(0, 19)}] ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  Future.delayed(const Duration(milliseconds: 200), () {
    runApp(const App());
  });
  SystemChrome.restoreSystemUIOverlays();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: appBgColor,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {

  bool mainScreenLocked = true;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return;
      },
      getPages: Routes.getPages,
      color: appBgColor,
      home: Container(
        height: appTopHeight, 
        color: appBgColor,
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SpinKit.cubeGrid(size: 80, color:appFgColor),
              SizedBox(height:5),
              Easy.twoColorText(text1: "doopp", text2: "chat", color1: appFgColor)
            ]
          )
      ),
      locale: Get.deviceLocale,
      translations: TranslationService(),
      theme: ThemeData(brightness: Brightness.light),
      builder: (BuildContext context, Widget? child) {
        EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 2000)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorSize = 44.0
            ..radius = 5.0
            ..toastPosition = EasyLoadingToastPosition.bottom
            ..contentPadding = const EdgeInsets.fromLTRB(10, 10, 10, 10)
            ..backgroundColor = appBgColor
            ..indicatorColor = Colors.white
            ..textColor = Colors.white
            ..maskColor = Colors.white;
          return EasyLoading.init().call(context, child);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    DBService.initDababase().then((v){
      Future.delayed(Duration(milliseconds: 2000), (){
        Get.offNamed("/chat");
      });
    });
  }
}
