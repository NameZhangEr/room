class RoomBean {
  String tel;
  String consignee;
  String room_code;
  String order_id;
  String shop_code;
  String goods_sn;
  List<OrderAllBean> order_all;

  RoomBean(
      {this.tel,
      this.consignee,
      this.room_code,
      this.order_id,
      this.shop_code,
      this.goods_sn,
      this.order_all});

  factory RoomBean.fromJson(Map<String, dynamic> json) {
    List<dynamic> _list = json['order_all'];
    return RoomBean(
        tel: json['tel'].toString(),
        consignee: json['consignee'].toString(),
        room_code: json['room_code'].toString(),
        order_id: json['order_id'].toString(),
        goods_sn: json['goods_sn'].toString(),
        order_all: _list.map((e) => OrderAllBean.fromJson(e)).toList(),
        shop_code: json['shop_code'].toString());
  }
}

class OrderAllBean {
  String goods_title;
  String goods_num;
  String goods_desc;
  String original_img;

  OrderAllBean(
      {this.goods_title,
      this.goods_num,
      this.goods_desc,
      this.original_img});

  factory OrderAllBean.fromJson(Map<String, dynamic> json) {
    return OrderAllBean(
        goods_title: json['goods_title'].toString(),
        goods_num: json['goods_num'].toString(),
        goods_desc: json['goods_desc'].toString(),
        original_img: json['original_img'].toString());
  }
}
