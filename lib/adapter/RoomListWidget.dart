import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:room/bean/DirtyBean.dart';
import 'package:room/bean/RoomBean.dart';
import 'package:room/bean/ServiceBean.dart';

class RoomListWidget extends StatelessWidget {
  String orderCode = '';
  RoomBean bean;
  int index;
  int length;
  OnHandleClickListener callBack;
  var _shop_code = new TextEditingController();

  RoomListWidget(
      {Key key,
      @required this.index,
      @required this.length,
      @required this.bean,
      @required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    orderCode='';
    _shop_code.text=orderCode;
    return item();
  }

  Widget item() {
    return Container(
      color: Color(0xffefefef),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
            child: Container(
              color: Color(0xffefefef),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/order_info.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('订单信息'),
                      Spacer(),
                      Text('${index + 1}/$length'),
                    ],
                  ),
                ),
                Divider(
                  color: Color(0xffADADAD),
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '房间号:',
                      style: TextStyle(fontSize: 14, color: Color(0xffADADAD)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      bean.room_code,
                      style: TextStyle(fontSize: 14, color: Color(0xff505050)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '联系人:',
                      style: TextStyle(fontSize: 14, color: Color(0xffADADAD)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      bean.consignee,
                      style: TextStyle(fontSize: 14, color: Color(0xff505050)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '联系方式:',
                      style: TextStyle(fontSize: 14, color: Color(0xffADADAD)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      bean.tel,
                      style: TextStyle(fontSize: 14, color: Color(0xff505050)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Color(0xffADADAD),
                  height: 2,
                ),
              ],
            ),
          ),
          _buildGoodWidget(),
          codeWidget(),
          Container(
            width: double.infinity,
            height: 86,
            color: Colors.white,
            padding: const EdgeInsets.only(left:16,right:16,top: 20, bottom: 20),
            child: RaisedButton(
              color: Color(0xff867A58),
              shape: getBorder(false),
              child: Text(
                '送件',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                if (callBack != null) {
                  this.callBack.onHandle(index,orderCode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return IntrinsicHeight(
            child: Container(
              color: Colors.white,
              width: 120,
              height: 120,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              '${bean.order_all[index].original_img}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            bean.order_all[index].goods_title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text('x ${bean.order_all[index].goods_num}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bean.order_all.length ?? 0,
      ),
    );
  }

  Widget codeWidget() {
    return Container(
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
              constraints: BoxConstraints(
                  minHeight: 35,
                  maxHeight: 35),
              alignment: Alignment.center,
              width: 200,
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: this._shop_code,
                style: TextStyle(fontSize: 14, color: Color(0xff505050)),
                decoration: InputDecoration(
                    hintText: '请输入取件码',
                    contentPadding: EdgeInsets.all(5),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
                onChanged: (value) => orderCode = value,
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
    );
  }
}

RoundedRectangleBorder getBorder(bool isHandle) {
  RoundedRectangleBorder border;
  if (isHandle) {
    border = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ));
  } else {
    border = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
  }
  return border;
}

abstract class OnHandleClickListener {
  void onHandle(int position,String shop_code);
}
