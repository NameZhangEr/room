class CompanyBean {
  String shipping_name;

  CompanyBean({this.shipping_name});

  CompanyBean.fromJson(Map<String, dynamic> json) {
    this.shipping_name = json['shipping_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipping_name'] = this.shipping_name;
    return data;
  }

}
