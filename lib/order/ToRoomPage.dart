import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/adapter/RoomListWidget.dart';
import 'package:room/bean/RoomBean.dart';
import 'package:room/response/ListResponse.dart';
import 'package:room/response/Response.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/LoadingDialog.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:room/widget/EmptyWidget.dart';

class ToRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ToRoomPageState();
  }
}

class ToRoomPageState extends State<ToRoomPage>
    with AutomaticKeepAliveClientMixin
    implements OnHandleClickListener {
  List<RoomBean> roomBeans = [];

  //判断是否接口加载完成
  bool isFinished = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getRoomData();
  }

  @override
  Widget build(BuildContext context) {
    return listRoom();
  }

  Widget listRoom() {
    bool isVisible = true;
    if (isFinished) {
      isVisible = roomBeans.isNotEmpty;
    }
    return _buildList(isVisible);
  }

  Widget _buildList(bool isVisible) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: isVisible,
            child: EmptyWidget(),
          ),
          RefreshIndicator(
            displacement: 44.0,
            onRefresh: _doRefresh,
            child: Listener(
                onPointerDown: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return RoomListWidget(
                        index: index,
                        length: roomBeans.length,
                        bean: this.roomBeans[index],
                        callBack: this,
                      );
                    },
                    itemCount: roomBeans.length)),
          ),
          Offstage(
            offstage: isFinished,
            child: LoadingDialog(),
          ),
        ],
      ),
    );
  }

  Future<void> _doRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    roomBeans.clear();
    _getRoomData();
  }

  //获取数据
  _getRoomData() async {
    Map<String, String> map = Map<String, String>();
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    HttpController.getData(UrlUtils.SEND_ROOM, (data) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: isLoading ? 0 : 2000), () {
        ListResponse response = ListResponse.fromJson(data);
        isFinished = true;
        isLoading = true;
        setState(() {
          if (response.code == 1) {
            roomBeans = response.data.map((e) => RoomBean.fromJson(e)).toList();
          }
        });
      });
    }, params: map);
  }

  _handleData(int position, RoomBean roomBean) async {
    Map<String, String> map = Map<String, String>();
    map["goods_sn"] = roomBean.goods_sn;
    map["type"] = '2';
    map["shop_code"] = roomBean.shop_code;
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    HttpController.getData(UrlUtils.UPDATE_ORDER_STATUS, (data) {
      if (!mounted) return;
      Response response = Response.fromJson(data);
      roomBeans.removeAt(position);
      setState(() {
        if (response.code == 1) {
          Fluttertoast.showToast(
              msg: response.msg, gravity: ToastGravity.CENTER);
        }
      });
    }, params: map);
  }

  @override
  void onHandle(int position, String shop_code) {
    RoomBean roomBean = roomBeans[position];
    print('roomBean=${roomBean.shop_code}');
    print('shop_code=$shop_code');
    if (shop_code.isEmpty) {
      Fluttertoast.showToast(msg: '请填写取件码', gravity: ToastGravity.CENTER);
      return;
    } else if (roomBean.shop_code != shop_code) {
      Fluttertoast.showToast(msg: '请填写正确取件码', gravity: ToastGravity.CENTER);
      return;
    } else {
      _handleData(position, roomBean);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
