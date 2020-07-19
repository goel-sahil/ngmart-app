class AddBrandRequest {
  String title;
  int status;

  AddBrandRequest({this.title,this.status});

  AddBrandRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}
