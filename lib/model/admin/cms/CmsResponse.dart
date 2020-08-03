class CmsResponse {
  List<CmsData> data;

  CmsResponse({this.data});

  CmsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CmsData>();
      json['data'].forEach((v) {
        data.add(new CmsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CmsData {
  int id;
  String title;
  String description;
  String slug;
  int status;
  String createdAt;
  String updatedAt;

  CmsData(
      {this.id,
        this.title,
        this.description,
        this.slug,
        this.status,
        this.createdAt,
        this.updatedAt});

  CmsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    slug = json['slug'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
