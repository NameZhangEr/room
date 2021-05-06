import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/bean/CompanyBean.dart';
import 'package:room/bean/CourierBean.dart';
import 'package:barcode_scan/barcode_scan.dart';

class CourierListWidget extends StatefulWidget {
  String orderCode = '';
  CourierBean bean;
  List<CompanyBean> companyBeans = [];
  int index;
  int length;
  OnHandleClickListener callBack;

  CourierListWidget(
      {Key key,
      @required this.index,
      @required this.length,
      @required this.bean,
      @required this.companyBeans,
      @required this.callBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatefulWidgetState();
  }
}

class StatefulWidgetState extends State<CourierListWidget> {
  String _courierName = '';
  var _courierCode = new TextEditingController();
  bool isFinished = false;
  bool isNotEmptyName = false;

  @override
  void initState() {
    super.initState();
    widget.orderCode = '';
    isFinished = widget.bean.orderStatus == 3;
    isNotEmptyName =
        (widget.bean.orderName.isNotEmpty && widget.bean.orderName != '0');
    if (isNotEmptyName) {
      _courierName = widget.bean.orderName;
    }
    if (widget.bean.orderCode.isNotEmpty && widget.bean.orderCode != '0') {
      _courierCode.text = widget.bean.orderCode;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _courierCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return item(context);
  }

  Widget item(BuildContext context) {
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
                        'assets/images/courier_info.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('快递信息'),
                      Spacer(),
                      Text('${widget.index + 1}/${widget.length}'),
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
                      '收货人:',
                      style: TextStyle(fontSize: 14, color: Color(0xffADADAD)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.bean.consignee,
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
                      widget.bean.tel,
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
                      '寄件地址:',
                      style: TextStyle(fontSize: 14, color: Color(0xffADADAD)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.bean.address,
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
          codeWidget(context),
          Container(
            width: double.infinity,
            height: 86,
            color: Colors.white,
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 20),
            child: RaisedButton(
              color: isFinished ? Colors.white : Color(0xff867A58),
              shape: getBorder(isFinished),
              child: Text(
                isFinished ? '已寄件' : '寄件',
                style: TextStyle(
                    fontSize: 16,
                    color: isFinished ? Color(0xff505050) : Colors.white),
              ),
              onPressed: () {
                if (isFinished) {
                  return null;
                }
                if (widget.callBack != null) {
                  if (_courierName.isEmpty) {
                    Fluttertoast.showToast(
                        msg: '请选择快递公司', gravity: ToastGravity.CENTER);
                    return;
                  } else if (_courierCode.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: '请填写快递单号', gravity: ToastGravity.CENTER);
                    return;
                  } else {
                    widget.callBack.onHandle('${widget.bean.orderId}',
                        _courierName, _courierCode.text);
                  }
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
      width: double.infinity,
      padding: const EdgeInsets.only(left: 14, right: 14),
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
                    image: NetworkImage('${widget.bean.originalImg}'),
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
                      widget.bean.goodsTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text('x ${widget.bean.goodsNum}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget codeWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 14),
      color: Color(0xffefefef),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '请输入快递信息 >',
            style: TextStyle(color: Color(0xff505050), fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '快递名称:',
                  style: TextStyle(color: Color(0xff505050), fontSize: 14),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    margin: EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () => {
                        if (!isFinished) {_showBottomCompany(context)}
                      },
                      child: Container(
                        color: Colors.white,
                        constraints:
                            BoxConstraints(minHeight: 35, maxHeight: 35),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          _courierName.isNotEmpty ? _courierName : '输入快递名称',
                          style: TextStyle(
                              color: _courierName.isNotEmpty
                                  ? Color(0xff505050)
                                  : Color(0xff999999)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Text(''),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '快递单号:',
                  style: TextStyle(color: Color(0xff505050), fontSize: 14),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    margin: EdgeInsets.only(left: 15),
                    child: Container(
                      color: Colors.white,
                      constraints: BoxConstraints(minHeight: 35, maxHeight: 35),
                      alignment: Alignment.center,
                      child: TextField(
                        maxLines: 1,
                        enabled: !isFinished,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        controller: this._courierCode,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff505050)),
                        decoration: InputDecoration(
                            hintText: '输入快递单号',
                            hintStyle: TextStyle(color: Color(0xff999999)),
                            contentPadding: EdgeInsets.all(5),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(
                                color: Colors.white
                            )),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide(
                                  color: Colors.white
                                )),
                            ),
                        onChanged: (value) => widget.orderCode = value,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/scan.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        getQrcodeState()
                            .then((value) => {_courierCode.text = value});
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showBottomCompany(BuildContext context) {
    setState(() {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 300,
          color: Colors.white,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Color(0xffefefef),
              height: 1,
            ),
            itemCount: widget.companyBeans.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(widget.companyBeans[index].shipping_name),
              onTap: () => {
                _courierName = widget.companyBeans[index].shipping_name,
                Navigator.of(context).pop()
              },
            ),
          ),
        ),
      );
    });
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
  void onHandle(String order_id, String courier_name, String order_num);
}

//扫描二维码
Future<String> getQrcodeState() async {
  try {
    const ScanOptions options = ScanOptions(
      strings: {
        'cancel': '取消',
        'flash_on': '开启闪光灯',
        'flash_off': '关闭闪光灯',
      },
    );
    final ScanResult result = await BarcodeScanner.scan(options: options);
    return result.rawContent;
  } catch (e) {}
  return null;
}
