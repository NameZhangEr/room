class CourierBean {
  String goodsTitle;
  String originalImg;
  String goodsDesc;
  String tel;
  String consignee;
  String address;
  String orderName;
  String orderCode;
  int orderId;
  int orderStatus;
  int goodsId;
  int goodsNum;
  int shipping;

  CourierBean({this.goodsTitle, this.originalImg, this.goodsDesc, this.tel, this.consignee, this.address, this.orderName, this.orderCode, this.orderId, this.orderStatus, this.goodsId, this.goodsNum, this.shipping});

  CourierBean.fromJson(Map<String, dynamic> json) {
    this.goodsTitle = json['goods_title'];
    this.originalImg = json['original_img'];
    this.goodsDesc = json['goods_desc'];
    this.tel = json['tel'];
    this.consignee = json['consignee'];
    this.address = json['address'];
    this.orderName = json['order_name'];
    this.orderCode = json['order_code'];
    this.orderId = json['order_id'];
    this.orderStatus = json['order_status'];
    this.goodsId = json['goods_id'];
    this.goodsNum = json['goods_num'];
    this.shipping = json['shipping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_title'] = this.goodsTitle;
    data['original_img'] = this.originalImg;
    data['goods_desc'] = this.goodsDesc;
    data['tel'] = this.tel;
    data['consignee'] = this.consignee;
    data['address'] = this.address;
    data['order_name'] = this.orderName;
    data['order_code'] = this.orderCode;
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    data['goods_id'] = this.goodsId;
    data['goods_num'] = this.goodsNum;
    data['shipping'] = this.shipping;
    return data;
  }

}
