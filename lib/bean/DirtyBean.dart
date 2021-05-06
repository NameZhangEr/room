class DirtyBean {
  String dirty_id;
  String service_id;
  String time;
  String room_num;
  String status;
  String go_end_time;
  String go_time;
  String out_time;

  DirtyBean(
      {this.dirty_id,
      this.room_num,
      this.status,
      this.time,
      this.service_id,
      this.go_end_time,
      this.go_time,
      this.out_time});

  factory DirtyBean.fromJson(Map<String, dynamic> json) {
    return DirtyBean(
        dirty_id: json['dirty_id'].toString(),
        room_num: json['room_num'].toString(),
        status: json['status'].toString(),
        time: json['time'].toString(),
        go_end_time: json['go_end_time'].toString(),
        go_time: json['go_time'].toString(),
        service_id: json['service_id'].toString(),
        out_time: json['out_time'].toString());
  }

}
