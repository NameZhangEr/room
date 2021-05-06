import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/response/ListResponse.dart';
import 'package:room/util/EventBusUtil.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/LoadingDialog.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:room/widget/EmptyWidget.dart';

import 'package:room/adapter/DirtyListWidget.dart';
import 'package:room/bean/DirtyBean.dart';

class HomeDirty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeDirtyState();
  }
}

class HomeDirtyState extends State<HomeDirty>
    with AutomaticKeepAliveClientMixin
    implements OnHandleClickListener {
  List<DirtyBean> dirtyBeans = [];
  EventBusUtil eventBusUtil = EventBusUtil();

  //判断是否接口加载完成
  bool isFinished = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildService();
  }

  Widget _buildService() {
    bool isVisible = true;
    if (isFinished) {
      isVisible = dirtyBeans.isNotEmpty;
    }
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: isVisible,
          child: SizedBox(
            height: 40,
          ),
        ),
        Offstage(
          offstage: isVisible,
          child: EmptyWidget(),
        ),
        RefreshIndicator(
          displacement: 44.0,
          onRefresh: _doRefresh,
          child: ListView.separated(
              itemBuilder: (context, index) {
                return DirtyListWidget(
                  index: index,
                  bean: this.dirtyBeans[index],
                  callBack: this,
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Color(0xffefefef),
                    height: 10,
                  ),
              itemCount: dirtyBeans.length),
        ),
        Offstage(
          offstage: isFinished,
          child: LoadingDialog(),
        ),
      ],
    );
  }

  @override
  void onHandle(int position) {
    _handlerService(dirtyBeans[position]);
    setState(() {
      dirtyBeans.removeAt(position);
    });
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
    dirtyBeans.clear();
    _getServiceData();
  }

  _getServiceData() async {
    Map<String, String> map = new Map<String, String>();
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    var url = UrlUtils.DIRTY_ROOM;
    HttpController.getData(url, (data) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: isLoading ? 0 : 2000), () {
        setState(() {
          isFinished = true;
          isLoading = true;
          ListResponse response = ListResponse.fromJson(data);
          if (response.code == 1) {
            dirtyBeans = ListResponse.fromJson(data)
                .data
                .map((e) => DirtyBean.fromJson(e as Map<String, dynamic>))
                .toList();
          }else {
            dirtyBeans.clear();
          }
        });
      });
    }, params: map);
  }

  _handlerService(DirtyBean dirtyBean) async {
    Map<String, String> map = new Map<String, String>();
    map["service_id"] = SpUtils.getString('service_id');
    map["room_num"] = dirtyBean.room_num;
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    var url = UrlUtils.UPDATE_DIRTY_ROOM;
    HttpController.getData(url, (data) {
      if (!mounted) return;
      setState(() {
        ListResponse response = ListResponse.fromJson(data);
        Fluttertoast.showToast(msg: response.msg,gravity: ToastGravity.CENTER);
      });
    }, params: map);
  }

  @override
  bool get wantKeepAlive => true;
}
