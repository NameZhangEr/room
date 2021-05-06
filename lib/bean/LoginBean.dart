class LoginBean {
  String msg;
  String username;
  String headPic;
  String token;
  String appid;
  String appservice;
  int code;
  int isStatus;
  int serviceId;
  int customerServiceType;

  LoginBean(
      {this.msg, this.username, this.headPic, this.token, this.appid, this.appservice, this.code, this.isStatus, this.serviceId, this.customerServiceType});

  factory LoginBean.fromJson(Map<String, dynamic> json) {
    return LoginBean(msg: json['msg'],
        username: json['username'],
        headPic: json['head_pic'],
        token: json['token'],
        appid: json['appid'],
        appservice: json['appservice'],
        code: json['code'],
        isStatus : json['is_status'],
        serviceId : json['service_id'],
        customerServiceType : json['customer_service_type']);
  }

}
