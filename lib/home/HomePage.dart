import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'file:///G:/flutter_workpace/flutter_room/room/lib/home/HomeDirty.dart';
import 'file:///G:/flutter_workpace/flutter_room/room/lib/home/HomeOrder.dart';
import 'file:///G:/flutter_workpace/flutter_room/room/lib/home/HomeService.dart';
import 'package:room/LoginPage.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bean/LoginBean.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeWidgetState();
  }
}

int mCurrentIndex = 0;
String title = '';
List<Widget> pages = [];

class HomeWidgetState extends State<HomeWidget> {
  var _pageController = PageController(initialPage: 0);

  void initState() {
    super.initState();
    pages.add(HomeService());
    pages.add(HomeDirty());
    pages.add(HomeOrder());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget(context);
  }

  Widget homeWidget(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          elevation: 1,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () => _exitApp(context),
            ),
          ],
        ),
        body: PageView.builder(
          itemCount: pages.length,
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              if (mCurrentIndex != value) {
                mCurrentIndex = value;
              }
            });
          },
          itemBuilder: (context, index) => pages[index],
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  mCurrentIndex == 0
                      ? 'assets/images/service_select.png'
                      : 'assets/images/service_unselect.png',
                  width: 24,
                  height: 24,
                ),
                title: Text('服务录')),
            BottomNavigationBarItem(
                icon: Image.asset(
                  mCurrentIndex == 1
                      ? 'assets/images/dirty_select.png'
                      : 'assets/images/dirty_unselect.png',
                  width: 24,
                  height: 24,
                ),
                title: Text('脏房打扫')),
            BottomNavigationBarItem(
                icon: Image.asset(
                  mCurrentIndex == 2
                      ? 'assets/images/order_select.png'
                      : 'assets/images/order_unselect.png',
                  width: 24,
                  height: 24,
                ),
                title: Text('订单处理'))
          ],
          elevation: 10,
          currentIndex: 0,
          selectedItemColor: Colors.black,
          onTap: (int i) {
            _pageController.jumpToPage(i);
          },
        ),
      ),
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(
              msg: '再按一次退出App', gravity: ToastGravity.CENTER);
        } else {
          JPush().stopPush();
          lastPopTime = DateTime.now();
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
    );
  }

  DateTime lastPopTime;

  String _getTitle() {
    if (mCurrentIndex == 0) {
      title = '服务录';
    } else if (mCurrentIndex == 1) {
      title = '脏房打扫';
    } else if (mCurrentIndex == 2) {
      title = '订单处理';
    }
    return title;
  }

  _exitApp(BuildContext context) async {
    Map<String, String> map = new Map<String, String>();
    map["token"] = SpUtils.getString('token');
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    var url = UrlUtils.LOGOUT;
    print(map.toString());
    HttpController.getData(url, (data) {
        SpUtils.clear();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
          return LoginWidget();
        }), (route) => false);
    }, params: map);
  }
}
