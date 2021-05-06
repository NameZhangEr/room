import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/response/Response.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';

class InvitePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InvitePageState();
  }
}

class InvitePageState extends State<InvitePage>
    with AutomaticKeepAliveClientMixin {
  String orderCode = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 14),
            color: Color(0xffefefef),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '请输入您的取件码 >',
                  style: TextStyle(color: Color(0xff505050), fontSize: 12),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                    color: Colors.white,
                    constraints: BoxConstraints(minHeight: 35, maxHeight: 35),
                    alignment: Alignment.center,
                    width: 200,
                    child: TextField(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15, color: Color(0xff505050)),
                      decoration: InputDecoration(
                        hintText: '请输入取件码',
                        contentPadding: EdgeInsets.all(5),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                      onChanged: (value) => orderCode = value,
                      onSubmitted: (value) {
                        _queryOrder(value);
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Text(
                    '请在订单详情页查看您的取件码',
                    style: TextStyle(color: Color(0xffADADAD), fontSize: 11),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 46,
            margin:
                const EdgeInsets.only(left: 14, right: 14, top: 44, bottom: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Text(
                '查询订单',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Color(0xff867A58),
              onPressed: () {
                _queryOrder(orderCode);
              },
            ),
          ),
        ],
      ),
    );
  }

  _queryOrder(String code) async {
    if (code.isEmpty) {
      Fluttertoast.showToast(msg: '请输入取件码', gravity: ToastGravity.CENTER);
      return;
    }
    Map<String, String> map = Map<String, String>();
    map['shop_code'] = code;
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    HttpController.getData(UrlUtils.QUERY_ORDER, (data) {
      if (!mounted) return;
      Response response = Response.fromJson(data);
      if (response.code == 1) {
      } else {
        Fluttertoast.showToast(msg: response.msg, gravity: ToastGravity.CENTER);
      }
    }, params: map);
  }
}
