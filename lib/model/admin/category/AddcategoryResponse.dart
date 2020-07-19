class AdminAddcategoryResponse {
  String message;
  Data data;

  AdminAddcategoryResponse({this.message, this.data});

  AdminAddcategoryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String title;
  String categoryId;
  int status;
  String image;
  String updatedAt;
  String createdAt;
  int id;
  String imageUrl;

  Data(
      {this.title,
        this.categoryId,
        this.status,
        this.image,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    categoryId = json['category_id'];
    status = json['status'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
