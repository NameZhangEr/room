import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/adapter/ServiceListWidget.dart';
import 'package:room/bean/ServiceBean.dart';
import 'package:room/response/ListResponse.dart';
import 'package:room/util/EventBusUtil.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/LoadingDialog.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:room/widget/EmptyWidget.dart';

class HomeService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeServiceState();
  }
}

class HomeServiceState extends State<HomeService>
    with AutomaticKeepAliveClientMixin
    implements OnHandleClickListener {
  EventBusUtil eventBusUtil = EventBusUtil();
  List<ServiceBean> serviceBeans = [];
  bool isHandle = false;
  String appId;
  String serviceId;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildService();
  }

  @override
  void onHandle(int position) {
    _handlerService(serviceBeans[position]);
    setState(() {
      serviceBeans.removeAt(position);
    });
  }

  //判断是否接口加载完成
  bool isFinished = false;
  bool isLoading = false;

  Widget _buildService() {
    bool isVisible = true;
    if (isFinished) {
      isVisible = serviceBeans.isNotEmpty;
    }
    return _buildList(isVisible);
  }

  Widget _buildList(bool isVisible) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: isVisible,
          child: EmptyWidget(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Material(
                child: InkWell(
                  onTap: () {
                    if (!isHandle) return;
                    isHandle = false;
                    serviceBeans.clear();
                    this._getServiceData();
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '未处理',
                      style: TextStyle(
                          color:
                              isHandle ? Color(0xff505050) : Color(0xffC1AC69)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                child: InkWell(
                  onTap: () {
                    if (isHandle) return;
                    // setState(() {
                    isHandle = true;
                    // });
                    serviceBeans.clear();
                    this._getServiceData();
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '已处理',
                      style: TextStyle(
                          color: !isHandle
                              ? Color(0xff505050)
                              : Color(0xffC1AC69)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          child: RefreshIndicator(
            displacement: 44.0,
            onRefresh: _doRefresh,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  ServiceListWidget widget = ServiceListWidget(
                    index: index,
                    bean: this.serviceBeans[index],
                    callBack: this,
                  );
                  return widget;
                },
                separatorBuilder: (context, index) => Divider(
                      color: Color(0xffefefef),
                      height: 10,
                    ),
                itemCount: serviceBeans.length),
          ),
        ),
        Offstage(
          offstage: isFinished,
          child: LoadingDialog(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    this._getServiceData();
    eventBusUtil.on('push', (arg) {
      this._getServiceData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventBusUtil.off('push');
  }

  Future<void> _doRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    serviceBeans.clear();
    _getServiceData();
  }

  _getServiceData() async {
    Map<String, String> map = new Map<String, String>();
    map["status"] = isHandle ? '1' : '0';
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    var url = UrlUtils.CALL_SERVICE_LIST;
    HttpController.getData(url, (data) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: isLoading ? 0 : 2000), () {
        isFinished = true;
        isLoading = true;
        setState(() {
          ListResponse response = ListResponse.fromJson(data);
          if (response.code == 1) {
            serviceBeans = ListResponse.fromJson(data)
                .data
                .map((e) => ServiceBean.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            serviceBeans.clear();
          }
        });
      });
    }, params: map);
  }

  _handlerService(ServiceBean serviceBean) async {
    Map<String, String> map = new Map<String, String>();
    map["room_num"] = serviceBean.room_num;
    map["type"] = serviceBean.type;
    map["service_id"] = SpUtils.getString('service_id');
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    var url = UrlUtils.HANDLE_SERVICE;
    HttpController.getData(url, (data) {
      if (!mounted) return;
      setState(() {
        ListResponse response = ListResponse.fromJson(data);
        Fluttertoast.showToast(msg: response.msg,gravity: ToastGravity.CENTER);
      });
    }, params: map);
  }
}
