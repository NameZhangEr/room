import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room/bean/DirtyBean.dart';

class DirtyListWidget extends StatelessWidget {
  DirtyBean bean;
  int index;
  OnHandleClickListener callBack;

  DirtyListWidget(
      {Key key,
      @required this.index,
      @required this.bean,
      @required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'assets/images/select_message.png',
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text('脏房打扫'),
                Spacer(),
                Text(getTime(bean.time, false)),
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
                style: TextStyle(fontSize: 16, color: Color(0xffADADAD)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                bean.room_num,
                style: TextStyle(fontSize: 16, color: Color(0xff505050)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                '退房时间:',
                style: TextStyle(fontSize: 16, color: Color(0xffADADAD)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                getTime(bean.out_time, true),
                style: TextStyle(fontSize: 16, color: Color(0xff505050)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                '呼叫时间:',
                style: TextStyle(fontSize: 16, color: Color(0xffADADAD)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                bean.go_end_time,
                style: TextStyle(fontSize: 16, color: Color(0xff505050)),
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
          Container(
            width: double.infinity,
            height: 46,
            margin:
                const EdgeInsets.only( top: 20, bottom: 20),
            child: RaisedButton(
              color: bean.status == '0' ? Color(0xff867A58) : Colors.white,
              shape: getBorder(bean.status == '1'),
              child: Text(
                bean.status == '1' ? '已处理' : '待处理',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        bean.status == '0' ? Colors.white : Color(0xff505050)),
              ),
              onPressed: () {
                if (bean.status == '1') {
                  return null;
                }
                if (callBack != null) {
                  this.callBack.onHandle(index);
                }
              },
            ),
          ),
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
  void onHandle(int position);
}

String getTime(String time, bool isAll) {
  int iTime = int.parse(time);
  DateTime _time = DateTime.fromMicrosecondsSinceEpoch(iTime * 1000 * 1000);
  String _pTime = '';
  if (isAll) {
    _pTime = formatDate(_time, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn])
        .toString();
  } else {
    _pTime = formatDate(_time, [mm, '-', dd, ' ', HH, ':', nn]).toString();
  }
  return _pTime;
}
