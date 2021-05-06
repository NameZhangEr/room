import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'file:///G:/flutter_workpace/flutter_room/room/lib/home/HomePage.dart';
import 'package:room/bean/LoginBean.dart';
import 'package:room/interfaces/OnLoginClickListener.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatelessWidget {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return login(context);
  }

  Widget login(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _login(context),
    );
  }

  Widget _login(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          child: SafeArea(
            top: true,
            child: Offstage(),
          ),
          preferredSize:
              Size.fromHeight(MediaQueryData.fromWindow(window).padding.top)),
      body: Center(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/login_bg.png'))),
          padding: const EdgeInsets.only(top: 45),
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 45, right: 45),
                  child: Image.asset(
                    'assets/images/login_img.png',
                    fit: BoxFit.fitWidth,
                    height: 30,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    margin: const EdgeInsets.only(top: 45, left: 48, right: 48),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              userName = value;
                            },
                            decoration: InputDecoration(
                                icon: Image.asset(
                                  'assets/images/people.png',
                                  width: 20,
                                  height: 20,
                                ),
                                hintText: '请输入账号/手机号码/邮箱',
                                hintStyle: TextStyle(color: Color(0xffADADAD))),
                          ),
                        )
                      ],
                    )),
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    margin: const EdgeInsets.only(left: 48, right: 48),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                                icon: Image.asset(
                                  'assets/images/mima.png',
                                  width: 20,
                                  height: 20,
                                ),
                                hintText: '请输入6-16位密码',
                                hintStyle: TextStyle(color: Color(0xffADADAD))),
                          ),
                        )
                      ],
                    )),
                Container(
                  width: double.infinity,
                  height: 46,
                  margin: const EdgeInsets.only(
                      left: 48, right: 48, top: 44, bottom: 20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      '登录',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Color(0xff867A58),
                    onPressed: () {
                      _loginData(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text('如需要演示帐户，请与我们的销售经理联繫,\n电话：0755-85205844',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, wordSpacing: 5, height: 1.5)),
              ],
            ),
          )),
        ),
      ),
    );
  }

  _loginData(BuildContext context) async {
    if (userName == '') {
      Fluttertoast.showToast(
          msg: '请输入账号/手机号码/邮箱', gravity: ToastGravity.CENTER);
      return;
    } else if (password == '') {
      Fluttertoast.showToast(msg: '请输入密码', gravity: ToastGravity.CENTER);
      return;
    }
    Map<String, String> map = new Map<String, String>();
    map["username"] = userName;
    map["password"] = password;
    JPush().getRegistrationID().then((value) => map["unique"] = value);
    var url = UrlUtils.LOGIN;
    print(map.toString());
    HttpController.getData(url, (data) {
      LoginBean response = LoginBean.fromJson(data);
      if (response.code.toString() == '1') {
        saveData(response);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeWidget();
        }), (route) => false);
      } else {
        Fluttertoast.showToast(msg: response.msg, gravity: ToastGravity.CENTER);
      }
      print(response.toString());
    }, params: map);
  }

  saveData(LoginBean loginBean) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("login", 'isLogin');
    SpUtils.putString('HOTEL_APP_ID', loginBean.appid.toString());
    SpUtils.putString('isLogin', 'true');
    SpUtils.putString('head_pic', loginBean.headPic);
    SpUtils.putString('token', loginBean.token);
    SpUtils.putString('username', loginBean.username);
    SpUtils.putString('service_id', loginBean.serviceId.toString());
    SpUtils.putString(
        'customer_service_type', loginBean.customerServiceType.toString());
    JPush().setAlias(loginBean.appid.toString());
  }
}
