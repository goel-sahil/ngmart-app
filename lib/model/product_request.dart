class ProductRequest {
  List<int> categoryId;

  ProductRequest({this.categoryId});

  ProductRequest.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    return data;
  }
}