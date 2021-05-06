class ServiceBean {
  String username;
  String room_num;
  String status;
  String type;
  String addtime;
  String go_end_time;
  String handle_time;
  String truename;

  ServiceBean(
      {this.username,
      this.room_num,
      this.status,
      this.type,
      this.addtime,
      this.go_end_time,
      this.handle_time,
      this.truename});

  factory ServiceBean.fromJson(Map<String, dynamic> json) {
    return ServiceBean(
      username: json['username'],
      room_num: json['room_num'],
      status: json['status'].toString(),
      type: json['type'].toString(),
      addtime: json['addtime'].toString(),
      go_end_time: json['go_end_time'].toString(),
      handle_time: json['handle_time'].toString(),
      truename: json['truename'].toString()
    );
  }

  @override
  String toString() {
    return 'ServiceBean{username: $username, room_num: $room_num, status: $status, type: $type, addtime: $addtime, go_end_time: $go_end_time, handle_time: $handle_time, truename: $truename}';
  }
}
