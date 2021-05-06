import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:room/util/Constant.dart';
import 'package:room/util/EventBusUtil.dart';
import 'file:///G:/flutter_workpace/flutter_room/room/lib/home/HomePage.dart';

import 'LoginPage.dart';
import 'util/SpUtils.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  loadAsync();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

void loadAsync() async {
  await SpUtils.getInstance(); //等待Sp初始化完成
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: Colors.white,
        accentColor: Color(0xffC1AC69),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginWidget(),
        '/home': (BuildContext context) => HomeWidget(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _mainState();
  }
}

class _mainState extends State<MainPage> {
  EventBusUtil eventBusUtil = EventBusUtil();

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2000), () => _toLogin());
    Future.delayed(Duration.zero).then((value) => _initJPush());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.light,
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.white,
          child: Text('欢迎使用客房控制',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  decoration: TextDecoration.none)),
        ),
      ),
    );
  }

  _toLogin() async {
    String isLogin = SpUtils.getString('isLogin');
    if (isLogin == '') {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  _initJPush() async {
    JPush jPush = JPush();
    jPush.resumePush();
    jPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        eventBusUtil.emit('push', message);
        var localNotification = LocalNotification(
          id: 123,
          title: '客房管理',
          buildId: 1,
          fireTime: DateTime.now(),
          content: message['message'],
          soundName:'assets/raw/face_good.mp3'
        );
        jPush.sendLocalNotification(localNotification);
        print("flutter onReceiveMessage: $message");
      },
    );
    jPush.setup(
      appKey: Constant.JPush_APPKEY,
      channel: "developer-default",
      production: false,
      debug: false,
    );
    jPush.applyPushAuthority(new NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: false,
    ));
    jPush.isNotificationEnabled().then((value) => {
      print('value  $value'),
      if (!value) {
      jPush.openSettingsForNotification()
    }});
  }
}
