import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room/adapter/CourierListWidget.dart';
import 'package:room/bean/CompanyBean.dart';
import 'package:room/bean/CourierBean.dart';
import 'package:room/response/ListResponse.dart';
import 'package:room/util/HttpUtils.dart';
import 'package:room/util/LoadingDialog.dart';
import 'package:room/util/SpUtils.dart';
import 'package:room/util/UrlUtils.dart';
import 'package:room/widget/EmptyWidget.dart';

class CourierPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CourierPageState();
  }
}

class CourierPageState extends State<CourierPage>
    with AutomaticKeepAliveClientMixin
    implements OnHandleClickListener {
  List<CourierBean> courierBeans = [];
  List<CompanyBean> companyBeans = [];

  //判断是否接口加载完成
  bool isFinished = false;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getCourierData();
    _getCompanyData();
  }

  @override
  Widget build(BuildContext context) {
    return listRoom();
  }

  Widget listRoom() {
    bool isVisible = true;
    if (isFinished) {
      isVisible = courierBeans.isNotEmpty;
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
                      return CourierListWidget(
                        index: index,
                        length: courierBeans.length,
                        bean: this.courierBeans[index],
                        companyBeans: this.companyBeans,
                        callBack: this,
                      );
                    },
                    itemCount: courierBeans.length)),
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
    courierBeans.clear();
    _getCourierData();
  }

  //获取数据
  _getCourierData() async {
    Map<String, String> map = Map<String, String>();
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    HttpController.getData(UrlUtils.EXPRESS, (data) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: isLoading ? 0 : 2000), () {
        isFinished = true;
        isLoading = true;
        ListResponse response = ListResponse.fromJson(data);
        setState(() {
          if (response.code == 1) {
            courierBeans =
                response.data.map((e) => CourierBean.fromJson(e)).toList();
          }
        });
      });
    }, params: map);
  }

  //获取快递公司数据
  _getCompanyData() async {
    Map<String, String> map = Map<String, String>();
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    HttpController.getData(UrlUtils.COURIER_COMPANYS, (data) {
      if (!mounted) return;
      ListResponse response = ListResponse.fromJson(data);
      setState(() {
        if (response.code == 1) {
          companyBeans =
              response.data.map((e) => CompanyBean.fromJson(e)).toList();
        }
      });
    }, params: map);
  }

  @override
  void onHandle(String order_id, String courier_name, String order_num) async {
    //寄件
    Map<String, String> map = Map<String, String>();
    map["order_id"] = order_id;
    map["express_name"] = courier_name;
    map["express_number"] = order_num;
    map["appId"] = SpUtils.getString('HOTEL_APP_ID');
    print(map.toString());
    HttpController.getData(UrlUtils.EXPRESS_SEND, (data) {
      if (!mounted) return;
      ListResponse response = ListResponse.fromJson(data);
      if (response.code == 1) {
        _getCourierData();
      } else {
        Fluttertoast.showToast(msg: response.msg, gravity: ToastGravity.CENTER);
      }
    }, params: map);
  }
}
