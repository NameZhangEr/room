class ListResponse {
  int code;
  String msg;
  List<dynamic> data;

  ListResponse({this.code, this.msg, this.data});

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse(
        code: json['code'],
        msg: json['msg'],
        data: json['data']
    );
  }
}