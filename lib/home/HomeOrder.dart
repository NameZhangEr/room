import 'package:flutter/material.dart';
import 'package:room/order/CourierPage.dart';
import 'package:room/order/InvitePage.dart';
import 'package:room/order/ToRoomPage.dart';

class HomeOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeOrderState();
  }
}

class HomeOrderState extends State<HomeOrder>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildService();
  }

  Widget _buildService() {
    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            indicatorColor: Color(0xffC1AC69),
            unselectedLabelColor:  Color(0xffADADAD),
            labelColor: Color(0xffC1AC69),
              controller: _tabController, tabs: <Tab>[
            Tab(text: '自取'),
            Tab(text: '送到房间'),
            Tab(text: '快递'),
          ]),
          Expanded(
            child: TabBarView(controller: _tabController, children: <Widget>[
              InvitePage(),
              ToRoomPage(),
              CourierPage(),
            ]),
          ),
        ],
      ),
    );
  }
}
