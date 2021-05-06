class Response {
  int code;
  String msg;
  dynamic data;

  Response({this.code, this.msg, this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        code: json['code'],
        msg: json['msg'],
        data: json['data']
    );
  }
}