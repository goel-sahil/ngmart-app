class CategoryListResponse {
  List<Data> data;

  CategoryListResponse({this.data});

  CategoryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int id;
  String title;
  String image;
  Null categoryId;
  int status;
  String createdAt;
  String updatedAt;
  int isDeleted;
  String imageUrl;
  List<Categories> categories;

  Data(
      {this.id,
        this.title,
        this.image,
        this.categoryId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.imageUrl,
        this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    imageUrl = json['image_url'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_deleted'] = this.isDeleted;
    data['image_url'] = this.imageUrl;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int id;
  String title;
  String image;
  int categoryId;
  int status;
  String createdAt;
  String updatedAt;
  int isDeleted;
  String imageUrl;

  Categories(
      {this.id,
        this.title,
        this.image,
        this.categoryId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isDeleted,
        this.imageUrl});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_deleted'] = this.isDeleted;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
